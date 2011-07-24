class User < ActiveRecord::Base
  has_many :trips, :as => 'driver', :foreign_key => 'driver_id'

  validates_presence_of :fb_id

  def full_name

  end
end

