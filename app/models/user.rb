class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :household
  has_many :chickens
  has_many :collection_entries

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end