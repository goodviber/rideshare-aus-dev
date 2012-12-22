module TripHelper

  def country_list
    {'Estonia' => 'EE', 'Latvia' => 'LV', 'Lithuania' => 'LT', 'Poland' => 'PL'}
  end

  def time_of_day_options
    {'Exact Time' => 'E', 'Morning' => 'M', 'Afternoon' => 'A'}
  end

  def seat_options
    {'1' => '1', '2' => '2', '3' => '3', '4' => '4', '5' => '5', '6' => '6'}
  end

  def cost_options
    {t(:no_cost) => '0',
    number_to_currency(5, :precision => 0) => '5',
    number_to_currency(10, :precision => 0) => '10',
    number_to_currency(15, :precision => 0) => '15',
    number_to_currency(20, :precision => 0) => '20',
    number_to_currency(25, :precision => 0) => '25',
    number_to_currency(30, :precision => 0) => '30',
    number_to_currency(35, :precision => 0) => '35',
    number_to_currency(40, :precision => 0) => '40',
    number_to_currency(45, :precision => 0) => '45',
    number_to_currency(50, :precision => 0) => '50'}
  end

  def all_locations
    all_locations = Location.all
  end

  def selected_date
    "Trips leaving on: " + I18n.l(@sel_trip_date, :format => :long) if !@sel_trip_date.blank?
  end

  def trip_duration
    if @trip.trip_duration
      l @trip.trip_duration, :format => :time_only_long
    else
      "N/A"
    end
  end

  def trip_distance
    if @trip.trip_distance
      @trip.trip_distance.round.to_s + " km"
    else
      "N/A"
    end
  end

  def departing_time
    if @trip.trip_time
      d = @trip.trip_date
      t = @trip.trip_time
      l d.to_datetime.advance(:hours => t.hour, :minutes => t.min), :format => :short
    else
      t(:afternoon) if @trip.time_of_day == "A"
      t(:morning) if @trip.time_of_day == "M"
    end
  end

  def arrival_time
    return "N/A" if @trip.trip_duration.nil?
    if @trip.trip_time
      d = @trip.trip_date
      t = @trip.trip_time
      duration = @trip.trip_duration
      depart = d.to_datetime.advance(:hours => t.hour, :minutes => t.min)
      l depart.advance(:hours => duration.hour, :minutes => duration.min), :format => :short
    else
      "N/A"
    end
  end

  def driver_name
    if @trip.driver_id
      @trip.driver.full_name
    else
      current_user.full_name
    end
  end

end

