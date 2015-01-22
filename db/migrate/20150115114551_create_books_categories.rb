class CreateBooksCategories < ActiveRecord::Migration
  def change
    create_table :books_categories do |t|
    	t.references :book, :null => false
    	t.references :category, :null => false
    end
  end
end
