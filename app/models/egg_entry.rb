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

end

# adding in the `belongs_to` line ensures that the EggEntry class knows about the relationship it has with CollectionEntry, and also adds inverse methods to the EggEntry class, ie `egg_entry.collection_entry`