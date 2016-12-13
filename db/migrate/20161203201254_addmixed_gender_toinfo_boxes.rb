class AddmixedGenderToinfoBoxes < ActiveRecord::Migration[5.0]
  def change
  	add_column :info_boxes, :mixed_gender, :string
  end
end
