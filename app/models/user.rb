class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authentications
  has_many :trips, :foreign_key => 'driver_id'

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

  def self.create_from_fb_id(fb_id)

    response = RestClient.get 'https://graph.facebook.com/' + fb_id
    fb_obj = JSON.parse(response.body)

    rand = User.maximum(:id).to_i + 1
    user = User.new
    user.first_name = fb_obj['first_name'] if fb_obj['first_name']
    user.last_name = fb_obj['last_name']   if fb_obj['last_name']
    user.email = rand.to_s + "@system.com"
    user.password = "123456"

    user.authentications.build(:provider => 'facebook', :uid => fb_id)
    user.save!
    user
  rescue Exception => error
      "Error: " + error.to_s
  end

end

