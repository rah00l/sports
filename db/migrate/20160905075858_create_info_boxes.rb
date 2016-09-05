class CreateInfoBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :info_boxes do |t|
      t.date :first_played
      t.string :highest_governing_body
      t.integer :players
      t.string :playing_time
      t.text :scoring
      t.string :presence
      t.integer :sport_id

      t.timestamps
    end
  end
end
