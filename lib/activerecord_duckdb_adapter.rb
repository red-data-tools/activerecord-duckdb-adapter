# frozen_string_literal: true

require "activerecord_duckdb_adapter/version"

if defined?(Rails)
  module ActiveRecord
    module ConnectionAdapters
      class DuckdbRailtie < ::Rails::Railtie
        ActiveSupport.on_load :active_record do
          require "active_record/connection_adapters/duckdb_adapter"
        end
      end
    end
  end
end