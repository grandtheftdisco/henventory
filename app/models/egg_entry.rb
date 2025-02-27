class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken

  validate :household_owns_chicken!

  def household_owns_chicken!()
    Current.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end
end

# adding in the `belongs_to` line ensures that the EggEntry class knows about the relationship it has with CollectionEntry, and also adds inverse methods to the EggEntry class, ie `egg_entry.collection_entry`