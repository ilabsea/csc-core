# frozen_string_literal: true

# When add gem at gemspec, need to require it here

## omniauth
require "devise"
require "omniauth-google-oauth2"
require "omniauth/rails_csrf_protection"
require "doorkeeper"

## Soft delete
require "paranoia"

## Valdation
require "date_validator"
require "validate_url"

## Location
require "pumi"

## Tree view
require "awesome_nested_set"

## File uploader
require "carrierwave"
require "fog/aws"

## Util
require "sidekiq"
require "httparty"
require "roo"
require "caxlsx"
require "caxlsx_rails"

## Permission
require "pundit"

## Pdf
require "wicked_pdf"

## Telegram
require "telegram/bot"

## Push notification
require "fcm"

## Elasticsearch
require "elasticsearch/model"
require "elasticsearch/rails"
require "ndjson"

## Clean space
require "strip_attributes"

module CscCore
  class Engine < ::Rails::Engine
    isolate_namespace CscCore

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot # newly added code
      g.factory_bot dir: "lib/csc_core/testing_support/factories" # newly added code
    end

    config.i18n.load_path += Dir[root.join("config", "locales", "**", "*.{rb,yml}").to_s]
    config.i18n.fallbacks = [:en]
    config.i18n.available_locales = %i[en km]
    config.i18n.default_locale = :km

    initializer "sample_engine.factories", after: "factory_bot.set_factory_paths" do
      FactoryBot.definition_file_paths << File.expand_path("../../spec/factories", __dir__) if defined?(FactoryBot)
    end
  end
end
