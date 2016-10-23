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


Country.delete_all
puts "Creating default countries..."
open("http://openconcept.ca/sites/openconcept.ca/files/country_code_drupal_0.txt") do |countries|
  countries.read.each_line do |country|
    code, name = country.chomp.split("|")
    Country.create!(name: name, code: code)
    puts country.chomp.split("|")
  end
end

puts "Creating default Continents..."
['Africa', 'Asia', 'Europe', 'North America', 'South America',
	'Oceania', 'Antarctica'].each { |continent_name| Continent.find_or_create_by name: continent_name }

puts "mapping countries to there continent.."
page = Nokogiri::HTML(open('http://www.apnaeducation.com/news/countries-and-their-capitals-currency/'))

african_countries = page.css('table:nth-child(21) tbody td:nth-child(1) , p+ h4 strong').children.search('strong').map(&:text).compact.collect(&:strip)
african_countries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'Africa').id) if country.present?
end

asian_contries = page.css('table:nth-child(24) tbody td:nth-child(1)').children.search('strong').map(&:text).compact.collect(&:strip)
asian_contries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'Asia').id) if country.present?
end

europian_contries = page.css('table:nth-child(26) tbody td:nth-child(1)').children.search('strong').map(&:text).compact.collect(&:strip)
europian_contries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'Europe').id) if country.present?
end

north_american_contries = page.css('table:nth-child(28) tbody td:nth-child(1)').children.search('strong').map(&:text).compact.collect(&:strip)
north_american_contries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'North America').id) if country.present?
end

south_american_contries = page.css('table:nth-child(30) tbody td:nth-child(1)').children.search('strong').map(&:text).compact.collect(&:strip)
south_american_contries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'South America').id) if country.present?
end

oceanian_contries = page.css('table:nth-child(32) tbody td:nth-child(1)').children.search('strong').map(&:text).compact.collect(&:strip)
oceanian_contries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'Oceania').id) if country.present?
end

antarctican_contries = page.css('table:nth-child(34) tbody td:nth-child(1)').children.map(&:text).compact.collect(&:strip)
antarctican_contries.each do |country_name|
	country = Country.find_by name: country_name
	country.update_attribute(:continent_id, (Continent.find_by name: 'Antarctica').id) if country.present?
end
