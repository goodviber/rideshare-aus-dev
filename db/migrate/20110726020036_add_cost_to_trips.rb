class AddCostToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :cost, :integer, :default => 0
  end

  def down
    remove_column :trips, :cost
  end
end

