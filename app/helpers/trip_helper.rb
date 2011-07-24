module TripHelper

  def country_list
    {'Estonia' => 'EE', 'Latvia' => 'LV', 'Lithuania' => 'LT', 'Poland' => 'PL'}
  end

  def time_of_day_options
    {'Exact Time' => 'E', 'Morning' => 'M', 'Afternoon' => 'A'}
  end

  def seats_avail_options
    {'1' => '1', '2' => '2', '3' => '3', '4' => '4', '5' => '5', '6' => '6'}
  end

  def all_locations
    all_locations = Location.all
  end

end

