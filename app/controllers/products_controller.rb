class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(white_listed_product_params)
    if @product.save
      flash[:success] = "New product created."
      redirect_to products_path
    else
      flash.now[:error] = "Your product cannot be created."
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

  def white_listed_product_params
    params.require(:product).permit()
  end

end
