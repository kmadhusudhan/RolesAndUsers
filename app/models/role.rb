class Role < ApplicationRecord
	has_and_belongs_to_many :users
	validates :name, uniqueness: true

	scope :get_active,->{where(is_active: true)}
end
