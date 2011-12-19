class Trip < ActiveRecord::Base

  #Counters cache is not date specific. Can not use for drop down list.
  belongs_to :from_location, :foreign_key => "from_location_id", :class_name => "Location", :counter_cache => :trips_from_count
  accepts_nested_attributes_for :from_location

  belongs_to :to_location, :foreign_key => "to_location_id", :class_name => "Location", :counter_cache => :trips_to_count
  accepts_nested_attributes_for :to_location

  belongs_to :driver, :foreign_key => "driver_id", :class_name => "User"
  accepts_nested_attributes_for :driver

  belongs_to :related_trip, :foreign_key => "rel_trip_id", :class_name => "Trip"

  validates_presence_of :from_location_id, :to_location_id, :driver_id, :trip_date, :trip_details, :cost

  validate :future_date?, :valid_from_locations?, :valid_to_locations?

  @@load_count = 0

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

  def self.load_from_fb_page(page_id)
    #TO DO - setup using app_id and secret in config file
    #see https://github.com/iliu/mysite-examples/blob/fb_graph_cache/config/facebook.yml for example
    gscc_app = FbGraph::Application.new(119073948160554);
    access_token = gscc_app.get_access_token('f96ca2df959982257ff65cee4c5be74d');
    page = FbGraph::Page.new(page_id, :access_token => access_token).fetch;

    @@load_count = 0
    continue = true
    #TO DO - create config table that stores, fb page name, id and last imported date
    #the current code is incorrect as the records that contain max(date) are deleted when processed successfully
    most_recent_post_created_at = '01-01-2000'
    most_recent_post_created_at = QueuedPost.where(:page_id => page.identifier).maximum(:post_created_at) if QueuedPost.where(:page_id => page.identifier).maximum(:post_created_at)

    #load pages 1-4 of fan page posts
    continue = fetch_fb_first_page(page, most_recent_post_created_at)
    continue = fetch_fb_second_page(page, most_recent_post_created_at) if continue
    continue = fetch_fb_third_page(page, most_recent_post_created_at)  if continue
    fetch_fb_fourth_page(page, most_recent_post_created_at)            if continue

    if @@load_count == 0
      "[#{page_id}] Database is up to date."
    else
      "[#{page_id}] #{@@load_count} post have been successfully loaded."
    end

  rescue Exception => error
      "[#{page_id}] Error: " + error.to_s
  end

  private
  def self.add_post(page_id, post)
    new_post = QueuedPost.new
    new_post.page_id = page_id
    new_post.post_id = post.identifier
    new_post.fb_id = post.from.identifier
    new_post.message = post.message
    new_post.post_created_at = post.created_time
    new_post.save

    rescue Exception => exc

  end

  #TO DO: refactor to store "page.feed" in array variable depending on page_num [eg 1-4] (new paramater)
  private
  def self.fetch_fb_first_page(page, load_after_datetime) #0-25
    continue = true
    page.feed.each do |post|
      if post.created_time > load_after_datetime
        add_post(page.identifier, post)
        @@load_count+=1
      else
        continue = false
        break
      end
    end
    continue
  end

  private
  def self.fetch_fb_second_page(page, load_after_datetime) #25-50
    continue = true
    page.feed.next.each do |post|
      if post.created_time > load_after_datetime
        add_post(page.identifier, post)
        @@load_count+=1
      else
        continue = false
        break
      end
    end
    continue
  end

  private
  def self.fetch_fb_third_page(page, load_after_datetime) #50-75
    continue = true
    page.feed.next.next.each do |post|
      if post.created_time > load_after_datetime
        add_post(page.identifier, post)
        @@load_count+=1
      else
        continue = false
        break
      end
    end
    continue
  end

  private
  def self.fetch_fb_fourth_page(page, load_after_datetime) #75-100
    continue = true
    page.feed.next.next.next.each do |post|
      if post.created_time > load_after_datetime
        add_post(page.identifier, post)
        @@load_count+=1
      else
        continue = false
        break
      end
    end
    continue
  end

  def self.remove_duplicates
    del_count = QueuedPost.where("id not in (?)",QueuedPost.all.uniq_by { |p| p.message }.map(&:id)).delete_all
    "#{del_count} duplicate entries have been removed."
  end

  def self.migrate_data
    processed_count = 0

    list_of_posts = QueuedPost.where("processed_at is null")
    to_process_count = list_of_posts.count

    success = false
    list_of_posts.each do |post|
      success = transform_and_load(post)
      processed_count+=1 if success
    end

    "#{processed_count} of #{to_process_count} post have successfully loaded into the system."
  end

  def self.transform_and_load(post)

    #create user/driver if doesn't exist
    auth_user = Authentication.find_by_uid(post.fb_id)
    if auth_user
      driver_id = auth_user.user_id
    else
      user = User.create_from_fb_id(post.fb_id) if !auth_user
      driver_id = user.id
    end

    trip = Trip.new

    #10-11 val, 12val 14 Val, 23H, 12:30
    trip_time = post.message.match(/([0-2][0-9][-])*[0-2]*[0-9]\s?([v|V|h|H]|:[0-5][0-9])(\s|\z|(al))/)

    #Dates: Try format - 5d, (spalio 8d), (spalio 8 d)
    trip_date = post.message.match(/([0]?[1-9]|[1|2][0-9]|[3][0|1])[\s]?[d][\s).]/)
    trip_day_of_month = trip_date[0].gsub(/[^0-9]/, '') if trip_date

    begin
      trip.trip_date = Date.strptime("{#{trip_day_of_month}}", "{%d}") if trip_day_of_month && trip_date
    rescue Exception => e
    end

    #Dates: next try this format - (05.31)
    if !trip_date
      trip_date = post.message.match(/\d(0?[1-9]|1[012])[- .](0?[1-9]|[12][0-9]|3[01])\d/)
      trip_date_arr = trip_date[0].split(/[.-]/) if trip_date

      begin
        trip.trip_date = Date.strptime("{#{trip_date_arr[0]} #{trip_date_arr[1]}}", "{%m %d}") if trip_date_arr
      rescue Exception => e
      end
    end

    cost = post.message.match(/[0-9]{2}\s*[L|l][t|T]/)
    trip.cost = cost[0].gsub(/[^0-9]/, '') if cost

    cleaned_message = post.message.gsub(/[!~,().?-]/,' ')
    words = cleaned_message.split(' ')

    location_ids = Array.new
    mobile_number = 0

    words.each { |word|

      #check if word contains any numbers.
      #Yes - could be date, time, or cost, phone number
      #No - could be location
      if contains_number(word)
        if is_mobile?(word)
          mobile_number = word
        end
      else
        if word.length > 2
          city = word
          city.strip! #remove white spaces

          location = Location.find_by_name(city.capitalize)
          #check "ascii_name" column if we did not find anything in previous step and city contains ascii only chars
          location = Location.find_by_ascii_name(city.capitalize) if !location && city.ascii_only?
          if !location
            location = Location.new
            location = Location.find_by_alternate_names(city.capitalize)
          end
          if location
            location_ids << location.id if location.id && !location_ids.include?(location.id)
          end
        end
      end
    }

    trip.from_location_id = location_ids[0] if location_ids[0]
    trip.to_location_id = location_ids[1]   if location_ids[1]
    trip.trip_time = "8:00" if !trip_time
    trip.time_of_day = trip_time.to_s
    #if no date could be found, then use the date that the trip was posted on + 1 day
    trip.trip_date = (post.post_created_at+1.day).to_date  if !trip.trip_date

    trip.cost = 0 if !trip.cost
    trip.driver_id = driver_id
    trip.trip_details = post.message

    if trip.save
      #update Queued Post
      qp = QueuedPost.find_by_post_id(post.post_id)
      qp.process_type = "A"
      qp.trip_id = trip.id
      qp.processed_at = DateTime.now
      qp.save

      true
    else
      qp = QueuedPost.find_by_post_id(post.post_id)
      qp.trip_id = trip.id
      qp.error_msg = trip.errors.full_messages[0]
      qp.save

      false
    end

    rescue Exception => exc
      #debugger
      puts "Error occured processing queued_posts id #{post.id}\n-" + exc.to_s
  end

  private
  def self.is_mobile?(string)
    string.match(/\A[+-]?\d+?(\.\d+)?\Z/) && string.length > 7
  end

  private
  def self.contains_number(string)
    string.match(/\d/)
  end

end

