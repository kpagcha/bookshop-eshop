class CheckoutController < ApplicationController
  before_action :initialize_cart

  def index
  	@order = Order.new
  	if @cart.books.empty?
  		flash[:notice] = "Your shopping cart is empty"
  		redirect_to controller: 'catalog', action: 'index'
  	end
  end

  def submit_order
    @cart = Cart.find params[:cart][:id]
    @order = Order.new order_params
    @order.customer_ip = request.remote_ip
    @order.status = 'open'
    populate_order

    if @order.save
      if @order.process
        flash[:notice] = "Your order has been submitted. It will be processed inmediately."
        session[:order_id] = @order.id
        @cart.cart_items.destroy_all
        redirect_to action: 'completed'
      else
        flash[:notice] = "There was an error when submitting the order: \"#{@order.error_message}'\""
        render action: 'index'
      end
    else
      render action: 'index'
    end
  end

  def completed
  end

  private

  def populate_order
    for cart_item in @cart.cart_items
      order_item = OrderItem.new(book_id: cart_item.book_id, price: cart_item.price, amount: cart_item.amount)
      @order.order_items << order_item
    end
  end

  def order_params
  	params.require(:order).permit(:email, :phone_number, :first_name, :last_name, :address, :city, :postal_code, :country_code,
  		:card_type, :card_number, :card_expiration_month, :card_expiration_year, :card_verification_value)
  end
end
