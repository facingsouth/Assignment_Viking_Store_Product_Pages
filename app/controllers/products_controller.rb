class ProductsController < ApplicationController

  def index
    @products = Product.includes(:category)
    if params[:product]
      @category_id = whitelisted_params[:category_id]
      @products = Product.products_in_category(@category_id)
    end

    if signed_in_user?
      cart = current_user.shopping_cart #unplaced existing order
      cart.merge_cart_with_order(session[:cart])
      session.delete(:cart)
    else
      #make an order
    end

  end


  private

  def whitelisted_params
    params.require(:product).permit(:category_id)
  end
end
