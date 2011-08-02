class Trip < ActiveRecord::Base

  #Counters cache is not date specific. Can not use for drop down list.
  belongs_to :from_location, :foreign_key => "from_location_id", :class_name => "Location", :counter_cache => :trips_from_count
  accepts_nested_attributes_for :from_location

  belongs_to :to_location, :foreign_key => "to_location_id", :class_name => "Location", :counter_cache => :trips_to_count
  accepts_nested_attributes_for :to_location

  belongs_to :driver, :foreign_key => "driver_id", :class_name => "User"
  accepts_nested_attributes_for :driver

  belongs_to :related_trip, :foreign_key => "rel_trip_id", :class_name => "Trip"

  validates_presence_of :from_location_id, :to_location_id, :driver_id, :trip_date, :seats, :trip_details, :cost

  validate :future_date?, :valid_from_locations?, :valid_to_locations?

  def future_date?
    unless self[:trip_date] >= DateTime.now.to_date
      errors.add(:trip_date, "must not be in the past.")
    end
  end

  def valid_from_locations?
    unless self[:from_location_id] != -1
      errors.add(:from_location_id, "must be a valid location")
    end
  end

  def valid_to_locations?
    unless self[:to_location_id] != -1
      errors.add(:to_location_id, "must be a valid location")
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
      "PM"
    elsif value == "M"
      "AM"
    end
  end

end

