class AddSlugToSports < ActiveRecord::Migration[5.0]
  def change
    add_column :sports, :slug, :string
    add_index :sports, :slug
  end
end
