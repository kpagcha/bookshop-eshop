class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :book, index: true
      t.references :order, index: true
      t.float :price
      t.integer :amount

      t.timestamps
    end
  end
end
