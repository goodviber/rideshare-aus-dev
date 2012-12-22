desc "Delete old trips"
task :wipetrips => :environment do

  puts Trip.remove_old_posts(0)  

end

