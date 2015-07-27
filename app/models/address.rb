class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user
  has_one :user_shipping_id, class_name: "User", foreign_key: :shipping_id
  has_one :user_billing_id, class_name: "User", foreign_key: :billing_id
end
