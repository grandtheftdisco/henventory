class Household < ApplicationRecord
  has_many :users
  has_many :chickens
  has_many :collection_entries
  has_secure_token :invite_token # to regenerate, use `#regenerate_invite_token`
end
