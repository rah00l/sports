class Sport < ApplicationRecord
	# Associations
	belongs_to :category
	has_one :info_box, dependent: :destroy
	has_many :players, dependent: :destroy
	has_many :equipment, dependent: :destroy
	has_many :rules, dependent: :destroy
	has_many :attachments, as: :attachable

	has_many :countrywise_sports, dependent: :destroy
	has_many :countries, through: :countrywise_sports

	# Validation
	validates :name, presence: true, uniqueness: true

	accepts_nested_attributes_for :info_box
	accepts_nested_attributes_for :attachments
	accepts_nested_attributes_for :players
end
