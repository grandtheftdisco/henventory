class CreateHouseholds < ActiveRecord::Migration[8.0]
  def change
    create_table :households do |t|
      t.timestamps
    end
  end
end
