require "test_helper"

class DashboardStatsTest < ActiveSupport::TestCase
  # Factory helpers — small, opinionated, hand-built (not using FactoryBot).
  # Each test gets a fresh household so state never leaks across tests.

  def make_household(time_zone: "UTC")
    Household.create!(name: "Test Coop #{SecureRandom.hex(3)}", time_zone: time_zone)
  end

  def make_user(household)
    User.new(
      email_address: "u#{SecureRandom.hex(3)}@example.com",
      password: "password",
      household: household,
      mode: "layer"
    ).tap do |u|
      u.skip_account_seed = true
      u.save!
    end
  end

  def make_chicken(household, name:, breed: "Rhode Island Red", status: "layer")
    Chicken.create!(
      name: name,
      breed: breed,
      tell: "tell-#{name}",
      dob: 1.year.ago,
      status: status,
      household: household
    )
  end

  # Logs `count` eggs for a chicken at `at` (a Time). The collection_entry
  # gets created_at = at; the egg_entry inherits the same created_at via
  # explicit assignment (Rails would otherwise stamp Time.current).
  def log_eggs(household, user, chicken, count:, at:)
    entry = household.collection_entries.create!(
      user: user,
      created_at: at,
      updated_at: at,
      collected_at: at
    )
    egg = entry.egg_entries.create!(chicken: chicken, egg_count: count)
    egg.update_columns(created_at: at, updated_at: at)
    entry
  end

  setup do
    # Pin "now" to a known weekday-Wednesday so beginning_of_week math is
    # stable: 2026-04-29 is a Wednesday in any TZ.
    @now = Time.zone.parse("2026-04-29 14:00:00 UTC")
    @household = make_household
    @user = make_user(@household)
  end

  # ---- today_count ----

  test "today_count sums egg counts created today, excludes other days" do
    chicken = make_chicken(@household, name: "Penelope")
    log_eggs(@household, @user, chicken, count: 2, at: @now - 2.hours)
    log_eggs(@household, @user, chicken, count: 1, at: @now - 1.day)

    stats = DashboardStats.new(@household, now: @now)
    assert_equal 2, stats.today_count
  end

  test "today_count returns 0 for an empty household" do
    stats = DashboardStats.new(@household, now: @now)
    assert_equal 0, stats.today_count
  end

  test "today_count filters by parent CE's created_at, not the egg's" do
    # Regression guard for Issue A from the Phase 0 review: stats must be
    # internally consistent on a single dashboard render. If a CE was
    # created today but contains an egg whose own created_at is yesterday
    # (possible if the egg was added later via nested_attributes_for, or
    # if anyone backfills timestamps), the egg should still count toward
    # today's tally because the *collection* happened today.
    chicken = make_chicken(@household, name: "Penelope")
    entry = @household.collection_entries.create!(user: @user, created_at: @now - 1.hour)
    EggEntry.insert!({
      collection_entry_id: entry.id,
      chicken_id: chicken.id,
      egg_count: 2,
      created_at: @now - 2.days,  # backdated egg timestamp
      updated_at: @now - 2.days
    })

    stats = DashboardStats.new(@household, now: @now)
    assert_equal 2, stats.today_count
    assert_equal 1, stats.today_collections_count
  end

  # ---- today_collections_count ----

  test "today_collections_count counts collection_entries today only" do
    chicken = make_chicken(@household, name: "Penelope")
    log_eggs(@household, @user, chicken, count: 2, at: @now - 1.hour)
    log_eggs(@household, @user, chicken, count: 1, at: @now - 3.hours)
    log_eggs(@household, @user, chicken, count: 1, at: @now - 2.days)

    stats = DashboardStats.new(@household, now: @now)
    assert_equal 2, stats.today_collections_count
  end

  # ---- this_week_count + change pct + sparkline ----

  test "this_week_count sums egg entries within the week (Mon-Sun)" do
    chicken = make_chicken(@household, name: "Penelope")
    monday = @now.beginning_of_week
    log_eggs(@household, @user, chicken, count: 2, at: monday + 1.hour)
    log_eggs(@household, @user, chicken, count: 1, at: @now)
    # outside the week
    log_eggs(@household, @user, chicken, count: 5, at: monday - 1.day)

    stats = DashboardStats.new(@household, now: @now)
    assert_equal 3, stats.this_week_count
  end

  test "this_week_change_pct returns rounded delta vs prior week" do
    chicken = make_chicken(@household, name: "Penelope")
    log_eggs(@household, @user, chicken, count: 2, at: @now)
    log_eggs(@household, @user, chicken, count: 1, at: @now - 7.days)
    # 1 -> 3 is +200%
    stats = DashboardStats.new(@household, now: @now)
    # this_week = 2, last_week = 1 → +100
    assert_equal 100, stats.this_week_change_pct
  end

  test "this_week_change_pct returns nil when last week had no eggs" do
    chicken = make_chicken(@household, name: "Penelope")
    log_eggs(@household, @user, chicken, count: 2, at: @now)

    stats = DashboardStats.new(@household, now: @now)
    assert_nil stats.this_week_change_pct
  end

  test "this_week_sparkline_data returns daily counts keyed by ISO date" do
    chicken = make_chicken(@household, name: "Penelope")
    monday = @now.beginning_of_week
    log_eggs(@household, @user, chicken, count: 2, at: monday + 1.hour)
    log_eggs(@household, @user, chicken, count: 1, at: monday + 1.day + 2.hours)

    stats = DashboardStats.new(@household, now: @now)
    data = stats.this_week_sparkline_data

    assert_equal 2, data[monday.to_date.iso8601]
    assert_equal 1, data[(monday + 1.day).to_date.iso8601]
  end

  # ---- active_hens ----

  test "active_hens_count includes pullet/layer/molting, excludes retired/expired" do
    make_chicken(@household, name: "P", status: "pullet")
    make_chicken(@household, name: "L", status: "layer")
    make_chicken(@household, name: "M", status: "molting")
    make_chicken(@household, name: "R", status: "retired")
    make_chicken(@household, name: "E", status: "expired")

    stats = DashboardStats.new(@household, now: @now)
    assert_equal 3, stats.active_hens_count
  end

  test "active_hens_breakdown surfaces molting and retired counts only" do
    make_chicken(@household, name: "L", status: "layer")
    make_chicken(@household, name: "M1", status: "molting")
    make_chicken(@household, name: "M2", status: "molting")
    make_chicken(@household, name: "R", status: "retired")

    stats = DashboardStats.new(@household, now: @now)
    assert_equal "2 molting · 1 retired", stats.active_hens_breakdown
  end

  test "active_hens_breakdown returns empty string when nothing notable" do
    make_chicken(@household, name: "L", status: "layer")
    stats = DashboardStats.new(@household, now: @now)
    assert_equal "", stats.active_hens_breakdown
  end

  # ---- best_in_flock_this_month ----

  test "best_in_flock_this_month returns top hen and count this month" do
    p = make_chicken(@household, name: "Penelope")
    l = make_chicken(@household, name: "Louise")
    log_eggs(@household, @user, p, count: 2, at: @now - 1.day)
    log_eggs(@household, @user, p, count: 2, at: @now - 2.days)
    log_eggs(@household, @user, l, count: 1, at: @now - 1.day)

    stats = DashboardStats.new(@household, now: @now)
    result = stats.best_in_flock_this_month

    assert_equal p.id, result[:chicken].id
    assert_equal 4, result[:egg_count]
  end

  test "best_in_flock_this_month returns nil when no eggs this month" do
    stats = DashboardStats.new(@household, now: @now)
    assert_nil stats.best_in_flock_this_month
  end

  # ---- employee_of_the_month ----

  test "employee_of_the_month returns top N chickens with rank" do
    p = make_chicken(@household, name: "Penelope")
    l = make_chicken(@household, name: "Louise")
    h = make_chicken(@household, name: "Henderson")
    log_eggs(@household, @user, p, count: 2, at: @now)
    log_eggs(@household, @user, p, count: 2, at: @now - 1.day)
    log_eggs(@household, @user, l, count: 2, at: @now)
    log_eggs(@household, @user, h, count: 1, at: @now)

    stats = DashboardStats.new(@household, now: @now)
    rows = stats.employee_of_the_month(limit: 3)

    assert_equal 3, rows.length
    assert_equal p.id, rows[0][:chicken].id
    assert_equal 4, rows[0][:egg_count]
    assert_equal 1, rows[0][:rank]
    assert_equal 2, rows[1][:rank]
    assert_equal 3, rows[2][:rank]
  end

  test "employee_of_the_month skips chicken_id NULL flock-mode entries" do
    p = make_chicken(@household, name: "Penelope")
    log_eggs(@household, @user, p, count: 2, at: @now)
    # Flock-mode entry has chicken_id: nil. The existing EggEntry model has
    # an unrelated bug where this fails validation; bypass via insert.
    entry = @household.collection_entries.create!(user: @user, created_at: @now)
    EggEntry.insert!({
      collection_entry_id: entry.id,
      chicken_id: nil,
      egg_count: 5,
      created_at: @now,
      updated_at: @now
    })

    stats = DashboardStats.new(@household, now: @now)
    rows = stats.employee_of_the_month
    assert_equal 1, rows.length
    assert_equal p.id, rows[0][:chicken].id
  end

  test "employee_of_the_month returns empty array with no eggs" do
    stats = DashboardStats.new(@household, now: @now)
    assert_equal [], stats.employee_of_the_month
  end

  # ---- month_calendar_data ----

  test "month_calendar_data returns daily counts keyed by ISO date" do
    chicken = make_chicken(@household, name: "Penelope")
    log_eggs(@household, @user, chicken, count: 2, at: Time.zone.parse("2026-04-15 10:00:00 UTC"))
    log_eggs(@household, @user, chicken, count: 1, at: Time.zone.parse("2026-04-15 14:00:00 UTC"))
    log_eggs(@household, @user, chicken, count: 4, at: Time.zone.parse("2026-04-22 09:00:00 UTC"))

    stats = DashboardStats.new(@household, now: @now)
    data = stats.month_calendar_data(year: 2026, month: 4)

    assert_equal 3, data["2026-04-15"]
    assert_equal 4, data["2026-04-22"]
    assert_nil data["2026-04-01"]
  end

  # ---- quick_log_eligibility ----

  test "quick_log_eligibility ranks top hens by last-7-day eggs and pushes the rest to other" do
    a = make_chicken(@household, name: "Alpha")
    b = make_chicken(@household, name: "Bravo")
    c = make_chicken(@household, name: "Charlie")
    d = make_chicken(@household, name: "Delta")
    e = make_chicken(@household, name: "Echo")

    log_eggs(@household, @user, a, count: 2, at: @now - 1.day)
    log_eggs(@household, @user, a, count: 2, at: @now - 2.days)  # alpha: 4
    log_eggs(@household, @user, b, count: 2, at: @now - 1.day)   # bravo: 2
    log_eggs(@household, @user, c, count: 1, at: @now - 1.day)   # charlie: 1
    # delta + echo: 0

    stats = DashboardStats.new(@household, now: @now)
    result = stats.quick_log_eligibility(top_n: 4)

    top_names = result[:top].map { |r| r[:chicken].name }
    other_names = result[:other].map { |r| r[:chicken].name }

    # Alpha then Bravo by score; Charlie + one zero-score in the top-4 by tiebreak;
    # the remaining zero-score hen goes to other.
    assert_equal "Alpha", top_names.first
    assert_equal "Bravo", top_names[1]
    assert_includes top_names, "Charlie"
    assert_equal 4, result[:top].length
    assert_equal 1, result[:other].length
    # Other is sorted alphabetically; both delta and echo are zero so whichever
    # tiebreaker put one in top-4, the other lands here.
    assert_includes %w[Delta Echo], other_names.first
  end

  test "quick_log_eligibility excludes hens with 2 entries today" do
    a = make_chicken(@household, name: "Alpha")
    b = make_chicken(@household, name: "Bravo")
    log_eggs(@household, @user, a, count: 1, at: @now - 1.hour)
    log_eggs(@household, @user, a, count: 1, at: @now - 30.minutes)
    log_eggs(@household, @user, b, count: 1, at: @now - 1.hour)

    stats = DashboardStats.new(@household, now: @now)
    result = stats.quick_log_eligibility

    names = (result[:top] + result[:other]).map { |r| r[:chicken].name }
    refute_includes names, "Alpha"
    assert_includes names, "Bravo"
  end

  test "quick_log_eligibility excludes retired and expired hens" do
    make_chicken(@household, name: "Alive", status: "layer")
    make_chicken(@household, name: "Retired", status: "retired")
    make_chicken(@household, name: "Expired", status: "expired")

    stats = DashboardStats.new(@household, now: @now)
    result = stats.quick_log_eligibility

    names = (result[:top] + result[:other]).map { |r| r[:chicken].name }
    assert_equal ["Alive"], names
  end

  test "quick_log_eligibility carries each hen's eggs_today count" do
    a = make_chicken(@household, name: "Alpha")
    log_eggs(@household, @user, a, count: 1, at: @now - 1.hour)

    stats = DashboardStats.new(@household, now: @now)
    row = stats.quick_log_eligibility[:top].find { |r| r[:chicken].id == a.id }
    assert_equal 1, row[:eggs_today]
  end

  # ---- timezone correctness ----

  test "today_count respects the household's time zone at the UTC day boundary" do
    # Regression guard for Issue D from the Phase 0 review: every other test
    # in this file uses UTC, which would mask a TZ-math bug. An egg logged at
    # 11pm Pacific is the *next day* in UTC, but should still count toward
    # the *Pacific* day's tally — the household lives in Pacific time.
    pacific = make_household(time_zone: "America/Los_Angeles")
    user = make_user(pacific)
    chicken = make_chicken(pacific, name: "TZ Hen")

    # 23:30 Pacific on 2026-04-29 is 06:30 UTC on 2026-04-30. "Now" for the
    # household is still 2026-04-29; the egg belongs to that day.
    pacific_evening = Time.zone.parse("2026-04-29 23:30:00 -0700")
    pacific_now = Time.zone.parse("2026-04-29 23:45:00 -0700")
    log_eggs(pacific, user, chicken, count: 3, at: pacific_evening)

    stats = DashboardStats.new(pacific, now: pacific_now)
    assert_equal 3, stats.today_count, "egg logged at 11:30pm Pacific should count toward Pacific's today"
    assert_equal 1, stats.today_collections_count

    # Same data, but "now" is the next morning in Pacific — the late-night
    # egg now belongs to *yesterday* and should NOT appear in today_count.
    next_morning = Time.zone.parse("2026-04-30 08:00:00 -0700")
    next_day_stats = DashboardStats.new(pacific, now: next_morning)
    assert_equal 0, next_day_stats.today_count
    assert_equal 0, next_day_stats.today_collections_count
  end

  # ---- todays_collections ----

  test "todays_collections returns today's entries newest-first" do
    chicken = make_chicken(@household, name: "Penelope")
    early = log_eggs(@household, @user, chicken, count: 1, at: @now - 5.hours)
    late = log_eggs(@household, @user, chicken, count: 1, at: @now - 1.hour)
    # Yesterday — should be excluded
    log_eggs(@household, @user, chicken, count: 1, at: @now - 1.day)

    stats = DashboardStats.new(@household, now: @now)
    entries = stats.todays_collections.to_a

    assert_equal 2, entries.length
    assert_equal late.id, entries.first.id
    assert_equal early.id, entries.last.id
  end
end
