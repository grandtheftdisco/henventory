class AddNotesToCollectionEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :collection_entries, :notes, :text
  end
end
