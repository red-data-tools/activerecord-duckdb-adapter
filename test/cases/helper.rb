# frozen_string_literal: true

require "config"

require "stringio"

require "active_record"
require "active_record/fixtures"
require "active_support/testing/autorun"
require "active_support/logger"

def connect
  ActiveRecord::Base.logger = ActiveSupport::Logger.new("log/debug.log", 0, 100 * 1024 * 1024)
  ActiveRecord::Base.configurations = {
    'duckdb' => { adapter: 'duckdb' }
  }
  ActiveRecord::Base.establish_connection :duckdb
end

connect

def load_schema
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  load SCHEMA_ROOT + "/schema.rb"

  ActiveRecord::FixtureSet.reset_cache
ensure
  $stdout = original_stdout
end

load_schema

class TestCase < ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = ::FIXTURE_ROOT
end
