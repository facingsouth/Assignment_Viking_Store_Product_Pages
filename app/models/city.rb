class City < ActiveRecord::Base
  has_many :addresses, dependent: :destroy


  def self.check_city_name(name)
    self.select("id").where("name = ?", name).first
  end
end
