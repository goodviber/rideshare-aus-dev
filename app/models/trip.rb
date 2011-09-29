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
    most_recent_post_created_at = '01-01-2000'
    most_recent_post_created_at = QueuedPost.where(:page_id => page_id).maximum(:post_created_at) if QueuedPost.where(:page_id => page_id).maximum(:post_created_at)

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
  end

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

end

