class AddAccentColorsToChickens < ActiveRecord::Migration[8.0]
  def change
    add_column :chickens, :accent_color, :string
    add_column :chickens, :accent_secondary, :string
  end
end
