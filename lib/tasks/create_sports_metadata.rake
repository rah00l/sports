namespace :sports do
	desc "Create sports and it's metadata"
	task :create_metadata => :environment do
		## All Go cheat script ###
		Sport.destroy_all
		puts '....'*100
		puts 'Destroyed all earlier sports..'
		
		all_sports = Nokogiri::HTML(open("http://www.rulesofsport.com"))
		sports_list = all_sports.search(".mod-articles-category-title").children.map(&:text).compact.collect(&:strip)
		# sports_list = ['TABLE TENNIS (PING PONG)']
		sports_list.each do |sport|

			begin
				puts sport
				sport_wiki = get_sport_name_wiki(sport)
				# byebug
				puts sport_wiki
				wiki_page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{sport_wiki}"))
			rescue => e
				puts e
			end

			css_selector = basic_info_css_selector(sport_wiki)

			basic_info = if wiki_page.present? && wiki_page.at_css(css_selector)
				wiki_page.css(css_selector).text
			else
				wiki_page.css('p:nth-child(6), p:nth-child(5)').text
			end

			# pool && rugby - Extra exceptional cases
			first_palyed = wiki_page.css('.vcard tr:nth-child(3) td').children.map(&:text).compact.collect(&:strip)
			sport_name = get_proper_sport_name(sport)
			puts sport_name
			# sport = 'Hockey Field' if sport.eql?('Field Hockey')

			# Extract rules of sport
			begin
				rules_page = Nokogiri::HTML(open("http://www.rulesofsport.com/sports/#{sport_name.downcase.tr(' ', '-')}.html"))
			rescue => e
				puts e
			end
			history = rules_page.css('p:nth-child(5) , p:nth-child(4) , .itemMainImage+ p').text

			sprt = Sport.create name: sport_name.capitalize, basic_info: basic_info, history: history

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
		sport_name = case sport
		when 'Kin-Ball'
			'kin-Ball'
		when 'MMA (Mixed Martial Arts)'
			'Mixed martial arts'
		when 'Padel'
			'Padel_(sport)'
		when 'Squash'
			'Squash_(sport)'
		when 'Ultimate Frisbee'
			'Ultimate_(sport)'
		when 'Table Tennis (Ping Pong)'
			'Table tennis'
		else
			sport
		end
		sport_name.eql?('kin-Ball') ? sport_name : sport_name.downcase.tr(' ', '_')
	end

	def get_proper_sport_name(sport)
		case sport
		when 'Field Hockey'
			'hockey field'
		when 'MMA (Mixed Martial Arts)'
			'mma mixed martial arts'
		when 'Table Tennis (Ping Pong)'
			'table tennis ping pong'
		else
			sport
		end
	end

	# Archery .tright+ p
	# 'Field_hockey' || 'Netball' || 'Pickleball' || 'Platform_tennis' || 'Squash_(sport)' || 'Ultimate_(sport)'
	# 'Kin-Ball' --> p:nth-child(2)
	# 'Tee-ball' --> p:nth-child(3) , p:nth-child(2)
	#Field_hockey .vcard+ p
	# Kin-Ball - p:nth-child(2)
	# Netball - .vcard+ p
	# Pickleball - .vcard+ p
	# Platform_tennis - .vcard+ p
	# Squash_(sport) - .vcard+ p
	# Tee-ball - p:nth-child(3) , p:nth-child(2)
	# Ultimate_(sport) - .vcard+ p


	def basic_info_css_selector(sport_name)
		case sport_name
		when 'archery'
			'p:nth-child(8)'
		when 'field_hockey', 'netball', 'pickleball', 'platform_tennis', 'squash_(sport)', 'ultimate_(sport)'
			'.vcard+ p'
		when 'kin-Ball'
			'p:nth-child(2)'
		when 'tee-ball'
			'p:nth-child(3) , p:nth-child(2)'
		else
			'p:nth-child(4), p:nth-child(3)'
		end
	end
end
