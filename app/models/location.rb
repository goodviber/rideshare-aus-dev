class Location < ActiveRecord::Base
  
  #attr_accessible :name, :ascii_name, :alternate_names, :latitude, :longitude, :feature_class, :feature_code, :country_code, :cc2, :admin1_code, :admin2_code, :admin3_code, :admin4_code, :population, :elevation, :gtopo30, :timezone, :created_at, :updated_at, :trips_from_count, :trips_to_count
  has_many :trips_from, :class_name => "Trip", :foreign_key => "from_location_id"
  has_many :trips_to, :class_name => "Trip", :foreign_key => "to_location_id"
  has_many :events

  scope :has_trips_from, select("locations.id, name || ' (' || count(name) || ')' as name")
                        .joins(:trips_from)
                        .where("trip_date >= ?", DateTime.now.to_date)
                        .group("locations.id, name")
                        .order("name")

  scope :has_trips_to, select("locations.id, name || ' (' || count(name) || ')' as name")
                      .joins(:trips_to)
                      .where("trip_date >= ?", DateTime.now.to_date)
                      .group("locations.id, name")
                      .order("name")

  scope :apply_filter, where("feature_class = 'P'")
                      .where("feature_code not in ('PPLX','PPLQ')")

  scope :from_locations_total_row, select("-1 as id, 'All cities (' || count(name) || ')' as name").joins(:trips_from).where("trip_date >= ?", DateTime.now.to_date)

  scope :to_locations_total_row, select("-1 as id, 'All Cities (' || count(name) || ')' as name").joins(:trips_to).where("trip_date >= ?", DateTime.now.to_date)

  scope :popular_cities, where("(country_code = 'LT' AND POPULATION > 60000) OR (country_code = 'AU' AND feature_code = 'PPLA')")

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
    #p1 = Location.from_locations_total_row
    #p2 = Location.has_trips_from

    #Attempt to fix cache issue
    if I18n.locale == :lt
      p1 = Location.select("-1 as id, 'Visi miestai (' || count(name) || ')' as name").joins(:trips_from).where("trip_date >= ?", DateTime.now.to_date)
    else
      p1 = Location.select("-1 as id, 'All cities (' || count(name) || ')' as name").joins(:trips_from).where("trip_date >= ?", DateTime.now.to_date)
    end

    p2 = Location.select("locations.id, name || ' (' || count(name) || ')' as name")
                .joins(:trips_from)
                .where("trip_date >= ?", DateTime.now.to_date)
                .group("locations.id, name")
                .order("name")
    full_list = p1 + p2
  end
  
  def self.from_locations_for_autocomplete(term)
#    if I18n.locale == :lt
#      p1 = Location.select("-1 as id, 'Visi miestai (' || count(name) || ')' as name").joins(:trips_from).where("trip_date >= ? and name ILIKE ?", DateTime.now.to_date, "%#{term}%")
#    else
#      p1 = Location.select("-1 as id, 'All cities (' || count(name) || ')' as name").joins(:trips_from).where("trip_date >= ? and name ILIKE ?", DateTime.now.to_date, "%#{term}%")
#    end
#    p2 = Location.select("locations.id, name || ' (' || count(name) || ')' as name")
#                .joins(:trips_from)
#                .where("trip_date >= ? and name ILIKE ?", DateTime.now.to_date, "%#{term}%")
#                .group("locations.id, name")
#                .order("name")
#    full_list = p1 + p2
    
    p1 = Location.select("id, name")
                .where("lower(name) LIKE lower(?)", "#{term}%")
                .group("locations.id, name")
                .order("name")


  end

  def self.to_locations
    #p1 = Location.to_locations_total_row
    #p2 = Location.has_trips_to
    if I18n.locale == :lt
      p1 = Location.select("-1 as id, 'Visi miestai (' || count(name) || ')' as name").joins(:trips_to).where("trip_date >= ?", DateTime.now.to_date)
    else
      p1 = Location.select("-1 as id, 'All Cities (' || count(name) || ')' as name").joins(:trips_to).where("trip_date >= ?", DateTime.now.to_date)
    end

    p2 = Location.select("locations.id, name || ' (' || count(name) || ')' as name")
                .joins(:trips_to)
                .where("trip_date >= ?", DateTime.now.to_date)
                .group("locations.id, name")
                .order("name")

    full_list = p1 + p2
  end
  
  def self.to_locations_for_autocomplete(term)
    #p1 = Location.to_locations_total_row
    #p2 = Location.has_trips_to
#    if I18n.locale == :lt
#      p1 = Location.select("-1 as id, 'Visi miestai (' || count(name) || ')' as name").joins(:trips_to).where("trip_date >= ? AND name ILIKE ?", DateTime.now.to_date, "%#{term}%")
#    else
#      p1 = Location.select("-1 as id, 'All Cities (' || count(name) || ')' as name").joins(:trips_to).where("trip_date >= ? AND name ILIKE ?", DateTime.now.to_date, "%#{term}%")
#    end
#
#    p2 = Location.select("locations.id, name || ' (' || count(name) || ')' as name")
#                .joins(:trips_to)
#                .where("trip_date >= ? AND name ILIKE ?", DateTime.now.to_date, "%#{term}%")
#                .group("locations.id, name")
#                .order("name")
#
#    full_list = p1 + p2
    p1 = Location.select("id, name")
                .where("lower(name) LIKE lower(?)", "#{term}%")
                .group("locations.id, name")
                .order("name")
  end

  #override find_by_alternate_names
  def self.find_by_alternate_names(city_to_check)
    Location.populate_alternate_names
    location_id = nil
    @@alternate_names.each do |row|
      city_names = row.alternate_names.split(',')
      #debugger
      city_names.each do |city|
        city.strip!
        if city == city_to_check
          return row   #location row
        end
      end
    end
    nil #return nil if no matches
    rescue Exception => exc
      puts exc.to_s
  end

  @@alternate_names = nil
  private
  def self.populate_alternate_names
    #load top 250 cities alternate_names
    if !@@alternate_names
      @@alternate_names = Location.limit(250)
      .select(:id)
      .select(:alternate_names)
      .where('alternate_names is not null')
      .order('population desc')
    end
  end
end

