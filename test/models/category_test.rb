require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "to_s" do
  	category = Category.new(name: "Drama")
  	assert_equal "Drama", category.to_s
  end

  test "should have name" do
  	category = Category.new
  	assert category.invalid?
  end

  test "valid category" do
  	category = Category.new(name: "Drama")
  	assert category.valid?
  end
end
