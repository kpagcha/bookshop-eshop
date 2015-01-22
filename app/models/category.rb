class Category < ActiveRecord::Base
	validates :name, presence: true

	# Returns the name of the category
	def to_s
		name
	end
end
