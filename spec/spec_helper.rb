# frozen_string_literal: true

require 'active_record'
require 'dummy/app/models/post'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  # config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    connect
  end
end

def connect
  ActiveRecord::Base.logger = Logger.new("log/debug.log")
  ActiveRecord::Base.logger.level = Logger::DEBUG
  ActiveRecord::Base.configurations = {
      'duckdb' => {
          adapter: 'duckdb',
      }
  }
  ActiveRecord::Base.establish_connection :duckdb
end
