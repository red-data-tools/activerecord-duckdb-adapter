# frozen_string_literal: true

require "active_support/logger"

module ARTest
  def self.connect
    ActiveRecord::Base.logger = ActiveSupport::Logger.new("log/debug.log", 0, 100 * 1024 * 1024)
    ActiveRecord::Base.configurations = {
      'duckdb' => { adapter: 'duckdb' }
    }
    ActiveRecord::Base.establish_connection :duckdb
  end
end

