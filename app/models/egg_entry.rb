class EggEntry < ApplicationRecord
  belongs_to :collection_entry
  belongs_to :chicken

  # rejects EEs with an egg_count of 0 (ie, unchecked box)
  validates :egg_count, acceptance: true

  # validation for 2 egg max
  validate :only_2_eggs_max_per_day_per_chicken!

  def only_2_eggs_max_per_day_per_chicken!
    # sum the total # of eggs logged for this chicken today
    # if total exceeds 2, throw error to prevent submission of form
  end


  validate :household_owns_chicken!

  def household_owns_chicken!
    collection_entry.user.household.chickens.find(chicken_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:chicken_id, 'must be owned by household')
  end
end
