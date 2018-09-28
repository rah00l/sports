namespace :sports do
	desc "Create sports and it's metadata"
	task :create_metadata => :environment do
		## All Go cheat script ###
		Sport.destroy_all
		#puts '....'*100
		#puts 'Destroyed all earlier sports..'
		
		all_sports = Nokogiri::HTML(open("http://www.rulesofsport.com"))
		sports_list = all_sports.search(".mod-articles-category-title").children.map(&:text).compact.collect(&:strip)
		# sports_list = ['TABLE TENNIS (PING PONG)']
		progress_bar = ProgressBar.new(sports_list.size)
		sports_list.each do |sport|
		# sport = 'Kin-Ball'
			begin
				#puts sport
				sport_wiki = get_sport_name_wiki(sport)
				# byebug
				#puts sport_wiki
				sport_wiki = 'Mixed martial arts' if sport_wiki.eql?('MMA (Mixed Martial Arts)')
				sport_wiki = 'Table tennis' if sport_wiki.eql?('Table Tennis (Ping Pong)')
				sport_wiki = sport_wiki.eql?('Kin-Ball') ? sport_wiki : sport_wiki.downcase.tr(' ', '_')
				#puts '---------'*5
				#puts sport_wiki
				#puts '---------'*5
				#puts "https://en.wikipedia.org/wiki/#{sport_wiki}"
				wiki_page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{sport_wiki}"))
			rescue => e
				#puts e
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
			#puts sport_name
			# sport = 'Hockey Field' if sport.eql?('Field Hockey')

			# Extract rules of sport
			begin
				#puts "http://www.rulesofsport.com/sports/#{sport_name.downcase.tr(' ', '-')}.html"
				rules_page = Nokogiri::HTML(open("http://www.rulesofsport.com/sports/#{sport_name.downcase.tr(' ', '-')}.html"))
			rescue => e
				#puts e
			end

			history = rules_page.css('p:nth-child(5) , p:nth-child(4) , .itemMainImage+ p').text

			sprt = Sport.create name: sport_name.capitalize, basic_info: basic_info, history: history

			rules = rules_page.css('h2+ ul').present? ? rules_page.css('h2+ ul') :  rules_page.css('#content li')
			rules.search('li').each { |rule| Rule.create name: "Rule of sport ", description: rule.text, sport_id: sprt.id }
	# TODO
	# athletics have specific rule.
	# Each individual discipline has its own specific set of rules and competitors are expected to abide by these to ensure that the competition is fair.
			#puts "**#{sport_name}**"
			#puts ".."*10
			progress_bar.increment!
		end
		
		# #puts "Added #{sports_list.size} entries for sports and it's related inforation.."
		#puts '....'*100
	end
end

def get_sport_name_wiki(sport)

	sport_name = case sport
	when 'Kin-Ball'
		'kin-Ball'
	when 'Padel'
		'Padel_(sport)'
	when 'Rugby'
			'Rugby_football'
	when 'Squash'
		'Squash_(sport)'
	when 'Ultimate Frisbee'
		'Ultimate_(sport)'
	else
		sport
	end
	# return 'Mixed martial arts' if sport.eql?('MMA (Mixed Martial Arts)')

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
