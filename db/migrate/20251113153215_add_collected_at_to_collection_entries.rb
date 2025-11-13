class AddCollectedAtToCollectionEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :collection_entries, :collected_at, :datetime
    add_index :collection_entries, :collected_at
  end
end
