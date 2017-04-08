class Continent < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]

	# Associations
	has_many :countries

	# Validation
	validates :name, presence: true, uniqueness: true
end
