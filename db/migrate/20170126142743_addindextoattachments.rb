class Addindextoattachments < ActiveRecord::Migration[5.0]
  def change
  	add_index :attachments, [:attachable_id, :attachable_type], :unique => true
  	add_index :equipment, :sport_id
  	add_index :countries, :continent_id
  	add_index :info_boxes, :sport_id
  	add_index :rules, :sport_id
  	add_index :sports, [:category_id, :name]
  end
end
