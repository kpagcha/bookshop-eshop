require 'test_helper'

class BookTest < ActiveSupport::TestCase	
  test "to_s" do
  	book = Book.new(title: "Sherlock Holmes", price: 25.99)
  	author = Author.new(first_name: "Sir Conan", last_name: "Doyle")
  	book.authors << author
  	assert_equal "Sherlock Holmes, by Sir Conan Doyle", book.to_s
  end

  test "has categories" do
  	book = Book.new(title: "Sherlock Holmes", price: 25.99)
  	category = Category.new(name: "Crime")
  	book.categories << category
  	assert book.categories.include?(category)
  end

  test "has authors" do
  	book = Book.new(title: "Sherlock Holmes", price: 25.99)
  	author = Author.new(first_name: "Sir Conan", last_name: "Doyle")
  	book.authors << author
  	assert book.authors.include?(author)
  end

  test "should have title" do
  	book = Book.new(price: 25.99)
  	assert book.invalid?
  end

  test "should have positive price" do
  	book = Book.new(title: "Sherlock Holmes", price: -5.00)
  	assert book.invalid?
  	book = Book.new(title: "Sherlock Holmes", price: 0.00)
  	assert book.invalid?
  end

  test "valid book" do
  	book = Book.new(title: "Sherlock Holmes", price: 25.99)
  	assert book.valid?
  end
end
