class AddContinentIdToCountries < ActiveRecord::Migration[5.0]
  def change
  	add_column :countries, :continent_id, :integer
  end
end
