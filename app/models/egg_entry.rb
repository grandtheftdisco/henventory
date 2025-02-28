class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken

  validate :household_owns_chicken!

  def household_owns_chicken!
    Current.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end
end
