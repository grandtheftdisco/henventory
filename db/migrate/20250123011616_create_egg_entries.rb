class CreateEggEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :egg_entries do |t|
      t.integer :egg_count
      t.integer :chicken_id
      t.integer :collection_entry_id

      t.timestamps
    end
  end
end
