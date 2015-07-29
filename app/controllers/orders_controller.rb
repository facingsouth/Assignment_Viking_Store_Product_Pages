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
    @cart_id=@user.orders.where("status=?", "Unplaced")
    if @cart_id
      flash[:error]="Cart already exists, you can only have one cart"
      redirect_to edit_order_path(@cart_id.first.id)
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
    @address = Address.find(params[:id])

    @user = User.find(@address.user_id)
  end

  # def update
  #   @address = Address.find(params[:id])
  #   @address.city_id = check_city(params[:address][:city])
  #   if @address.update(white_listed_address_params)
  #     flash[:success] = "Address successfully modified."
  #     redirect_to order_path
  #   else
  #     flash.now[:error] = @address.errors.full_messages.first
  #     render :edit
  #   end
  # end

  # def destroy
  #   session[:return_to] ||= request.referer
  #   @address = Address.find(params[:id])
  #   if @address.destroy
  #     flash[:success] = "address successfully deleted."
  #     redirect_to order_path
  #   else
  #     flash[:error] = @address.errors.full_messages.first
  #     redirect_to session.delete(:return_to)
  #   end
  # end

  private

  def whitelisted_order_params
    params.require(:order).permit(:checkout_date, 
                                    :user_id, 
                                    :shipping_id, 
                                    :billing_id )
  end
end
