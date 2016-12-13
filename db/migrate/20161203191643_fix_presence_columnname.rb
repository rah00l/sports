class FixPresenceColumnname < ActiveRecord::Migration[5.0]
  def up
  	rename_column :info_boxes, :presence, :olympic
    rename_column :info_boxes, :players, :team_members
  	change_column :info_boxes, :team_members, :string
  	change_column :info_boxes, :first_played, :string
  end

  def down
  	rename_column :info_boxes, :olympic, :presence
    rename_column :info_boxes, :team_members, :players
  	change_column :info_boxes, :players, :integer
  	change_column :info_boxes, :first_played, :date
  end
end
