desc "Load trips from fb fan page"
task :cron => :environment do
  puts Trip.load_from_fb_page('tranzuok') #176073525768645
  puts Trip.load_from_fb_page('pavesiu')  #161847627166445
  puts Trip.load_from_fb_page('vaziuoju') #286064822992
  puts Trip.remove_duplicates
  puts Trip.migrate_data
  puts Trip.remove_old_posts(5)
end

