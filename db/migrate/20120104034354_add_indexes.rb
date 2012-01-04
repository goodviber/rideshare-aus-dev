class AddIndexes < ActiveRecord::Migration
  def up
    add_index(:trips, :id, { :unique => true })
    add_index(:trips, :to_location_id)
    add_index(:trips, :from_location_id)
    add_index(:trips, :trip_date)

    add_index(:locations, :id, { :unique => true })
    add_index(:locations, :name)
    add_index(:locations, :ascii_name)
    add_index(:locations, :alternate_names)
  end

  def down
  end
end

