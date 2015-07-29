module OrdersHelper

  def order_status
    @order.checkout_date ? 'checked="checked"' : nil
  end
end
