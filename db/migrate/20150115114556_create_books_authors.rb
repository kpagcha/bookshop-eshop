class CreateBooksAuthors < ActiveRecord::Migration
  def change
    create_table :authors_books do |t|
    	t.references :book, :null => false
    	t.references :author, :null => false
    end
  end
end
