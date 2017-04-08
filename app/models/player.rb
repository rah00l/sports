class Player < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]

	# Associations
	belongs_to :sport

	# Validation
	validates :name, presence: true, uniqueness: true
end
