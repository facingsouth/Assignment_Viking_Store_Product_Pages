class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(white_listed_product_params)
    @product.sku = (Faker::Code.ean).to_i
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
    @product = Product.find(params[:id])
    if @product.update(white_listed_product_params)
      flash[:success] = "Product successfully modified."
      redirect_to products_path
    else
      flash.now[:error] = "Your product cannot be created."
      render :edit
    end
  end

  def destroy
  end

  private

  def white_listed_product_params
    params.require(:product).permit(:name, :price, :description, :category_id, :sku)
  end

end
