class CreateCountrywiseSports < ActiveRecord::Migration[5.0]
  def change
    create_table :countrywise_sports do |t|
      t.references :country, foreign_key: true
      t.references :sport, foreign_key: true

      t.timestamps
    end
  end
end
