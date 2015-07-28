class City < ActiveRecord::Base
  has_many :addresses, dependent: :destroy


  def self.check_city_name(name)
    City.select("id").where("city.name=?", name).first

  end
end
