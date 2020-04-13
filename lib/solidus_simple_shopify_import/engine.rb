# frozen_string_literal: true

require 'spree/core'
require 'solidus_simple_shopify_import'

module SolidusSimpleShopifyImport
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions::Decorators

    isolate_namespace ::Spree

    engine_name 'solidus_simple_shopify_import'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
