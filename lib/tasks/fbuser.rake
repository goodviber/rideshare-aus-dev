desc "Test fb load"
require 'rest_client'
task :fbuser => :environment do
  response = RestClient.get 'https://graph.facebook.com/100000227331654'
  puts "*******************************" + response
  
end



