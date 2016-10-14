namespace :go_all do
	desc "Geocode to get latitude, longitude and address"
	task :cheat_script => :environment do
		## All Go cheat script ###
		Sport.destroy_all
		puts '....'*100
		puts 'Destroyed all earlier sports..'
		
		all_sports = Nokogiri::HTML(open("http://www.rulesofsport.com"))
		sports_list = all_sports.search(".mod-articles-category-title").children.map(&:text).compact.collect(&:strip)

		sports_list.each do |sport|
			begin
				sport = get_sport_name_wiki(sport)
				wiki_page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{sport.downcase.tr(' ', '_')}"))
			rescue => e
				puts e
			end
			basic_info = wiki_page.css('p:nth-child(4), p:nth-child(3)').text if wiki_page.present?

			sport_name = get_proper_sport_name(sport)
			# sport = 'Hockey Field' if sport.eql?('Field Hockey')

			# Extract rules of sport
			begin
				rules_page = Nokogiri::HTML(open("http://www.rulesofsport.com/sports/#{sport_name.downcase.tr(' ', '-')}.html"))
			rescue => e
				puts e
			end
			history = rules_page.css('p:nth-child(5) , p:nth-child(4) , .itemMainImage+ p').text

			sprt = Sport.create name: sport_name, basic_info: basic_info, history: history

			rules = rules_page.css('h2+ ul').present? ? rules_page.css('h2+ ul') :  rules_page.css('#content li')
			rules.search('li').each { |rule| Rule.create name: "Rule of sport ", description: rule.text, sport_id: sprt.id }
			puts "**#{sport_name}**"
			puts "https://en.wikipedia.org/wiki/#{sport.downcase.tr(' ', '_')}"
			puts "http://www.rulesofsport.com/sports/#{sport_name.downcase.tr(' ', '-')}.html"
			puts ".."*10
		end
		
		puts "Added #{sports_list.size} entries for sports and it's related inforation.."
		puts '....'*100
	end

	def get_sport_name_wiki(sport)
		case sport
		when 'Kin-Ball'
			'kin-Ball'
		when 'MMA (Mixed Martial Arts)'
			'Mixed martial arts'
		else
			sport
		end
	end

	def get_proper_sport_name(sport)
		case sport
		when 'Field Hockey'
			'hockey field'
		when 'MMA (Mixed Martial Arts)'
			'mma mixed martial arts'
		when 'TABLE TENNIS (PING PONG)'
			'table tennis ping pong'
		else
			sport
		end
	end
end
