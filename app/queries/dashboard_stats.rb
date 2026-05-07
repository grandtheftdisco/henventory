# Aggregations consumed by the redesigned dashboard. Scoped per household;
# all date math is done in the household's local time zone, not UTC or
# server time.
#
# Methods return plain hashes / arrays / scalars so callers don't take an
# implicit dependency on ActiveRecord scopes. No caching in v1; if any of
# these become hot, wrap the call site in a Rails fragment cache keyed on
# `[household, "dashboard", max(updated_at across egg_entries today)]`.
#
# Note on `created_at` vs `collected_at`: existing `EggEntry` records use
# `created_at` for "when did the chicken lay this egg" because
# `collection_entries.collected_at` was added recently and isn't yet
# back-propagated to per-egg timestamps. This class uses `created_at` to
# stay consistent with the existing `#today` action; revisit once the
# data backfill catches up.
class DashboardStats
  def initialize(household, now: nil)
    @household = household
    @now = (now || Time.current).in_time_zone(household_time_zone)
  end

  # ---- Today ----

  def today_count
    today_egg_entries.sum(:egg_count)
  end

  def today_collections_count
    @household.collection_entries.where(created_at: today_range).count
  end

  # ---- This week (Monday-Sunday in household TZ) ----

  def this_week_count
    egg_entries_in(this_week_range).sum(:egg_count)
  end

  # Percent change vs last week (same Mon-Sun window, shifted -7 days).
  # Returns nil when last week had zero eggs (avoid divide-by-zero and
  # the meaningless +∞ that would result).
  def this_week_change_pct
    last = egg_entries_in(last_week_range).sum(:egg_count)
    return nil if last.zero?
    (((this_week_count - last) / last.to_f) * 100).round
  end

  # 7 daily totals, oldest first, for the current week. Used by the
  # sparkline component.
  def this_week_sparkline_data
    daily_counts_for(this_week_range)
  end

  # ---- Flock ----

  # Excludes retired and expired birds; includes pullets, layers, molters.
  def active_hens_count
    active_hens_scope.count
  end

  # e.g. "1 molting · 1 retired" — just the non-default statuses worth
  # surfacing under the "Active hens" stat. Returns "" when nothing
  # interesting to say.
  def active_hens_breakdown
    bits = []
    molting = @household.chickens.where(status: "molting").count
    retired = @household.chickens.where(status: "retired").count
    bits << "#{molting} molting" if molting.positive?
    bits << "#{retired} retired" if retired.positive?
    bits.join(" · ")
  end

  # Returns { chicken: <Chicken>, egg_count: <Integer> } for the top hen
  # by egg count this calendar month. Nil if no eggs logged this month.
  def best_in_flock_this_month
    top = egg_entries_in(this_month_range)
      .where.not(chicken_id: nil)
      .group(:chicken_id)
      .sum(:egg_count)
      .max_by { |_, count| count }
    return nil unless top

    chicken_id, count = top
    chicken = @household.chickens.find_by(id: chicken_id)
    return nil unless chicken

    { chicken: chicken, egg_count: count }
  end

  # Top 4 chickens by this-month egg count. Each entry:
  # { chicken: <Chicken>, egg_count: <Integer>, rank: <Integer> }.
  # Excludes chickens with zero eggs this month.
  def employee_of_the_month(limit: 4)
    counts = egg_entries_in(this_month_range)
      .where.not(chicken_id: nil)
      .group(:chicken_id)
      .sum(:egg_count)

    return [] if counts.empty?

    chickens_by_id = @household.chickens.where(id: counts.keys).index_by(&:id)

    counts
      .sort_by { |_, count| -count }
      .first(limit)
      .each_with_index
      .filter_map do |(chicken_id, count), i|
        chicken = chickens_by_id[chicken_id]
        next unless chicken
        { chicken: chicken, egg_count: count, rank: i + 1 }
      end
  end

  # ---- Calendar ----

  # { "YYYY-MM-DD" => egg_count } for the requested month, household-local.
  # Days with zero eggs are omitted; the calendar component treats missing
  # keys as empty.
  def month_calendar_data(year:, month:)
    range = month_range(year, month)
    daily_counts_for(range)
  end

  # ---- Today's collections strip ----

  # Today's CollectionEntry records ordered most-recent first, with
  # eager-loaded egg_entries + users so the view renders without N+1.
  def todays_collections
    @household.collection_entries
      .includes(:user, egg_entries: :chicken)
      .where(created_at: today_range)
      .order(created_at: :desc)
  end

  private

  def household_time_zone
    @household.time_zone.presence || Time.zone.name
  end

  def today_range
    @now.beginning_of_day..@now.end_of_day
  end

  def this_week_range
    @now.beginning_of_week..@now.end_of_week
  end

  def last_week_range
    week_ago = @now - 1.week
    week_ago.beginning_of_week..week_ago.end_of_week
  end

  def this_month_range
    @now.beginning_of_month..@now.end_of_month
  end

  def month_range(year, month)
    first = Time.zone.local(year, month, 1).in_time_zone(household_time_zone)
    first.beginning_of_month..first.end_of_month
  end

  def today_egg_entries
    egg_entries_in(today_range)
  end

  def egg_entries_in(range)
    @household.egg_entries.where(egg_entries: { created_at: range })
  end

  def active_hens_scope
    @household.chickens.where(status: %w[pullet layer molting])
  end

  # Returns { "YYYY-MM-DD" => egg_count } for a time range, computing the
  # date from the household-local TZ. We pull egg_entries with their
  # created_at and group in Ruby — SQL DATE() functions vary across
  # SQLite/Postgres and we want predictable TZ behavior either way.
  def daily_counts_for(range)
    rows = egg_entries_in(range).pluck(:created_at, :egg_count)
    out = {}
    rows.each do |timestamp, count|
      key = timestamp.in_time_zone(household_time_zone).to_date.iso8601
      out[key] = (out[key] || 0) + count
    end
    out
  end
end
