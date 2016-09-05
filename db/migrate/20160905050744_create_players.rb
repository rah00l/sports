class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.text :bio
      t.integer :sport_id

      t.timestamps
    end
  end
end
