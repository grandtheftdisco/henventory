class ChangeDataTypeForDob < ActiveRecord::Migration[8.0]
  def change
    change_table :chickens do |t|
      t.change :dob, :datetime
    end
  end
end
