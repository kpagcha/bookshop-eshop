class Cart < ActiveRecord::Base
  has_many :cart_items
  has_many :books, :through => :cart_items

  accepts_nested_attributes_for :cart_items

  # Return the sum of the price of the shopping cart
  def total
  	cart_items.inject(0) { |sum, item| item.price * item.amount + sum }
  end

  # Adds a book to the shopping cart, in a particular amount
  def add(book_id, amount = 1)
    items = cart_items.find_by_book_id book_id
    puts items
    book = Book.find book_id
    if items.nil?
      ci = cart_items.create(:book_id => book_id, :amount => amount, :price => book.price)
    else
      ci = items
      ci.update_attribute(:amount, ci.amount + amount)
    end
    ci
  end

  # Removes a book from the shopping cart, in a particular amount
  def remove(book_id, amount = 1)
    ci = cart_items.find_by_book_id(book_id)
    if ci.amount - amount > 0
      ci.update_attribute(:amount, ci.amount - amount)
    else
      CartItem.destroy(ci.id)
    end
    ci
  end
end