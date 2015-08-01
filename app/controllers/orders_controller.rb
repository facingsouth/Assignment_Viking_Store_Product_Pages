class OrdersController < ApplicationController

  def shopping_cart
    @cart = @current_user.shopping_cart if signed_in_user?
  end

  def update

  end

  def checkout

  end
end
