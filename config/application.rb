require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Run500Miles
  class Application < Rails::Application
    config.load_defaults 7.2

    # Filter sensitive parameters from logs
    config.filter_parameters += [:password]

    # Secret key base — override via SECRET_KEY_BASE env var in production
    config.secret_key_base = ENV.fetch('SECRET_KEY_BASE', 'run500miles_dev_secret_key_base_placeholder_not_for_production')
  end
end
