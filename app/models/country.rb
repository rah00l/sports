class Country < ApplicationRecord
	# Associations
	validates :name, presence: true, uniqueness: true
	
	# Added countrywise sport based relationship
	has_many :countrywise_sports, dependent: :destroy
	has_many :sports, through: :countrywise_sports
	belongs_to :continent
end
