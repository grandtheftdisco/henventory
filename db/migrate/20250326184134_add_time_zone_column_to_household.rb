class AddTimeZoneColumnToHousehold < ActiveRecord::Migration[8.0]
  def change
    add_column :households, :time_zone, :text, default: 'America/Chicago', null: false
  end
end
