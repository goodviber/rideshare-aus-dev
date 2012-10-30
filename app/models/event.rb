class Event < ActiveRecord::Base

  belongs_to :location
  belongs_to :driver, :foreign_key => :driver_id, :class_name => "User"
  accepts_nested_attributes_for :driver

  def self.all_locations(term)
   if term.blank?
     Location.select("locations.name, locations.id")
  else
    sql = "Select locations.name, locations.id
             From locations, events
            Where locations.id = events.location_id and
                  lower(locations.name) like lower('#{term}%')"
    Location.find_by_sql(sql)
    end
  end

  def event_time_format
    if self[:event_time].blank?
      format_time_of_day(self[:time_of_day])
    else
      I18n.l(self[:event_time], :format => :time_only)
    end
  end

end
