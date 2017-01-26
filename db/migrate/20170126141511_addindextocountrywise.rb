class Addindextocountrywise < ActiveRecord::Migration[5.0]
  def change
  	add_index :countrywise_sports, [ :country_id, :sport_id ], unique: true, name: 'by_country_and_sport'
  end
end
