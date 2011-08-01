class Location < ActiveRecord::Base
  has_many :trips_from, :class_name => "Trip", :foreign_key => "from_location_id"
  has_many :trips_to, :class_name => "Trip", :foreign_key => "to_location_id"


  scope :has_trips_from, select("locations.id, name || ' (' || count(name) || ')' as name")
                        .joins(:trips_from)
                        .where("trip_date >= ?", DateTime.now)
                        .group("locations.id, name")
                        .order("name")

  scope :has_trips_to, select("locations.id, name || ' (' || count(name) || ')' as name")
                      .joins(:trips_to)
                      .where("trip_date > ?", DateTime.now-1)
                      .group("locations.id, name")
                      .order("name")

  scope :apply_filter, where("feature_class = 'P'")
                      .where("feature_code not in ('PPLX','PPLQ')")

  scope :from_locations_total_row, select("-1 as id, 'All Cities (' || count(name) || ')' as name")
                                  .joins(:trips_from)
                                  .where("trip_date >= ?", DateTime.now)

  scope :to_locations_total_row, select("-1 as id, 'All Cities (' || count(name) || ')' as name")
                                 .joins(:trips_to)
                                 .where("trip_date >= ?", DateTime.now)



  scope :popular_cities, where("country_code = 'LT' AND POPULATION > 60000")

  scope :blank_row, select("-1 as id, '-------------------------------' as name").limit(1)

  def self.all_cities
    p1 = Location.popular_cities
                 .apply_filter
                 .select("id, name")
                 .order("name")

    p2 = Location.apply_filter
                 .select("id, name")
                 .order("name")

    blank = Location.blank_row

    full_list = blank + p1 + blank + p2
  end

  def self.from_locations
    p1 = Location.from_locations_total_row
    p2 = Location.has_trips_from
    full_list = p1 + p2
  end

  def self.to_locations
    p1 = Location.to_locations_total_row
    p2 = Location.has_trips_to
    full_list = p1 + p2
  end

end

