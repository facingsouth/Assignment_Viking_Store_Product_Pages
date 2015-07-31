class ProductsController < ApplicationController

  def index
    @products = Product.includes(:category)
    @category_id = params[:category_id]
    # fail
    if params[:category_id]
      @products = @products.where("category_id =?", @category_id)
    end

    render :index
  end


  private

  def whitelisted_params
    params.require(:product).permit(:category_id)
  end
end
