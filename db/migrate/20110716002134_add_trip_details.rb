class AddTripDetails < ActiveRecord::Migration
  def up
    add_column :trips, :trip_details, :string
  end

  def down
    remove_column :trips, :trip_details
  end
end

