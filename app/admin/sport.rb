ActiveAdmin.register Sport do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
	permit_params :name, :basic_info, :history, :category_id, :nation_id,
                info_box_attributes: [:first_played, :highest_governing_body, :players,
                  :playing_time, :scoring, :presence],
                attachments_attributes: :file,
                players_attributes: :name
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
form do |f|
  f.inputs "Sport Details" do
    f.input :name
    f.input :basic_info#, as: :html_editor
    f.input :history#, as: :html_editor
    # f.input :image, as: :file
    f.input :category_id, as: :select, collection: Category.all.map{|cat| [cat.name, cat.id]}

    # f.input :user_id, as: :select, collection: User.all.map{|usr| [usr.email, usr.id]} for nation
    # f.input :user_id, as: :select, collection: User.all.map{|usr| [usr.email, usr.id]}
    # f.input :publish, as: :boolean,
    #                   required: false,
    #                   label: 'Check this box to allow publish this post'
    # f.input :published_at, as: :datepicker
    # f.input :player_ids, as: :select, collection: Player.all, multiple: true
    # f.input :players, include_hidden: false, input_html: { name: "sport[player_ids]" }
  end

  f.inputs "More Information", for: [:info_box, f.object.info_box || InfoBox.new] do |s|
    s.input :first_played, as: :datepicker
    s.input :highest_governing_body
    s.input :players
    s.input :playing_time
    s.input :scoring
    s.input :presence
  end

  f.has_many :attachments do |a|
    a.input :file
  end

  f.has_many :players do |a|
    a.input :id, as: :select, collection: Player.all, multiple: true
  end

  f.actions
end

end
