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
    {'Free' => '0', '5' => '5', '10' => '10', '15' => '15', '20' => '20', '25' => '25', '30' => '30'}
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

end

