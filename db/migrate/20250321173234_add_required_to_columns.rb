class AddRequiredToColumns < ActiveRecord::Migration[8.0]
  def change
    change_column_null :chickens, :name, false
    change_column_null :chickens, :breed, false
    change_column_null :chickens, :user_id, false
    change_column_null :collection_entries, :user_id, false
    change_column_null :collection_entries, :household_id, false
    change_column_null :egg_entries, :egg_count, false
    # etc...
  end
end
