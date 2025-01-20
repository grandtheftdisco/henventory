class AddImageUrlToChickens < ActiveRecord::Migration[8.0]
  def change
    add_column :chickens, :image_url, :string
  end
end
