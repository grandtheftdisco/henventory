class AddUseridFkToChickens < ActiveRecord::Migration[8.0]
  def change
    add_column :chickens, :user_id, :integer
  end
end
