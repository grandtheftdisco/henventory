class EggEntry < ApplicationRecord
  belongs_to :collection_entry
end

# adding in the `belongs_to` line ensures that the EggEntry class knows about the relationship it has with CollectionEntry, and also adds inverse methods to the EggEntry class, ie `egg_entry.collection_entry`