Coverband.configure do |config|
  # config.store = Coverband::Adapters::RedisStore.new(Redis.new(url: ENV['PROSEEKER_REDIS_URL']))
  config.password = ENV.fetch('PROSEEKER_COVERBAND_PASSWORD', SecureRandom.uuid)
  config.redis_url = ENV['PROSEEKER_REDIS_URL']

  config.logger = Rails.logger
  config.verbose = true
end
