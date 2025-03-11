class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken, optional: true 

  validate :household_owns_chicken!, if: :in_layer_mode?
  validate :only_2_eggs_max_per_day_per_chicken!
  
  def in_layer_mode?
    Current.user.mode == "layer"
  end
  
  def household_owns_chicken!
    collection_entry.user.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end

  def only_2_eggs_max_per_day_per_chicken!
    return if EggEntry.for_today.where(chicken_id: self.chicken_id).count <= 1 #self isn't needed here
    errors.add(:base, :invalid, message: '-- This chicken can\'t lay any more eggs today 😴🐔')
  end

  def self.for_today
    where("created_at > ? AND created_at < ?", DateTime.now.localtime.beginning_of_day, DateTime.now.localtime.end_of_day)
  end
end
