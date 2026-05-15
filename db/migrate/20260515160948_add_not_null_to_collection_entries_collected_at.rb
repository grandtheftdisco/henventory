class AddNotNullToCollectionEntriesCollectedAt < ActiveRecord::Migration[8.0]
  def change
    change_column_null :collection_entries, :collected_at, false
  end
end
