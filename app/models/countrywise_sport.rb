class CountrywiseSport < ApplicationRecord
	# Associations
  belongs_to :country
  belongs_to :sport
end
