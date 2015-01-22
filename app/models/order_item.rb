class OrderItem < ActiveRecord::Base
    belongs_to :book
    belongs_to :order

    validates_numericality_of :price, greater_than: 0
    validates_numericality_of :amount, greater_than: 0

	def to_s
		"(#{amount}) #{book}"
	end
end
