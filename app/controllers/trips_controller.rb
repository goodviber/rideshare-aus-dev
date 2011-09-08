class TripsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :edit, :update, :my_trips]

  def index
    @selected_tab = "search"
    @content_for_title = "Search Trips"
    @trips = Trip.all
  end

  def show
    @trip = Trip.find(params[:id])

    @trip_count = current_user.trips.where("trip_date < ?", DateTime.now).count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip }
    end
  end

  def new
    @selected_tab = "post"
    @trip = Trip.new
    @trip.time_of_day = "E"
    @trip.driver_id = session[:user_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
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
    @trip.driver_id = current_user.id

    respond_to do |format|
      if @trip.save
        flash[:notice] = 'Trip was successfully created.'
        post_to_fanpage_wall(@trip)
        post_to_users_wall(@trip) if params['misc']['post_to_wall'] == "1"
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

  def get_lat_lng
    lat_lng = Location.select("latitude, longitude").where(:id => params[:location_id])

    respond_to do |format|
      format.json { render :json => lat_lng }
    end
  end

  def load_search_results

    fl_id = params[:from_location_id]
    tl_id = params[:to_location_id]
    date = params[:date]

    conditions = {}
    conditions[:from_location_id] = fl_id if fl_id != "-1"
    conditions[:to_location_id] = tl_id   if tl_id != "-1"
    conditions[:trip_date] = date         if date != "-1"

    @trips = Trip.where(conditions)
                 .where("trip_date >= ?", DateTime.now.to_date)
                 .order("trip_date, trip_time")

    @sel_trip_date = date.to_date if date != "-1"

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
    conditions[:from_location_id] = params[:from_location_id] if params[:from_location_id] != "-1"
    conditions[:to_location_id] = params[:to_location_id]     if params[:to_location_id] != "-1"

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
    @trips = Trip.all

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def post_to_users_wall(trip)
    me = FbGraph::User.me(session['token'])
    message = trip.from_location.name + " - " + trip.to_location.name + " [" + trip.trip_date.to_s(:short) + "]"
    me.feed!(
      :message => trip.trip_details,
      :link => 'www.cocoride.com.au',
      :name => message,
      :description => "Share the cost. Share the experience. Share the ride."
    )
    flash[:notice] = flash[:notice] + ' Trip posted to your facebook wall.'
  end

  def post_to_fanpage_wall(trip)
    page = FbGraph::Page.new(116697818393412) #Ridesurfing page ID: 116697818393412
    message = "Rideshare: " + trip.from_location.name + " - " + trip.to_location.name + " [" + trip.trip_date.to_s(:short) + "]"
    page.feed!(
      :access_token => session['token'],
      :message => trip.trip_details,
      :link => 'www.cocoride.com.au',
      :name => message,
      :description => "Share the cost. Share the experience. Share the ride.",
      :picture => "http://upload.wikimedia.org/wikipedia/commons/3/3a/Matrix-50x50.gif"
    )
  end

end

