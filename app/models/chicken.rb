class Chicken < ApplicationRecord
  has_many :egg_entries
  belongs_to :household
end
