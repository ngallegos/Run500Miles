require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Run500Miles
  class Application < Rails::Application
    config.load_defaults 7.2

    # Filter sensitive parameters from logs
    config.filter_parameters += [:password]

    # Secret key base
    if Rails.env.production?
      # In production, require SECRET_KEY_BASE to be set; do not use a fallback
      config.secret_key_base = ENV.fetch('SECRET_KEY_BASE')
    else
      # In non-production, prefer ENV or generate via `rails credentials:edit`
      config.secret_key_base = ENV['SECRET_KEY_BASE']
    end
  end
end
