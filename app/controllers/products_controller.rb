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
      flash.now[:success] = "Product #{product_id} is added to your cart!"
      render :index
    end

  end


  private

  def whitelisted_params
    params.require(:product).permit(:category_id)
  end
end
