class CartsController < ApplicationController

  def add_to_cart
    session[:cart] ||= {}
    product_id = params[:product_id]
    if product_id.nil? #first visiting will flash error, will fix later
      flash[:error] = "Product cannot be added!"
      redirect_to products_path
    else
      session[:cart][product_id] = session[:cart][product_id].to_i + 1
      flash[:success] = "#{Product.find(product_id).name} is added to your cart!"
      redirect_to products_path
    end
  end
end
