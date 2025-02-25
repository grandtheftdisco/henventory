class CollectionEntry < ApplicationRecord
  has_many :egg_entries, dependent: :destroy
  accepts_nested_attributes_for :egg_entries,
    reject_if: -> (attributes) { attributes[:egg_count].blank? },
    allow_destroy: true
end

# `allow_destroy: true` allows users to delete EEs, and `reject_if` ensures that if the egg count field is left blank, it will be ignored