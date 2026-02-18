ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    # Seed required Configuration records for all tests
    [
      { key: 'secret-word',     value: 'angusbeef'      },
      { key: 'quote-content',   value: 'Run your best.' },
      { key: 'quote-source',    value: 'Anonymous'      },
      { key: 'jquery-ui-theme', value: 'smoothness'     }
    ].each do |attrs|
      Configuration.find_or_create_by(key: attrs[:key]) { |c| c.value = attrs[:value] }
    end
  end

  def test_sign_in(user)
    controller.sign_in(user, "no")
  end
end
