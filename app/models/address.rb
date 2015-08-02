class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user
  has_one :shipping_user, class_name: "User", foreign_key: :shipping_id
  has_one :billing_user, class_name: "User", foreign_key: :billing_id


  # ------------------- Validations ---------------------

  validates :street_address, :zip_code, :state_id,
            :presence => true



  # before_create :check_city

  # ------------------- Methods ---------------------
  def full_address
    "#{street_address}, #{city.name}, #{state.name}, #{zip_code}"
  end

end
