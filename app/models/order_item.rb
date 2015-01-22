class OrderItem < ActiveRecord::Base
    belongs_to :book
    belongs_to :order

	attr_accessor :book_id, :order_id, :price, :amount
end
