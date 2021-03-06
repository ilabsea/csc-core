# frozen_string_literal: true

require_relative "lib/csc_core/version"

Gem::Specification.new do |spec|
  spec.name        = "csc_core"
  spec.version     = CscCore::VERSION
  spec.authors     = [""]
  spec.email       = [""]
  spec.homepage    = ""
  spec.summary     = "Summary of CscCore."
  spec.description = "Description of CscCore."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.5"

  # Oauth
  spec.add_dependency "devise", "~> 4.8.1"
  spec.add_dependency "doorkeeper", "~> 5.5.2"
  spec.add_dependency "omniauth-google-oauth2", "~> 1.0.0"
  spec.add_dependency "omniauth-rails_csrf_protection", "~> 1.0.0"

  # Soft delete
  spec.add_dependency "paranoia", "~> 2.4.3"

  # Validation
  spec.add_dependency "date_validator", "~> 0.10.0"
  spec.add_dependency "validate_url", "~> 1.0.13"

  # Location
  spec.add_dependency "pumi", "~> 0.10.0"

  # Nested category
  spec.add_dependency "awesome_nested_set", "~> 3.2.1"

  # File upload
  spec.add_dependency "carrierwave", "~> 2.1"
  spec.add_dependency "fog-aws", "~> 3.8.0"

  # Telegram
  spec.add_dependency "telegram-bot", "~> 0.15.3"

  # Background process
  spec.add_dependency "sidekiq", "~> 6.4.0"

  # Send request
  spec.add_dependency "httparty", "~> 0.19.0"

  # Excel read, write
  spec.add_dependency "caxlsx", "~> 3.1.1"
  spec.add_dependency "caxlsx_rails", "~> 0.6.2"
  spec.add_dependency "roo", "~> 2.8.3"

  # Permission
  spec.add_dependency "pundit", "~> 2.1.0"

  # Pdf generate
  spec.add_dependency "wicked_pdf", "~> 2.1.0"
  spec.add_dependency "wkhtmltopdf-binary", "~> 0.12.6.5"

  # Clean space
  spec.add_dependency "strip_attributes", "~> 1.11.0"

  # Mobile push notification
  spec.add_dependency "fcm", "~> 1.0.6"

  # Elasticsearch
  spec.add_dependency "elasticsearch-model", "~> 7.2.0"
  spec.add_dependency "elasticsearch-rails", "~> 7.2.0"
  spec.add_dependency "ndjson", "~> 1.0.0"

  # Spec
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2.0"
  spec.add_development_dependency "ffaker", "~> 2.17.0"
  spec.add_development_dependency "rspec-rails", "~> 5.0.0"
  spec.add_development_dependency "rspec-sidekiq", "~> 3.1.0"
  spec.add_development_dependency "shoulda-matchers", "~> 4.0"

  spec.add_development_dependency "annotate", "~> 3.2.0"
  spec.add_development_dependency "rubocop-performance", "~> 1.13.2"
  spec.add_development_dependency "rubocop-rails", "~> 2.13.2"

  spec.add_development_dependency "byebug"
end
