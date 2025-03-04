class AddNameToHouseholds < ActiveRecord::Migration[8.0]
  def change
    add_column :households, :name, :string
  end
end
