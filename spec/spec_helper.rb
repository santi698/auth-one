# frozen_string_literal: true

require 'byebug'
require 'rspec'
require 'rack/test'
require 'bundler/setup'
require 'auth_one'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) { ENV['RACK_ENV'] = 'test' }
  config.after(:example) { AuthOne.reset }
end
