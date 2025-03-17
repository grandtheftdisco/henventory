class AddModeColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :mode, :string
  end
end
