module OrdersHelper

  def order_status(str)
    #Uplaced and empty OR Placed and not empty
    (@order.checkout_date.nil? && str == "Unplaced") || (@order.checkout_date && str == "Placed")
  end
end
