class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
  delegate :household, to: :session, allow_nil: true
end

# anytime you change this file or switch to a branch that has a different version of this file - restart your server. hot reloading somewhat unreliable.