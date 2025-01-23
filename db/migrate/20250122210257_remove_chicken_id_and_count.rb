class RemoveChickenIdAndCount < ActiveRecord::Migration[8.0]
  def change
    remove_column :collection_entries, :chicken_id, :integer
    remove_column :collection_entries, :count, :integer
  end
end
