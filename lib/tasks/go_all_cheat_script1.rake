namespace :go_all do
	desc "Geocode to get latitude, longitude and address"
	task :cheat_script1 => :environment do
			## All Go cheat script ###
	# Sport list from rule
	all_sports = Nokogiri::HTML(open("http://www.rulesofsport.com"))
	sports_list = all_sports.search(".mod-articles-category-title").children.map(&:text).compact.collect(&:strip)

	# Sport list from wiki
	sports_by_country_wiki_page = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Category:Sports_by_country'))

	sports_list_wiki = sports_by_country_wiki_page.css('.mw-category-group+ .mw-category-group .CategoryTreeLabelCategory').children.map(&:text).each {|sport| sport.slice!(' by country') }

	sports_list_by_country = sports_list.map! { |word| "#{word} by country" }
	# ** Compare both array and difference sports need to be include

	## => ["American football by country", "Archery by country", "Association football by country", "Athletics by country", "Australian rules football by country", "Badminton by country", "Bandy by country", "Baseball by country", "Basketball by country", "Basque pelota by country", "Beach soccer by country", "Biathlon by country", "Bodybuilding by country", "Bowling by country", "Bowls by country", "Canoeing by country", "Caving by country", "Chess by country", "Cricket by country", "Croquet by country", "Cue sports by country", "Curling by country", "Cycle racing by country", "Cycling by country", "Dancesport by country", "Darts by country", "Diving by country", "Equestrian sports by country", "ESports by country", "Fencing by country", "Field hockey by country", "Floorball by country", "Futsal by country", "Gaelic football by country", "Goalball by country", "Golf by country", "Gymnastics by country", "Handball by country", "Horse racing by country", "Hunting by country", "Ice hockey by country", "Ice skating by country", "Indoor soccer by country", "Inline hockey by country", "Judo by country", "Kabaddi by country", "Karate by country", "Korfball by country", "Lacrosse by country", "Martial arts by country", "Modern pentathlon by country", "Motorsport by country", "Mountaineering by country", "Muay Thai by country", "Netball by country", "Orienteering by country", "Parachuting by country", "Polo by country", "Professional wrestling by country", "Roller derby by country", "Roller skating by country", "Rowing by country", "Rugby football by country", "Rugby league by country", "Rugby union by country", "Running by country", "Sailing by country", "Shooting sports by country", "Skateboarding by country", "Skiing by country", "Sledding by country", "Snooker by country", "Soft tennis by country", "Softball by country", "Sports champions by nationality", "Squash by country", "Surfing by country", "Swimming by country", "Synchronized swimming by country", "Table tennis by country", "Taekwondo by country", "Tennis by country", "Triathlon by country", "Volleyball by country", "Water polo by country", "Weightlifting by country", "Wheelchair basketball by country", "Wrestling by country", "Wushu by country"]

	sports_by_country = sports_by_country_wiki_page.css('.mw-category-group+ .mw-category-group .CategoryTreeLabelCategory').children.map(&:text).compact.collect(&:strip)

	common_sports = sports_by_country.map(&:downcase) & sports_list_by_country.map(&:downcase)

	common_sports.first(15).each do |sport_by_country|

	sport_by_country_wiki_page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/Category:#{sport_by_country.downcase.tr(' ', '_')}"))

	css_selectors =  if sport_by_country_wiki_page.at_css('.mw-category-group+ .mw-category-group .CategoryTreeLabelCategory')
		'.mw-category-group+ .mw-category-group .CategoryTreeLabelCategory'
	else
		'.CategoryTreeLabelCategory'
	end

		list_of_countries = sport_by_country_wiki_page.css(css_selectors).children.map(&:text).compact.collect(&:strip)

		sport_name = 	sport_by_country.chomp(' by country')
		# sport_name = get_correct_country_name(sport_name)
		p "#{sport_name} played in following countries"
		countries = list_of_countries.map!(&:downcase).each {|country| country.gsub!("#{sport_name} in ", '') }
		# p countries
		countries.collect! { |country| country = country_name(country) }
		# p countries
		countries.each {|country| Country.find_or_create_by name: country }
		p countries.count
		sport = Sport.find_by(name: sport_name)
		countries_list = Country.where(name: countries)
		p countries_list.count
		sport.countries.destroy_all if sport.present?
		# sport.countries.count if sport.present?
		sport.countries = countries_list if sport.present?
		sport.countries.count if sport.present?
	end
end

def country_name(name)
	case name
	when 'the united kingdom'
		'united kingdom'
	when "the united states"
		'united states'
	when "the bahamas"
		'bahamas'
	when "the netherlands"
		'netherlands'
	when "the philippines"
		'philippines'
	else
		name
	end
end
end
