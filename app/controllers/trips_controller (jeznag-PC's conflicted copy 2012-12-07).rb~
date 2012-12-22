class TripsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :edit, :update, :my_trips]

  def index
    @selected_tab = "search"
    @content_for_title = "Visas keliones vienoje vietoje!"
    @content_for_description = "Vilnius, Klaipeda, Kaunas, Panevezys ir daug daugiau"
    @trips = Trip.all
  end

  def show
    @trip = Trip.find(params[:id])
    #@trip_count = @trip.driver_id.trips.where("trip_date < ?", DateTime.now).count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip }
    end
  end

  def new
    @selected_tab = "post"
    @content_for_title = "Pastu"

    @trip = Trip.new
    @trip.time_of_day = "E"
    @trip.driver_id = session[:user_id]
    @man_driver_fb_id = "0" #disables the manual driver add section

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  def manual_new
    @selected_tab = "post"

    @post = QueuedPost.find(params[:post_id])
    user_id = Authentication.find_by_uid(@post.fb_id).user_id if Authentication.find_by_uid(@post.fb_id)

    @trip = Trip.new
    @trip.time_of_day = "E"
    @trip.trip_details = @post.message

    if user_id  #user exists
      @trip.driver_id = user_id
    else
      u = User.create_from_fb_id(@post.fb_id)
      @trip.driver_id = u.id
    end

    respond_to do |format|
      format.html { render action: "new" }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.xml
  def create
    @trip = Trip.new(params[:trip])
    queued_post = QueuedPost.find(params[:hid][:post_id]) if params[:hid]
    #if a driver is assigned, this means the post was manually created (ie QueuedPost)
    @trip.driver_id = current_user.id if !@trip.driver_id

    respond_to do |format|
      if @trip.save

        # mark queued_post as processed
        if queued_post
          queued_post.trip_id = @trip.id
          queued_post.process_type = 'M'
          queued_post.processed_at = DateTime.now
          queued_post.save
        end

        flash[:notice] = 'Trip was successfully created.'
        post_to_fanpage_wall(@trip) if !queued_post #do not post for manual posts
        post_to_users_wall(@trip) if params['misc']['post_to_wall'] == "1" and !queued_post
        format.html { redirect_to @trip }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.xml
  def update
    @trip = Trip.find(params[:id])
    @trip.driver_id = session[:user_id]

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, notice: 'trip was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.xml
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to my_trips_url, :notice => 'Trip was successfully removed.' }
      format.json { head :ok }
    end
  end

  #def get_lat_lng
  #  lat_lng = Location.select("latitude, longitude").where(:id => params[:location_id])
  #
  #  respond_to do |format|
  #    format.json { render :json => lat_lng }
  #  end
  #end

  def get_lat_lng
    lat_lng = eval(params[:trip_type]).find(params[:trip_id])

    respond_to do |format|
      format.json { render :json => lat_lng}
    end
  end

  def load_search_results
    start_id   = params[:start_id]
    start_type = params[:start_type]
    end_id     = params[:end_id]
    end_type   = params[:end_type]
  
    date = params[:date]
    p_page = params[:page]

    conditions = {}
    conditions[:startable_id]   = start_id   if !start_id.blank?
    conditions[:startable_type] = start_type if !start_type.blank?
    conditions[:endable_id]     = end_id     if !end_id.blank?
    conditions[:endable_type]   = end_type   if !end_type.blank?
    conditions[:trip_date] = date         if date != "-1"

    @trips = Trip.where(conditions)
                 .where("trip_date >= ?", DateTime.now.to_date)
                 .order("trip_date, trip_time")
                 .paginate(:page => p_page, :per_page => 20)
    
    if (!date.nil?)
      @sel_trip_date = date.to_date if date != "-1" 
    end

    respond_to do |format|
      format.html { render partial: "search_results"}
    end
  end

  def load_to_locations

    if (params[:from_location_id] == "-1")
      @locations = Location.to_locations
    else
      @locations = Location.where("from_location_id = ?", params[:from_location_id]).to_locations
    end

    respond_to do |format|
      format.html { render partial: "to_location" }
    end
  end

  def load_valid_dates
    conditions = {}
    conditions[:from_location_id] = params[:from_location_id] if !params[:from_location_id].blank?
    conditions[:to_location_id] = params[:to_location_id]     if !params[:to_location_id].blank?

    valid_dates = Trip.where(conditions)
                      .where("trip_date >= ?", DateTime.now.to_date)
                      .select(:trip_date)
                      .map(&:trip_date) #returns this format ["2011-07-26","2011-07-30"]

    respond_to do |format|
      format.json { render :json => valid_dates }
    end
  end

  def my_trips
    @selected_tab = "my_trips"
    @trips = Trip.where(:driver_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def post_to_users_wall(trip)
    me = FbGraph::User.me(session['token'])
    message = trip.startable.to_s + " - " + trip.endable.to_s + " [" + trip.trip_date.to_s(:short) + "]"
    me.feed!(
      :message => trip.trip_details,
      :link => 'www.pavesiu.lt',
      :name => message,
      :description => "Pavesiu.lt Vaziuoju is miesto A i miesta B",
      :picture => "http://pavesiu.heroku.com/assets/pavesiu-logo-50x50.png"
    )
    flash[:notice] = flash[:notice] + ' Trip posted to your facebook wall.'
  end

  def post_to_fanpage_wall(trip)
    fb_page_id = ENV['FB_PAGE_ID'] || '116697818393412' #default: ridesurfing fan page
    page = FbGraph::Page.new(fb_page_id)
    message = trip.startable.to_s + " - " + trip.endable.to_s + " [" + l(trip.trip_date, :format => :very_short) + "]"

    page.feed!(
      :access_token => session['token'],
      :message => trip.trip_details,
      :link => 'www.pavesiu.lt',
      :name => message,
      :description => "Pavesiu.lt Vaziuoju is miesto A i miesta B",
      :picture => "http://pavesiu.heroku.com/assets/pavesiu-logo-50x50.png"
    )
  end
  
  def load_from_location_data
    @locations = Location.from_locations_for_autocomplete(params[:term])
    render :json => @locations.collect{ |x| { :label => x.name, :id => x.id } }
  end
  
  def load_to_location_data
    @locations = Location.to_locations_for_autocomplete(params[:term])
    render :json => @locations.collect{ |x| { :label => x.name, :id => x.id } }
  end

  # search events and cities
  def load_locations_and_events
    locations = Location.from_locations_for_autocomplete(params[:term])
    events    = Event.find(:all, :conditions => ["lower(name) LIKE lower(?)", params[:term]+ '%'])

    @results  = locations + events
    render :json => @results.collect{ |x| { :label => x.name, :id => x.id, :type => x.class.to_s } }.uniq
  end

end

