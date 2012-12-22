class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string   :name
      t.date 	 :event_date
      t.time     :event_time
      t.text     :description
      t.integer  :location_id
      t.string   :website
      t.integer  :driver_id
      
      t.timestamps
    end
  end
end
