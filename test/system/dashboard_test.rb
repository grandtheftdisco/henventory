require "application_system_test_case"

# End-to-end tests for the Phase 1 Layer-mode dashboard. The default
# headless Chrome screen size is 1400×1400 — well above the 1024px
# breakpoint — so we exercise the inline desktop Quick-Log here.
# Mobile/bottom-sheet flows are tested separately by resizing the
# window in the relevant test.
#
# Requires Google Chrome + chromedriver in PATH (selenium-webdriver
# 4.x auto-downloads chromedriver if Chrome is present). On a machine
# without Chrome installed, all tests in this file will error out
# during driver setup; the existing controller-level tests in
# test/controllers/{dashboards,collection_entries}_controller_test.rb
# cover the same submission and rendering behavior at the request layer.
class DashboardTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @household = households(:one)
    @user.update!(mode: "layer")
    # The fixture household has eggs from days ago but nothing today by
    # default; ensure today is a clean slate so we can assert on freshly
    # logged eggs without fixture noise.
    @household.collection_entries.destroy_all
    sign_in_as(@user)
  end

  test "Quick-Log happy path: select hen, log 1 egg" do
    visit landing_url

    chicken = @household.chickens.first
    within "turbo-frame#quick_log_inline" do
      find(".quick-log-pill", text: chicken.name).click
      click_button "1 egg"
    end

    # The Today's Collections frame refreshes via Turbo Stream and now
    # shows the new entry. A mini-card with "1 egg" should be visible.
    assert_selector "turbo-frame#todays_collections .dashboard-todays-card", text: "1 egg"
    assert_equal 1, @household.collection_entries.count
  end

  test "Quick-Log happy path: log 2 eggs" do
    visit landing_url

    chicken = @household.chickens.first
    within "turbo-frame#quick_log_inline" do
      find(".quick-log-pill", text: chicken.name).click
      click_button "2 eggs"
    end

    assert_selector "turbo-frame#todays_collections .dashboard-todays-card", text: "2 eggs"
    entry = @household.collection_entries.last
    assert_equal 2, entry.egg_entries.sum(:egg_count)
  end

  test "Quick-Log with +note expansion submits a note" do
    visit landing_url

    chicken = @household.chickens.first
    within "turbo-frame#quick_log_inline" do
      find(".quick-log-pill", text: chicken.name).click
      click_button "+ note"
      fill_in "collection_entry[notes]", with: "Found one in the bush"
      click_button "1 egg"
    end

    entry = @household.collection_entries.last
    assert_equal "Found one in the bush", entry.notes
  end

  test "Quick-Log rejects a third egg from the same hen today" do
    chicken = @household.chickens.first
    # Pre-seed two entries today so the next submit will be rejected.
    2.times do
      ce = @household.collection_entries.create!(user: @user, created_at: Time.current)
      ce.egg_entries.create!(chicken: chicken, egg_count: 1)
    end

    visit landing_url

    # The maxed-out hen should be excluded from the visible pills entirely
    # (Q1 first-pass rule). Verify by name absence.
    assert_no_selector "turbo-frame#quick_log_inline .quick-log-pill", text: chicken.name
    # Exactly two entries already exist; nothing should be added.
    assert_equal 2, @household.collection_entries.count
  end

  test "tapping a calendar day navigates to the Today view for that date" do
    visit landing_url

    today = Time.current.in_time_zone(@household.time_zone).to_date
    within "section[data-section='calendar']" do
      find(".dashboard-calendar-day.is-today").click
    end

    assert_current_path today_path(date: today.iso8601)
  end

  test "mobile FAB opens the bottom sheet which contains the Quick-Log" do
    page.driver.browser.manage.window.resize_to(420, 900)
    visit landing_url

    # Sheet starts hidden.
    sheet = find(".coop-bottom-sheet", visible: :all)
    assert_equal "false", sheet["data-open"]

    find(".coop-fab").click

    # After tap, sheet's data-open flips to "true".
    assert_equal "true", sheet["data-open"]
    assert_selector "turbo-frame#quick_log_sheet"
  ensure
    page.driver.browser.manage.window.resize_to(1400, 1400)
  end
end
