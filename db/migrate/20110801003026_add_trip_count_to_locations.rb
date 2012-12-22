class AddTripCountToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :trips_from_count, :integer, :default => 0
    add_column :locations, :trips_to_count, :integer, :default => 0

    Location.reset_column_information
    Location.all.each do |p|
      Location.update_counters p.id, :trips_from_count => p.trips_from.length
      Location.update_counters p.id, :trips_to_count => p.trips_to.length
    end

  end

  def down
    remove_column :locations, :trips_from_count
    remove_column :locations, :trips_to_count
  end
end

