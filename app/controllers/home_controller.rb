class HomeController < ApplicationController

  def index
    @selected_tab = "home"
  end
  
  def import_locations
    require 'csv'  
        
    filename = Rails.root + "db/locations.csv"
        
    conn = ActiveRecord::Base.connection
    conn.execute("TRUNCATE locations")
    

    csv_text = File.read(filename)
    
    csv = CSV.parse(csv_text, :headers => true, :col_sep =>";")
    csv.each do |row|
      
      puts "#{row[0]} ----- #{row[1]}"

      Location.create(
        :id=>row[0], 
        :name=>row[1], 
        :ascii_name=>row[2], 
        :alternate_names=>row[3], 
        :latitude=>row[4], 
        :longitude=>row[5], 
        :feature_class=>row[6], 
        :feature_code=>row[7], 
        :country_code=>row[8], 
        :cc2=>row[9], 
        :admin1_code=>row[10], 
        :admin2_code=>row[11], 
        :admin3_code=>row[12], 
        :admin4_code=>row[13], 
        :population=>row[14], 
        :elevation=>row[15], 
        :gtopo30=>row[16], 
        :timezone=>row[17], 
        :created_at=>row[18], 
        :updated_at=>row[19], 
        :trips_from_count=>row[20], 
        :trips_to_count=>row[21]
      )
    end

    
    #raise csv_text.inspect

  end

  def import_australian_cities
    require 'csv'  
        
    filename = Rails.root + "db/australian-locations.csv"
        
    conn = ActiveRecord::Base.connection
    
    csv_text = File.read(filename)
    
    csv = CSV.parse(csv_text, :headers => true, :col_sep =>",")
    csv.each do |row|

      Location.create(
        :name=>row[0], 
        :latitude=>row[2], 
        :longitude=>row[3], 
        :population=>row[2]
      )

    end    
  end

end

