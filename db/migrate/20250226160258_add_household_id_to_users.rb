class AddHouseholdIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :household_id, :integer
  end
end
