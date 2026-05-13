require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Drive the actual login form so Current.session is populated the same
  # way it would be in production. Fixture users have password "password"
  # via a shared digest in test/fixtures/users.yml.
  def sign_in_as(user, password: "password")
    visit new_session_url
    fill_in "Email", with: user.email_address
    fill_in "Password", with: password
    click_button "Sign in"
  end
end
