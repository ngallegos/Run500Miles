require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = :rescuable
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.maintain_test_schema = true

  # Set deterministic secret key for test environment
  # WARNING: This is only for test environment - never use in production!
  # Using a realistic-length key to better simulate production behavior
  config.secret_key_base = '173b11beda45abe0420fe63478ddc88a7b81de671837caffc6e9f31adce2d64bf2aba4ed886f10c8e22909fd55d08077859d3deb6c796776ff91e0b905566480'
end
