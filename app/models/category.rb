class Category < ApplicationRecord
	# Associations
	has_many :sports

	# Validation
	validates :name, presence: true, uniqueness: true
end
