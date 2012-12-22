class AddTripFields < ActiveRecord::Migration
  def up
    remove_column :trips, :to_location_id
    remove_column :trips, :from_location_id

    # add polymorphic columns
    add_column :trips, :startable_id,   :integer, :default => 0, :null => false
    add_column :trips, :startable_type, :string

    add_column :trips, :endable_id,     :integer, :default => 0, :null => false
    add_column :trips, :endable_type,   :string
  end

  def down
    add_column :trips, :to_location_id,   :integer, :null => false, :default => 0
    add_column :trips, :from_location_id, :integer, :null => false, :default => 0

    # remove polymorphic columns
    remove_column :trips, :startable_id
    remove_column :trips, :startable_type

    remove_column :trips, :endable_id
    remove_column :trips, :endable_type
  end
end
