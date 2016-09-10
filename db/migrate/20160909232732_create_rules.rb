class CreateRules < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.string :name
      t.text :description
      t.integer :sport_id

      t.timestamps
    end
  end
end
