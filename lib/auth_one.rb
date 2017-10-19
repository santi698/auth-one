# frozen_string_literal: true

require_relative 'auth_one/version'
require_relative 'auth_one/app'
module AuthOne
  DEFAULT_CONFIGURATION = {
    user_getter: proc { |_| nil },
    private_key: nil,
    token_iss: nil,
    token_exp_leeway: 30,
    token_exp: 3600 * 4
  }.freeze
  class << self
    Configuration = Struct.new(:user_getter, :private_key, :token_iss,
                               :token_exp_leeway, :token_exp)

    def configuration
      return @configuration unless @configuration.nil?
      reset
    end

    def configure
      yield configuration
    end

    def reset
      default_values = DEFAULT_CONFIGURATION.values_at(*Configuration.members)
      @configuration = Configuration.new(*default_values)
    end
  end
end
