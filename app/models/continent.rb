class Continent < ApplicationRecord
	# Associations
	has_many :countries

	# Validation
	validates :name, presence: true, uniqueness: true
end
