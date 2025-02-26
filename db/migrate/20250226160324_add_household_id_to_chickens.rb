class AddHouseholdIdToChickens < ActiveRecord::Migration[8.0]
  def change
    add_column :chickens, :household_id, :integer
  end
end
