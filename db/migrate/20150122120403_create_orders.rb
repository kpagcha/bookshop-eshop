class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :email
      t.string :phone_number
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :postal_code
      t.string :country_code
      t.string :customer_ip
      t.string :status
      t.string :error_message

      t.timestamps
    end
  end
end
