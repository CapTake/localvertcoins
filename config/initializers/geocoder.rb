Geocoder.configure(
  lookup: :google,
  ip_lookup: :geoip2,
  geoip2: {
    file: File.join('vendor/share', 'GeoLite2-City.mmdb')
  },
  use_https: true,
  cache: Redis.new(:host => 'localvertcoins-redis', :port => 6379),
  api_key: Settings.google_geocode.key
)
