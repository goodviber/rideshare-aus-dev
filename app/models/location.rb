class Location < ActiveRecord::Base
  has_many :trips_from, :class_name => "Trip", :foreign_key => "from_location_id"
  has_many :trips_to, :class_name => "Trip", :foreign_key => "to_location_id"


  scope :has_trips_from, joins(:trips_from)
                        .select("DISTINCT locations.id, locations.name")
                        .where("trip_date >= ?", DateTime.now)
                        .order("name")

  scope :has_trips_to, joins(:trips_to)
                      .select("DISTINCT locations.id, locations.name")
                      .where("trip_date >= ?", DateTime.now)
                      .order("name")

end

