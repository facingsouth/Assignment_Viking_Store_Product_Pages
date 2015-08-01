class ProductsController < ApplicationController

  def index
    @products = Product.includes(:category)
    if params[:product]
      @category_id = whitelisted_params[:category_id]
      @products = Product.products_in_category(@category_id)
    end

    session[:cart] ||= {}
    product_id = params[:product_id]
    if product_id.nil? #first visiting will flash error, will fix later
      flash.now[:error] = "Product cannot be added!"
      render :index
    else
      session[:cart][product_id] = session[:cart][product_id].to_i + 1
      flash.now[:success] = "#{Product.find(product_id).name} is added to your cart!"
      render :index
    end

    if signed_in_user?
      cart = current_user.shopping_cart #unplaced existing order
      cart.merge_cart_with_order(session[:cart])
    else
      #make an order
    end

  end


  private

  def whitelisted_params
    params.require(:product).permit(:category_id)
  end
end
