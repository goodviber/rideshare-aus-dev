class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :to_location_id
      t.integer :from_location_id
      t.integer :seats, :limit => 2, :default => 0, :null => false
      t.integer :driver_id, :null => false		#links to User
      t.date	:trip_date
      t.time	:trip_time
      t.string	:time_of_day
      t.integer :rel_trip_id
      t.decimal :trip_distance, :precision => 18, :scale => 4
      t.time    :trip_duration
      t.string  :fb_post_id, :limit => 500
      t.timestamps
    end
  end
end

