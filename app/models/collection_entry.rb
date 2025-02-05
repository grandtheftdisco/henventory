class CollectionEntry < ApplicationRecord
  has_many :egg_entries, dependent: :destroy
  accepts_nested_attributes_for :egg_entries
end
