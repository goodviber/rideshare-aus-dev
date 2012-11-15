class Photo < ActiveRecord::Base

  belongs_to :event

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "50x50>", :url => "/system/:class/:property_id/:id/:style/:basename.:extension",
   :path => ":rails_root/public/system/:class/:property_id/:id/:style/:basename.:extension" }
end
