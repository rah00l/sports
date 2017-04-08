class Category < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]

	# Associations
	has_many :sports

	# Validation
	validates :name, presence: true, uniqueness: true
end
