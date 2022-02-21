# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module Duckdb
      module DatabaseStatements
        def write_query?(sql) # :nodoc:
          false
        end
      
        def execute(sql, name = nil) # :nodoc:
          sql = transform_query(sql)

          log(sql, name) do
            ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
              p sql
              @connection.query(sql)
            end
          end
        end
      end
    end
  end
end
  