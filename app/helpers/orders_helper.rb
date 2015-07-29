module OrdersHelper

  def order_status
    @order.checkout_date
  end
end
