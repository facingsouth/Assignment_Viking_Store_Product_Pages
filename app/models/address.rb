class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user
  has_one :shipping_user, class_name: "User", foreign_key: :shipping_id
  has_one :billing_user, class_name: "User", foreign_key: :billing_id

  validates :street_address, :zip_code, :city_id, :state_id, :user_id,
            :presence => true

  
       
         


  before_create :check_city


  def check_city
    name=params[:city]
    city_name=City.check_city_name(name)
    if city_name
      params[:city_id]=city_name.id
    else
      new_city=City.create(name)
      params[:city_id]=new_city.id
    end
  end

end
