class AddStatusColumnToChicken < ActiveRecord::Migration[8.0]
  def change
    add_column :chickens, :status, :string
  end
end
