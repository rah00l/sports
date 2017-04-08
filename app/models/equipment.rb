class Equipment < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]

	# Associations
	belongs_to :sport

	# Validation
	validates :name, presence: true#, uniqueness: true
	has_many :attachments, as: :attachable
end
