# frozen_string_literal: true

require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/abstract_adapter'
require 'active_record/connection_adapters/duckdb/database_statements'
require 'active_record/connection_adapters/duckdb/schema_statements'

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
      include Duckdb::SchemaStatements

      NATIVE_DATABASE_TYPES = {
        primary_key:  "INTEGER PRIMARY KEY",
        string:       { name: "VARCHAR" },
        integer:      { name: "INTEGER" },
        float:        { name: "REAL" },
        decimal:      { name: "DECIMAL" },
        datetime:     { name: "TIMESTAMP" },
        time:         { name: "TIME" },
        date:         { name: "DATE" },
        bigint:       { name: "BIGINT" },
        binary:       { name: "BLOB" },
        boolean:      { name: "BOOLEAN" },
        uuid:         { name: "UUID" },
      }

      def native_database_types
        NATIVE_DATABASE_TYPES
      end

      def primary_keys(table_name) # :nodoc:
        raise ArgumentError unless table_name.present?

        results = query("PRAGMA table_info(#{table_name})", "SCHEMA")
        results.each_with_object([]) do |result, keys|
          _cid, name, _type, _notnull, _dflt_value, pk = result
          keys << name if pk
        end
      end

      def begin_transaction(isolation: nil, joinable: true, _lazy: true); end

      private
        def execute_and_clear(sql, name, binds, prepare: false, async: false)
          sql = transform_query(sql)
          check_if_write_query(sql)
          type_casted_binds = type_casted_binds(binds)

          log(sql, name, binds, type_casted_binds, async: async) do
            ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
              # TODO: prepare の有無でcacheするっぽい？
              if without_prepared_statement?(binds)
                @connection.query(sql)
              else
                @connection.query(sql, *type_casted_binds)
              end
            end
          end
        end

        def column_definitions(table_name) # :nodoc:
          execute("PRAGMA table_info('#{quote_table_name(table_name)}')", "SCHEMA") do |result|
            each_hash(result)
          end
        end
    end
  end
end