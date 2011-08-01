class User < ActiveRecord::Base
  has_many :trips, :as => 'driver', :foreign_key => 'driver_id'

  validates_presence_of :fb_id

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def fb_pic_url
    "http://graph.facebook.com/#{self.fb_id}/picture"
  end

  def fb_pic_large_url
    "http://graph.facebook.com/#{self.fb_id}/picture?type=large"
  end

  def fb_link_url
    "http://www.facebook.com/people/@/#{self.fb_id}"
  end
end

