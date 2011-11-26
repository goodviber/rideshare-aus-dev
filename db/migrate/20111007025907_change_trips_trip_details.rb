class ChangeTripsTripDetails < ActiveRecord::Migration
  def change
    change_column(:trips, :trip_details, :text)
  end
end

