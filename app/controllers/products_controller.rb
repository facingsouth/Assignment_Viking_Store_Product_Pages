class ProductsController < ApplicationController

  def index
    if whitelisted_params
      @products = Product.where("category_id =?", whitelisted_params[:category_id].to_i)
    else
      @products = Product.all.limit(12)
    end

    render :index, locals: {:category_id => }
  end


  private

  def whitelisted_params
    params.require(:product).permit(:category_id)
  end
end
