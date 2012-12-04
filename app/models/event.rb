class Event < ActiveRecord::Base

  belongs_to :location
  belongs_to :driver, :foreign_key => :driver_id, :class_name => "User"

  has_many   :photos
  accepts_nested_attributes_for :photos

  has_many   :trips, :as => :startable
  has_many   :trips, :as => :endable

  validates_presence_of :name, :location_id, :event_date, :event_time

  before_create :set_driver_id

  def to_s
    name
  end

  def event_time_format
    if self[:event_time].blank?
      format_time_of_day(self[:time_of_day])
    else
      I18n.l(self[:event_time], :format => :time_only)
    end
  end

  def set_driver_id
    self.driver_id = User.current_user.id
  end

end
