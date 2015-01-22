class Book < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :authors

	validates :title, presence: true
	validates :price, numericality: { greater_than: 0 }

	# Returns the title of the book and its author
	def to_s
		"#{title}, by #{authors.join(', ')}"
	end
end
