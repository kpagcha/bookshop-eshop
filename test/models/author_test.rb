require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "full name" do
  	author = Author.new(first_name: "John", last_name: "Doe")
  	assert_equal "John Doe", author.name
  end

  test "first name required" do
  	author = Author.new(last_name: "Doe")
  	assert author.invalid?
  end

  test "last name required" do
  	author = Author.new(first_name: "John")
  	assert author.invalid?
  end

  test "valid author" do
  	author = Author.new(first_name: "John", last_name: "Doe")
  	assert author.valid?
  end
end
