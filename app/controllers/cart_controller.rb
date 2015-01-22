class CartController < ApplicationController
  before_action :not_authenticated, :initialize_cart

  def index
  end

  def add
    @book = Book.find params[:id]
    if request.post?
      if params[:amount].to_i > 0
        @item = @cart.add(params[:id], params[:amount].to_i)
        flash[:notice] = "#{params[:amount] if params[:amount].to_i > 1} #{@item.book.title} added"
        redirect_to :controller => 'catalog'
      else
        flash[:notice] = "Invalid amount"
        render :controller => 'cart', :action => 'add', :template => 'cart/add'
      end
    else
      render :controller => 'cart', :action => 'add', :template => 'cart/add'
    end
  end

  def remove
    @book = Book.find params[:id]
    if request.delete?
      if @cart.cart_items.find_by_book_id(params[:id].to_i).amount - params[:amount].to_i >= 0
        @item = @cart.remove(params[:id], params[:amount].to_i)
        flash[:notice] = "#{params[:amount]} #{@item.book.title} deleted"
        redirect_to :controller => 'catalog'
      else
        flash[:notice] = "Invalid amount"
        render :controller => 'cart', :action => 'remove', :template => 'cart/remove'
      end
    else
      render :controller => 'cart', :action => 'remove', :template => 'cart/remove'
    end
  end

  def clear
    if request.delete?
      @cart.cart_items.destroy_all
      flash[:notice] = "The shopping cart has been emptied"
      redirect_to :controller => 'catalog'
    else
      render :controller => 'cart', :action => 'clear', :template => 'cart/clear'
    end
  end

  private
  def not_authenticated
  	if admin_signed_in?
  		flash[:notice] = "An admin cannot have access to the shopping cart."
  		redirect_to root_path
  	end
  end

  def cart_params
  	params.require(:cart).permit(:cart_items, cart_items_attributes: [ :book_id, :cart_id, :price, :amount ])
  end
end
