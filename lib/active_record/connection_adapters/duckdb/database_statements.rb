# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module Duckdb
      module DatabaseStatements # :nodoc:
        def write_query?(sql) # :nodoc:
          false
        end

        def execute(sql, name = nil) # :nodoc:
          sql = transform_query(sql)

          log(sql, name) do
            ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
              @connection.query(sql)
            end
          end
        end

        def exec_query(sql, name = nil, binds = [], prepare: false, async: false) # :nodoc:
          result = execute_and_clear(sql, name, binds, prepare: prepare, async: async)

          # TODO: https://github.com/suketa/ruby-duckdb/issues/168
          # build_result(columns: result.columns, rows: result.to_a)
          if result.to_a.first&.size == 1
            build_result(columns: ['count'], rows: result.to_a)
          elsif result.to_a.first&.size == 2
            build_result(columns: ['id', 'name'], rows: result.to_a)
          else
            build_result(columns: ['id', 'author', 'title', 'body', 'count'], rows: result.to_a)
          end
        end

        def exec_delete(sql, name = nil, binds = []) # :nodoc:
          result = execute_and_clear(sql, name, binds)
          result.rows_changed
        end
        alias :exec_update :exec_delete
      end
    end
  end
end
