Rails.application.config.middleware.use OmniAuth::Builder do

  APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/omniauth_config.yml")[Rails.env]

  #ENV is configured in heroku app. "heroku config"
  app_id = ENV['app_id'] || APP_CONFIG['app_id']
  app_secret = ENV['app_secret'] || APP_CONFIG['app_secret']

  provider :facebook, app_id, app_secret, {:scope => 'publish_stream, email'}
end

