class CollectionEntry < ApplicationRecord
  has_many :egg_entries, dependent: :destroy
  accepts_nested_attributes_for :egg_entries, allow_destroy: true
  belongs_to :household
  belongs_to :user
end