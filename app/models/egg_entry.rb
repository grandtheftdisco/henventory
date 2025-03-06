class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken

  validate :household_owns_chicken!
  validate :only_2_eggs_max_per_day_per_chicken!
  
  def household_owns_chicken!
    collection_entry.user.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end

  def only_2_eggs_max_per_day_per_chicken!
    # array of the chicken_ids of any chickens with egg_entries inside the current collection entry
    ee_chicken_id_array = collection_entry.egg_entries.map do |ee|
      ee.chicken_id
    end

    return if ee_chicken_id_array.length == 0 

    # TODO - how to scope for household ?
    todays_egg_entries = EggEntry.where("created_at > ? AND created_at < ?", DateTime.now.localtime.beginning_of_day, DateTime.now.localtime.end_of_day)

    todays_egg_entries_for_chicken = []

    ee_chicken_id_array.each do |chk_id|
      todays_egg_entries_for_chicken = todays_egg_entries.where(chicken_id: chk_id)
      if todays_egg_entries_for_chicken.length <= 1
        return
      elsif todays_egg_entries_for_chicken.length >= 2
        # throw error
        errors.add(:base, :invalid, message: '-- This chicken can\'t lay any more eggs today 😴🐔')
      end
    end 

  end
end
