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
