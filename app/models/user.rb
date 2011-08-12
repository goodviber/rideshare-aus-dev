class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authentications
  has_many :trips, :as => 'driver', :foreign_key => 'driver_id'

  #validates_presence_of :fb_id

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def fb_pic_url
    "http://graph.facebook.com/#{fb_id}/picture" if fb_id
  end

  def fb_pic_large_url
    "http://graph.facebook.com/#{fb_id}/picture?type=large" if fb_id
  end

  def fb_link_url
    "http://www.facebook.com/people/@/#{fb_id}" if fb_id
  end

  def fb_id
    if self.authentications.count > 0
      self.authentications.where(:provider => 'facebook').first.uid
    else
      nil
    end
  end
end

