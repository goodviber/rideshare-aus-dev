class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
		  t.string :name,			:limit => 200
		  t.string :ascii_name,		:limit => 200
		  t.string :alternate_names,	:limit => 5000
		  t.string :latitude,		:limit => 1000
		  t.string :longitude,		:limit => 1000
		  t.string :feature_class,	:limit => 1
		  t.string :feature_code,		:limit => 10
		  t.string :country_code,		:limit => 10
		  t.string :cc2,			:limit => 2000
		  t.string :admin1_code,		:limit => 20
		  t.string :admin2_code,		:limit => 80
		  t.string :admin3_code,		:limit => 20
		  t.string :admin4_code,		:limit => 20
		  t.integer :population
		  t.integer :elevation
		  t.integer :gtopo30
		  t.string :timezone,		:limit => 1000
		  t.timestamps
    end
  end
end

