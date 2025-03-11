class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken, optional: true 

  validate :household_owns_chicken!, if: :in_layer_mode?

  def in_layer_mode?
    Current.user.mode == "layer"
  end

  def household_owns_chicken!
    collection_entry.user.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end
end
