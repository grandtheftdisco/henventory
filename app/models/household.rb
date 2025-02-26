class Household < ApplicationRecord
  has_many :users
  has_many :chickens
end
