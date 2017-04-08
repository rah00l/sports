class AddSlugsToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug

    add_column :continents, :slug, :string
    add_index :continents, :slug

    add_column :countries, :slug, :string
    add_index :countries, :slug

    add_column :equipment, :slug, :string
    add_index :equipment, :slug

    add_column :players, :slug, :string
    add_index :players, :slug
  end
end
