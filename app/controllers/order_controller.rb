class OrderController < AdminController
  def index
  	@status = params[:id]
  	if @status.blank?
  		@orders = Order.paginate(page: params[:page], per_page: 10)
  	else
    	@orders = Order.where(status: @status).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    @order = Order.find params[:id]
  end

  def close
    order = Order.find params[:id]
    if order.processed?
      order.close
      flash[:notice] = "Order ##{order.id} closed"
      redirect_to :action => 'index'
    else
      flash[:notice] = "Cannot close order unprocessed ##{order.id}"
      redirect_to :action => 'index'
    end
  end
end
