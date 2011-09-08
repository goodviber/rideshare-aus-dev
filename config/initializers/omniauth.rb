Rails.application.config.middleware.use OmniAuth::Builder do

  APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/omniauth_config.yml")[Rails.env]

  provider :facebook, APP_CONFIG['app_id'], APP_CONFIG['app_secret'], {:scope => 'publish_stream,offline_access,email'}
end

