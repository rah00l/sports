class Sport < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]
	default_scope { order(:name) }

	scope :by_letter, -> (letter) { where("sports.name LIKE ?", "#{letter}%") }
	# Associations
	belongs_to :category
	has_one :info_box, dependent: :destroy
	has_many :players, dependent: :destroy
	has_many :equipment, dependent: :destroy
	has_many :rules, dependent: :destroy
	has_many :attachments, as: :attachable

	has_many :countrywise_sports, dependent: :destroy
	has_many :countries, through: :countrywise_sports

	# Validation
	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :info_box
	accepts_nested_attributes_for :attachments
	accepts_nested_attributes_for :players

	searchable do
		text	:name, :basic_info, :history
		text :info_box_first_played do
			info_box.nil?? '' : (info_box.first_played.nil? ? '' : info_box.first_played)
			info_box.nil?? '' : (info_box.highest_governing_body.nil? ? '' : info_box.highest_governing_body)
			info_box.nil?? '' : (info_box.team_members.nil? ? '' : info_box.team_members)
			info_box.nil?? '' : (info_box.olympic.nil? ? '' : info_box.olympic)
		end

		text :rules do
			rules.map { |rule| rule.name }
		end

		text :equipment do
			equipment.map { |equipment| [equipment.name, equipment.description] }
		end
	end

	def previous
		Sport.where("id < ?", self.id).last
	end

	def next
		Sport.where("id > ?", self.id).first
	end

	def equipment_list
		equipment.map(&:name).join(", ")
	end

	def equipment_list=(items)
		unless items.nil?
			items = "cricket ball,cricket bat,stump, bail" if name.eql?('Cricket')
			items = "Hockey puck, hockey stick, hockey skates" if name.eql?('Ice Hockey')
			items = "Lacrosse stick, Lacrosse helmet, Lacrosse shoulder pads, Lacrosse elbow pads, Lacrosse gloves " if name.eql?('Lacrosse')
			items = 'basketball' if name.eql?('SlamBall')
			items = 'Poly' if name.eql?('table tennis ping pong')
			items = 'flying disc' if name.eql?('Ultimate Frisbee')
			items_string = items.include?(",") ? items.split(",") :  items.split("\n")
			puts "**********************************************************"
			puts items_string
			puts "**********************************************************"
			self.equipment = items_string.map do |n|
				equipment_name = n.squish.downcase.tr(" ","_")
				begin
					puts '-----------------------------------------------------------------------'
					puts equipment_name
					puts '-----------------------------------------------------------------------'
					wiki_name, extractor = '', ''
					exceptional_soprts = ['Handball', 'Ice Hockey', 'Korfball', 'Netball','Padel', 
						'Platform Tennis', 'Polo', 'Racquetball', 'Rounders',
						'Rugby', 'Sepak Takraw', 'Softball', 'Squash',
						'table tennis ping pong', 'Throwball', 'Tug of War']
						wiki_name, extractor = if !exceptional_soprts.include?(name)
							get_equipment_name(equipment_name)
						end
						p "080808080808080808080808080808080808"
						puts wiki_name
						puts extractor
						p "080808080808080808080808080808080808"
						doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{wiki_name}")) if wiki_name.present?
			# if Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{equipment_name}")).present?
			# 	doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{wiki_name}"))
			# else
			# 	wiki_name, extractor = get_equipment_name(name, equipment_name)
			# 	doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{wiki_name}"))
			# end
		rescue => e
			puts e
		end
		if doc.present?
			desc = doc.css(extractor).text
		else
			puts "For #{equipment_name} -- #{wiki_name}-- and extractor is #{extractor}-- #{wiki_name} does not present"
		end
		Equipment.where(name: n.strip, description: desc).first_or_create!
	end
	end
	end

	def info_box_details=(info_box_hash)
		unless info_box_hash.nil?
			begin
				InfoBox.where(info_box_hash).first_or_create!
			rescue => e
				puts e
			end
		end
	end


	def get_equipment_name(name)
		equipment_name, extractor = case name
		when 'football_(leather_prolate_spheroid)'
			['Football_(ball)#American_and_Canadian_football', 'p:nth-child(14) , p:nth-child(15) , p:nth-child(13)']
		when "pads_(shoulder_and_knee)"
			""
		when 'football'
			['Football_(ball)#Australian_rules_football', 'p:nth-child(27) , p:nth-child(26) , .tleft+ p']
		when 'shuttlecock'
			['Shuttlecock', '.tright+ p']
		when 'racquet'
			['Racket_(sports_equipment)#Badminton', 'p:nth-child(17) , p:nth-child(16)']
		when 'cue'
			['Cue_stick', 'p:nth-child(4)']
		when 'billiard_balls'
			['Billiard_ball', 'p:nth-child(4)']
		when 'skittles'
			""
		when 'baseball'
			['Baseball_(ball)', 'p:nth-child(5) , .tright+ p']
		when 'baseball_bat'
			['Baseball_bat', 'p:nth-child(3)']
		when 'baseball_glove'
			['Baseball_glove', 'p:nth-child(5) , p:nth-child(4)']
		when "bases"
			""
		when "basketball"
			['Basketball_(ball)', 'p:nth-child(4) , p:nth-child(3)']
		when 'billiard_ball'
			['Billiard_ball', 'p:nth-child(4)']
		when 'billiard_table'
			['Billiard_table', 'p:nth-child(4)']
		when 'bowl/wood_and_jack/kitty'
			""
		when 'stump'
			['Stump_(cricket)', 'p:nth-child(12) , .tright+ p']
		when 'bail'
			['Bail_(cricket)', 'p:nth-child(7) , ul+ p , p:nth-child(2)']
		when 'golf_clubs'
			['Golf_club', 'p:nth-child(6) , p:nth-child(5)']
		when 'and_others'
			""
		when 'appropriate_horse_tack'
			['Horse_tack', 'p:nth-child(3)']
		when 'lacrosse_stick'
			['Lacrosse_stick', 'p:nth-child(2)']
		when 'lacrosse_shoulder_pads'
			''
		when 'lacrosse_elbow_pads'
			""
		when 'wiffle_ball'
			['Wiffle_ball', '.tright+ p']
		when 'pickleball_paddle'
			""
		when 'roller_skates'
			['Roller_skates', 'p:nth-child(12) , .tright+ p']
		when 'helmet'
			['Helmet', 'p:nth-child(7) , p:nth-child(6) , p:nth-child(5)']
		when 'knee_pads'
			['Knee_pad', '.tright+ p']
		when 'elbow_pads'
			['Elbow_pad', 'p']
		when 'wrist_guards'
			['Wrist_guard', 'p:nth-child(6) , .tright+ p']
		when 'mouthguard'
			['Mouthguard', 'p:nth-child(4)']
		when 'wilson_custom_–_all-white_"wave"_basketball'
			""
		when 'snooker_balls'
			['Billiard_ball#Snooker', 'p:nth-child(40) , p:nth-child(39) , .wikitable+ p']
		when 'tennis_racket'
			['Racket_(sports_equipment)#Tennis', 'p:nth-child(38) , p:nth-child(39)']
		when 'diving_mask'
			['Diving_mask', '.infobox+ p']
		when 'snorkel'
			['Snorkeling#The_snorkel', 'p:nth-child(7) , p:nth-child(6) , p:nth-child(5)']
		when 'fins'
			""
		when 'water_polo_cap'
			""
		when 'stick_&_puck.'
			""
		when 'volleyball'
			['Volleyball_(ball)', '.tright+ p']
		when 'water_polo_goals'
			['Water_polo#Water_polo_equipment', '.tright+ ul li , ul:nth-child(70) li , .tmulti~ .hatnote+ p']
		when 'water_polo_caps'
			['Water_polo_cap', 'p:nth-child(2)']
		else
			[name, 'p:nth-child(4) , p:nth-child(3)']
		end
	end
end
