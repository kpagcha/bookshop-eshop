class Author < ActiveRecord::Base
	validates :first_name, presence: true
	validates :last_name, presence: true

	# Returns the full name of the author
	def name
		"#{first_name} #{last_name}"
	end

	# Returns the full name of the author
	def to_s
		name
	end
end
