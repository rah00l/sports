class CreateEquipment < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment do |t|
      t.string :name
      t.integer :sport_id
      t.text :description

      t.timestamps
    end
  end
end
