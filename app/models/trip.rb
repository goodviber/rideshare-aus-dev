class Trip < ActiveRecord::Base
  belongs_to :from_location, :foreign_key => "from_location_id", :class_name => "Location", :counter_cache => :trips_from_count
  accepts_nested_attributes_for :from_location

  belongs_to :to_location, :foreign_key => "to_location_id", :class_name => "Location", :counter_cache => :trips_to_count
  accepts_nested_attributes_for :to_location


  belongs_to :driver, :foreign_key => "driver_id", :class_name => "User"
  accepts_nested_attributes_for :driver

  belongs_to :related_trip, :foreign_key => "rel_trip_id", :class_name => "Trip"

  validates_presence_of :from_location_id, :to_location_id, :driver_id, :trip_date, :seats, :trip_details, :cost

  validate :future_date?

  def future_date?
    yesterday = DateTime.now-1
    unless self[:trip_date] >= yesterday
      errors.add(:trip_date, "must not be in the past.")
    end
  end


  # ActiveRecord: override how we access field
  #only set the trip time if time of day is "exact time" (E)
  def trip_time=(time)
    self[:trip_time] = time if self[:time_of_day] == "E"
  end

  def time_of_day=(tod)
    self[:time_of_day] = tod
    self[:trip_time] = nil unless self[:time_of_day] == "E"
  end

  def dis_trip_time
    if self[:trip_time].blank?
      format_time_of_day(self[:time_of_day])
    else
      I18n.l(self[:trip_time], :format => :time_only)
    end
  end

  def format_time_of_day(value)
    if value == "A"
      "AM"
    elsif value == "M"
      "PM"
    end
  end

end

