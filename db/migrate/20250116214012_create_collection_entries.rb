class CreateCollectionEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :collection_entries do |t|
      t.integer :count
      t.integer :user_id
      t.integer :chicken_id

      t.timestamps
    end
  end
end
