 class EventsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    page = params[:page] || 1

    conditions = {} 

    @events = Event.paginate(:per_page => 20, :page => page).order("event_date, event_time")

    respond_to do |format|
      format.html
    end
  end

  def show
    @event = Event.find_by_id(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @event}
    end
  end
 
  def new
    @event = Event.new
    #5.times { @event.photos.build }
  end

  def create
    @event = Event.new(params[:event])

    if @event.save
      redirect_to @event
    else
      render :action => 'new'
    end
  end

  def search
    conditions = []

    # search by event name or location
    if !params[:location_from].blank?
      conditions << "(lower(events.name) = lower('#{params[:location_from]}') or lower(locations.name) = lower('#{params[:location_from]}'))"
    end

    if params[:event_date] != "-1"
      conditions << "event_date = #{params[:event_date]}"
    end

    conditions << "events.location_id = locations.id"
    conditions = conditions.join(" and ")

    page = params[:page] || 1

    @events = Event.where(conditions)
                   .where("event_date >= ?", DateTime.now.to_date)
                   .joins("events,locations")
                   .order("event_date, event_time")
                   .paginate(:per_page => 20, :page => page)   

    respond_to do |format|
      format.html { render :partial => 'search_results' }
    end

  end

  # for events#new location field
  def load_locations
    @locations = Location.all_with_coordinates(params[:term])
    render :json => @locations.collect{ |x| { :label => x.name, :id => x.id, :lat => x.latitude, :long => x.longitude } }
  end

  # for events search - search for events as well as cities
  def load_locations_and_events
    locations = Location.from_locations_for_autocomplete(params[:term])
    events    = Event.find(:all, :conditions => ["lower(name) LIKE lower(?)", params[:term]+ '%'])
  
    @results  = locations + events
    render :json => @results.collect{ |x| { :label => x.name, :id => x.name } }.uniq
  end

  # for trips#new in case an event - set event date in trip_date
  def get_event_date
    event = Event.find_by_id(params[:id])

    render :json => event.event_date
  end

end