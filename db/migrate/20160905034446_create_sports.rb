class CreateSports < ActiveRecord::Migration[5.0]
  def change
    create_table :sports do |t|
      t.string :name
      t.text :basic_info
      t.text :history
      t.integer :category_id
      t.integer :nation_id

      t.timestamps
    end
  end
end
