class Country < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]

	# Associations
	validates :name, presence: true, uniqueness: true
	
	# Added countrywise sport based relationship
	has_many :countrywise_sports, dependent: :destroy
	has_many :sports, through: :countrywise_sports
	belongs_to :continent
	has_one :attachment, as: :attachable, dependent: :destroy
end
