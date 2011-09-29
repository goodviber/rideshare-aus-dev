desc "Load trips from fb fan page"
task :cron => :environment do
  puts Trip.load_from_fb_page('tranzuok')
  puts Trip.load_from_fb_page('pavesiu')
  puts Trip.load_from_fb_page('vaziuoju')
  #puts Trip.clean_and_migrate_posts
  #load from queued to trips (using reg exp)
end

