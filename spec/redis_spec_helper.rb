RSpec.configure do |config|
  config.before(:each) do
    User.redis.flushdb
    LoginSession.redis.flushdb
  end
end
