require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LendDeskCodingChallengeRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.force_ssl = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"

    config.after_initialize do
      redis_connection = Rails.env.test? ? MockRedis.new : Redis.new(host: 'localhost', port: 6379)
      connection = ConnectionPool::Wrapper.new(size: 5, timeout: 5) { redis_connection }

      User.redis = connection
      LoginSession.redis = connection
    end
  end
end
