ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # TODO(phase-3): remove this helper when the legacy marketing/home
    # view is retired and the only tests still needing it are gone.
    # Runs the block with Bullet.raise temporarily disabled. Bullet only
    # exposes a `raise=` writer (no reader), and `Bullet.raise` resolves
    # to Kernel#raise — so capture the previous state from UniformNotifier,
    # which is where Bullet's setter ultimately stores it.
    def with_bullet_disabled
      previous = UniformNotifier.raise
      Bullet.raise = false
      yield
    ensure
      UniformNotifier.raise = previous
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user)
    post session_url, params: { email_address: user.email_address, password: "password" }
  end
end
