class AddTokenColumnToHousehold < ActiveRecord::Migration[8.0]
  def change
    add_column :households, :invite_token, :string
    add_index :households, :invite_token, unique: true
  end
end
