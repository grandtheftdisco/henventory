class CreateChickens < ActiveRecord::Migration[8.0]
  def change
    create_table :chickens do |t|
      t.string :name
      t.string :breed
      t.string :tell

      t.timestamps
    end
  end
end
