Geocoder.configure(
  lookup: :google,
  use_https: true,
  cache: Redis.new(:host => 'localvertcoins-redis', :port => 6379),
  api_key: Settings.google_geocode.key
)
