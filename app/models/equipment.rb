class Equipment < ApplicationRecord
	# Associations
	belongs_to :sport

	# Validation
	validates :name, presence: true#, uniqueness: true
	has_many :attachments, as: :attachable
end
