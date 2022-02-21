# frozen_string_literal: true

require 'active_record'
require 'active_record/base'
# require 'active_support/dependencies/autoload'
# require 'active_support/callbacks'
# require 'active_support/core_ext/string'
require 'active_record/connection_adapters/abstract_adapter'
require 'active_record/connection_adapters/duckdb/database_statements'
# require 'active_support/core_ext/kernel'

begin
  require 'duckdb'
rescue LoadError => e
  raise e
end

module ActiveRecord
  module ConnectionHandling # :nodoc:
    def duckdb_connection(config)
      config = config.symbolize_keys
      connection = ::DuckDB::Database.open.connect
      ConnectionAdapters::DuckdbAdapter.new(connection, logger, config)
    end
  end

  module ConnectionAdapters # :nodoc:
    class DuckdbAdapter < AbstractAdapter
      ADAPTER_NAME = "DuckDB"

      include Duckdb::DatabaseStatements

      NATIVE_DATABASE_TYPES = {
        primary_key:  "integer PRIMARY KEY AUTOINCREMENT NOT NULL",
        string:       { name: "varchar" },
        text:         { name: "text" },
        integer:      { name: "integer" },
        float:        { name: "float" },
        decimal:      { name: "decimal" },
        datetime:     { name: "datetime" },
        time:         { name: "time" },
        date:         { name: "date" },
        binary:       { name: "blob" },
        boolean:      { name: "boolean" },
        json:         { name: "json" },
      }
    end
  end  
end