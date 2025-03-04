class Household < ApplicationRecord
  has_many :users
  has_many :chickens
  has_many :collection_entries
end
