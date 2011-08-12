Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '119073948160554', 'f96ca2df959982257ff65cee4c5be74d', {:scope => 'publish_stream,offline_access,email'}
end

