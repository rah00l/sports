class Equipment < ApplicationRecord
	# Associations
	belongs_to :sport

	# Validation
	validates :name, presence: true, uniqueness: true	
end
