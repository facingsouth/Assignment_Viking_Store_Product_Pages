class Order < ActiveRecord::Base
  has_many :order_contents
  has_many :products, through: :order_contents

  has_many :categories, through: :products

  belongs_to :user
  belongs_to :shipping_address,
              class_name: "Address",
              foreign_key: :shipping_id
  belongs_to :billing_address,
              class_name: "Address",
              foreign_key: :billing_id

  accepts_nested_attributes_for :order_contents, 
                                 allow_destroy: true


  def value
    self.order_contents.reduce(0) do |sum, row|
      sum += Product.find(row.product_id).price * row.quantity
    end
  end

  def merge_cart_with_order(contents) # {"2" => 2 , "10" => 4}
    ocs = self.order_contents
    pids = ocs.pluck(:product_id)
    ids = ocs.pluck(:id)
    contents.each do |item_id_str, quan|
      item_id = item_id_str.to_i
      if pids.include?(item_id)
        oc = ocs.where("product_id = ?", item_id).first
        oc.quantity += quan
        oc.save
      else
        self.order_contents.create(product_id: item_id, quantity: quan)
      end
    end
  end


  def bill_card
    CreditCard.find(self.credit_card_id).card_number
  end

  def status
    self.checkout_date ? "Placed" : "Unplaced"
  end

  def street
    Address.find(self.shipping_id).street_address
  end
  def city
    Address.find(self.shipping_id).city.name
  end
  def state
    Address.find(self.shipping_id).state.name
  end

  def bill_street
    Address.find(self.billing_id).street_address
  end
  def bill_city
    Address.find(self.billing_id).city.name
  end
  def bill_state
    Address.find(self.billing_id).state.name
  end

  def self.order_count(timeframe = 100000000000000)

    if timeframe.nil?
      return Order.where("checkout_date IS NOT NULL").count
    else
      return Order.where("checkout_date IS NOT NULL AND created_at > ?", timeframe.days.ago).count
    end
  end

  def self.revenue(timeframe = 100000000000)

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where("checkout_date IS NOT NULL AND checkout_date > ?", timeframe.days.ago)
         .first.total
  end

  def self.avg_order_value(timeframe = 1000000000000000)
    (self.revenue(timeframe) / self.order_count(timeframe)).round(2)
  end

  def self.largest_order_value(timeframe = 100000000000000000)

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where("checkout_date IS NOT NULL AND checkout_date > ?", timeframe.days.ago)
         .group("orders.id")
         .order("total DESC")
         .first.total
  end


  def self.last_seven_days
    # Last 7 days or weeks, scope is 'days' or weeks

    # if scope == 'days'
    # t = 7
    Order.select("ROUND(SUM(quantity * products.price), 2) AS total,
                  DATE(checkout_date) AS d,
                  COUNT(DISTINCT orders.id) AS num_items")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 7.days.ago)
       .group("d")
  end

  def self.last_seven_weeks

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total,
                  ROUND((julianday(current_date) - julianday(checkout_date))/7, 0) AS wk,
                  COUNT(DISTINCT orders.id) AS num_items")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 49.days.ago)
       .group("wk")
  end
end





