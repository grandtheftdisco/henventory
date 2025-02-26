class Chicken < ApplicationRecord
  has_many :egg_entries
  has_one :household
end
