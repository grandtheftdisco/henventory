class AddCollectedAtToCollectionEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :collection_entries, :collected_at, :datetime
  end
end
