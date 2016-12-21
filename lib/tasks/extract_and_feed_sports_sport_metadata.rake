# Extract and feed sports metadata
namespace :sports do
	desc "Extract and feed sports metadata"
	task :extract_and_feed_metadata => :environment do
		Sport.pluck("name").each do |sport_name|
				# sport_name = 'aussie rules football' # sport_name = 'badminton' # sport_name = "bar billiards" 
				#sport_name = "baseball"sport_name = 'basketball' sport_name = "American Football"
				# sport_name = "archery" sport_name = "arm wrestling"
				# sport_name = "bar billiards"
				# sport_name = "wiffle ball"
				puts "Sport name is #{sport_name}..........."
				wiki_sport = get_sport_name_wiki(sport_name)
				wiki_sport = sport_name.downcase.tr(' ', '_') unless (sport_name.eql?('Padel') || sport_name.eql?('Squash') || sport_name.eql?('table tennis ping pong'))
				doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{wiki_sport}"))
				table = doc.css('table.vcard').first
				if table.present?
					rows = table.css('tr')
					column_names = rows.shift.css('th').map(&:text)
					text_all_rows = rows.map do |row|
						row_name = row.css('th').text
						row_values = row.css('td').map(&:text)
						[row_name, *row_values]
					end
					p column_names
					p text_all_rows
					all_rows = []

					text_all_rows.each {|row| all_rows << row if row.size == 2}
					all_rows_hash = Hash[*all_rows.flatten!]
					new_all_rows_hash = {}

					all_rows_hash.to_hash.each_pair { |k,v| new_all_rows_hash.merge!({k.squish.downcase.tr(" ","_") => v}) }
					puts "......."*7

					puts new_all_rows_hash.symbolize_keys

					if new_all_rows_hash.respond_to?(:keys)
						sport = Sport.find_by(name: sport_name)
						info_box_hash = new_all_rows_hash.symbolize_keys.except(:nicknames, :registered_players, :clubs, 
							:contact, :type, :equipment, :venue, :country_or_region, :paralympic, :created)
						sport.info_box.destroy if sport.info_box.present?
						sport.info_box_details=(info_box_hash.merge!({sport_id: sport.id}))

						sport.equipment.destroy_all if sport.equipment.present?
						sport.equipment_list=(new_all_rows_hash.symbolize_keys[:equipment]) if sport.present?
					end
				else 
					puts "No vcard found for '#{sport_name}'"
				end
			end
		end
	end

	def get_sport_name_wiki(sport)
		sport_name = case sport
		when 'Hockey field'
			"Field hockey "
		when 'Kin-Ball'
			'kin-Ball'
		when 'mma mixed martial arts'
			'Mixed_martial_arts'
		when 'Padel'
			'Padel_(sport)'
		when 'Squash'
			'Squash_(sport)'
		when 'Ultimate Frisbee'
			'Ultimate_(sport)'
		when 'table tennis ping pong'
			'Table_tennis'
		else
			sport
		end
	end
