class Household < ApplicationRecord
  has_secure_token :invite_token # to regenerate, use `#regenerate_invite_token`
  has_many :users
  has_many :chickens
  has_many :collection_entries
  
  # do i need to define `member?` method here, or is that devise-specific?

  # overrides default behavior of to_param so that :invite_token is used instead of :id
  def to_param
    invite_token
  end
end
