source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem "pg"
gem 'rails-i18n'
gem 'heroku'
gem 'taps'
gem 'activeadmin'
gem 'will_paginate'
gem 'paperclip', '~> 3.0'
gem 'rest-client'

# gem 'blueprint-rails'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'

# Asset template engines
gem 'sass-rails', "~> 3.1.0"
gem 'coffee-script'
gem 'uglifier'
gem "devise", "~> 1.5.2"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'fb_graph'
gem "jquery-rails"
#gem "less", :platforms => :ruby
#gem 'therubyracer', :platforms => :ruby

gem 'execjs'

gem "capybara", :group => [:development, :test]
gem "rspec-rails", ">= 2.0.1", :group => [:development, :test]
#gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache',:group => [:development, :test]

group :testing do

end

group :development, :test do
  gem "cheat"
  if RUBY_VERSION =~ /1.9/ 
    #gem 'ruby-debug19' 
  else 
    gem 'ruby-debug' 
  end 
  
  #gem 'ruby-debug-base19x', '~> 0.11.30.pre4'
end

gem 'factory_girl_rails'
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :production, :staging do
  gem 'therubyracer', '~> 0.9.3.beta1', :platforms => :ruby

end
