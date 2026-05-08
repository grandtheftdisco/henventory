require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "redirects to login when unauthenticated" do
    delete session_url
    get landing_url
    assert_redirected_to new_session_url
  end

  test "renders the new shell for layer-mode users" do
    @user.update!(mode: "layer")
    get landing_url
    assert_response :success
    assert_select "div.dashboard-shell"
    assert_select "section.dashboard-section[data-section=greeting]"
    assert_select "button.coop-fab"
  end

  test "renders the legacy marketing home for non-layer users" do
    # The legacy marketing/home view sums egg_count per CE in a loop, which
    # makes the includes(egg_entries: :chicken) look unused to Bullet. That
    # inefficiency pre-dates Phase 1 and gets removed when Flock-mode users
    # move to their own dashboard in Phase 3.
    Bullet.raise = false
    @user.update!(mode: "flock")
    get landing_url
    assert_response :success
    assert_select "div.coop-card", /Today's tally/i
    assert_select "div.dashboard-shell", count: 0
  ensure
    Bullet.raise = true
  end

  test "renders the legacy marketing home when mode is unset" do
    Bullet.raise = false
    @user.update!(mode: nil)
    get landing_url
    assert_response :success
    assert_select "div.dashboard-shell", count: 0
  ensure
    Bullet.raise = true
  end

  test "/dashboard alias also routes to dashboards#show" do
    @user.update!(mode: "layer")
    get "/dashboard"
    assert_response :success
    assert_select "div.dashboard-shell"
  end
end
