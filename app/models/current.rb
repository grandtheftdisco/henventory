class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
  delegate :household, to: :session, allow_nil: true
end