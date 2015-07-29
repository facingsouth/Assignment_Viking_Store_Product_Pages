class OrdersController < ApplicationController


  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = @user.orders.limit(100)
      else
        flash[:error] = "No user with this ID found."
        redirect_to orders_path
      end
    else
      @orders = Order.all.limit(100)
    end
  end

  def new
    @order = Order.new
    @user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_order_params)
    @user = User.find(params[:order][:user_id])
    @cart_id=@user.orders.where("checkout_date IS NULL")
    if @cart_id.first
      @order = @cart_id.first
      flash[:error]="Cart already exists, you can only have one cart"
      redirect_to edit_order_path(@order)
    else
        if @order.save
          flash[:success] = "New order created."
          redirect_to edit_order_path(@order)
        else
          flash.now[:error] = @order.errors.full_messages.first
          render :new
        end
    end
  end

  def show
    @order = Order.find(params[:id])
    @user=User.find(@order.user_id)
  end

  def edit
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(whitelisted_order_params)
      flash[:success] = "order successfully modified."
      redirect_to order_path
    else
      flash.now[:error] = @order.errors.full_messages.first
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order successfully deleted."
      redirect_to order_path
    else
      flash[:error] = @order.errors.full_messages.first
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_order_params
    params.require(:order).permit(:checkout_date,
                                    :user_id,
                                    :shipping_id,
                                    :billing_id )
  end
end
