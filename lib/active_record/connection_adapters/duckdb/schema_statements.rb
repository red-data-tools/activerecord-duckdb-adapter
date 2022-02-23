# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module Duckdb
      module SchemaStatements # :nodoc:
        private
          def new_column_from_field(table_name, field)
            _cid, name, type, notnull, _dflt_value, _pk = field

            Column.new(
              name,
              nil, # default value
              fetch_type_metadata(type),
              !notnull,
              nil, # default function
            )
          end

          def data_source_sql(name = nil, type: nil)
            scope = quoted_scope(name, type: type)

            sql = +"SELECT table_name FROM information_schema.tables"
            sql << " WHERE table_schema = '#{scope[:schema]}'"
            if scope[:type] || scope[:name]
              conditions = []
              conditions << "table_type = '#{scope[:type]}'" if scope[:type]
              conditions << "table_name = '#{scope[:name]}'" if scope[:name]
              sql << " WHERE #{conditions.join(" AND ")}"
            end
            sql
          end

          def quoted_scope(name = nil, type: nil)
            schema, name = extract_schema_qualified_name(name)
            scope = {}
            scope[:schema] = schema ? quote(schema) : "main"
            scope[:name] = quote(name) if name
            scope[:type] = quote(type) if type
            scope
          end

          def extract_schema_qualified_name(string)
            schema, name = string.to_s.scan(/[^`.\s]+|`[^`]*`/)
            schema, name = nil, schema unless name
            [schema, name]
          end
      end
    end
  end
end
  