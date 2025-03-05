class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken

  validate :only_2_eggs_max_per_day_per_chicken!

    def only_2_eggs_max_per_day_per_chicken!
    # TASK 1

    # ✔ --- 1. get array of current household's chickens.
    household_chickens = collection_entry.user.household.chickens

    # 2. find the chicken in question via chicken_id, call that current_chicken_id
    # "undefined method `chicken` for an instance of ActiveRecord::Associations::CollectionProxy"
    # left off here 
    current_chicken_id = collection_entry.egg_entries.chicken.id

    # ✔ --- 2b. filter for today's EEs only
    # TODO - how to scope for household ?
    todays_egg_entries = EggEntry.where("created_at > ? AND created_at < ?", DateTime.now.localtime.beginning_of_day, DateTime.now.localtime.end_of_day)

    # ✔ --- 3. once you have current_chicken_id, use it to search for egg entries within todays_egg_entries that have the same chicken id
    todays_egg_entries_for_chicken = todays_egg_entries.where(chicken_id: current_chicken_id)

    # TASK 2

    # 4. step #3 will either yield a) an empty array or b) an array of egg entries.

    # 4a. if the array is empty go ahead and save the ee
    if todays_egg_entries_for_chicken.length <= 1
      return
    elsif todays_egg_entries_for_chicken.length >= 2
      # throw error
      errors.add(:current_chicken_id, 'can\'t lay any more eggs today 😴🐔')
    end

  end

  validate :household_owns_chicken!

  def household_owns_chicken!
    collection_entry.user.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end
end
