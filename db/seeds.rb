# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Creating admin user to start application with one user
admin_user = User.find_by_email('rahulpatil2387@gmail.com')
admin_user.destroy if admin_user
one_user = User.create! email: 'rahulpatil2387@gmail.com',
             password: 'rah00l2387',
             password_confirmation: 'rah00l2387',
             admin: true
puts 'Created admin user to start application with one sample user...!'

## All Go cheat script ###
Sport.destroy_all
all_sports = Nokogiri::HTML(open("http://www.rulesofsport.com"))
sports_list = all_sports.search(".mod-articles-category-title").children.map(&:text).compact.collect(&:strip)
# sports_list = ['Football', 'cricket']
# https://en.wikipedia.org/wiki/American Football

sports_list.first(20).each do |sport|
	page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{sport.downcase.tr(' ', '_')}"))
	basic_info = page.css('p:nth-child(4), p:nth-child(3)').text if page.present?

		# Extract history of sport
		# if sport.eql?('Field Hockey')
		# 	sport = 'Hockey Field'
		# end
		page = Nokogiri::HTML(open("http://www.rulesofsport.com/sports/#{sport.downcase.tr(' ', '-')}.html"))
		history = page.css('.itemMainImage+ p').text

		sprt = Sport.create name: sport, basic_info: basic_info, history: history #if basic_info.present? 

		# Extract rules of sport
		page = Nokogiri::HTML(open("http://www.rulesofsport.com/sports/#{sport.downcase.tr(' ', '-')}.html"))
		rules = page.css('h2+ ul').present? ? page.css('h2+ ul') :  page.css('#content li')
		rules.search('li').each { |rule| Rule.create name: "Rule of sport #{sprt.name}", description: rule.text, sport_id: sprt.id }
end

## All Go cheat  script ###
