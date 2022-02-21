# frozen_string_literal: true

require_relative "lib/activerecord_duckdb_adapter/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-duckdb-adapter"
  spec.version       = ActiveRecordDuckdbAdapter::VERSION
  spec.authors       = ["okadakk"]
  spec.email         = ["k.suke.jp1990@gmail.com"]

  spec.summary       = "https://github.com"
  spec.description   = "https://github.com"
  spec.homepage      = "https://github.com"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com"
  spec.metadata["changelog_uri"] = "https://github.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency('activerecord')
  spec.add_dependency('duckdb')
end
