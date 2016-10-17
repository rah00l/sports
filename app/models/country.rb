class Country < ApplicationRecord
	# Associations
	
	# Added countrywise sport based relationship
	has_many :countrywise_sports, dependent: :destroy
	has_many :sports, through: :countrywise_sports
end
