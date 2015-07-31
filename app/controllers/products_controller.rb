class ProductsController < ApplicationController

  def index
    @products = Product.includes(:category)
    if params[:product]
      @category_id = whitelisted_params[:category_id]
      @products = Product.products_in_category(@category_id)
    end

    session[:cart] ||= {}

    session[:cart][:product_id] = session[:cart][:product_id].to_i + 1

    render :index
  end


  private

  def whitelisted_params
    params.require(:product).permit(:category_id)
  end
end
