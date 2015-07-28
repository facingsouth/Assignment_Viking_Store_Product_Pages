class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user
  has_one :shipping_user, class_name: "User", foreign_key: :shipping_id
  has_one :billing_user, class_name: "User", foreign_key: :billing_id
end
