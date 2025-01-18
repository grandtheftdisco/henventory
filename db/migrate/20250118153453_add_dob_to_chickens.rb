class AddDobToChickens < ActiveRecord::Migration[8.0]
  def change
    add_column :chickens, :dob, :date
  end
end
