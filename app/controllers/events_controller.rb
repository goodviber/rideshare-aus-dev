 class EventsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    page = params[:page] || 1

    conditions = {} 

    @events = Event.where(conditions).paginate(:per_page => 20, :page => page).order("event_date, event_time")

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
  end

  def create
    @event = Event.new(params[:event])

    if @event.save
      redirect_to 'index'   
    else
      render :ation => 'new'
    end
  end

  def search
    conditions = {}

    conditions[:location_id] = params[:location_id] if !params[:location_id].blank?
    conditions[:event_date]  = params[:event_date]  if params[:event_date] != "-1"

    page = params[:page] || 1

    @events = Event.where(conditions)
                   .where("event_date >= ?", DateTime.now.to_date)
                   .order("event_date, event_time")
                   .paginate(:per_page => 20, :page => page)   

    respond_to do |format|
      format.html { render :partial => 'search_results' }
    end

  end

  def load_locations
    @locations = Event.all_locations(params[:term])
    render :json => @locations.collect{ |x| { :label => x.name, :id => x.id } }
  end


end
