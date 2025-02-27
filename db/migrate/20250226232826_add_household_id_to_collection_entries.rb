class AddHouseholdIdToCollectionEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :collection_entries, :household_id, :integer
  end
end
