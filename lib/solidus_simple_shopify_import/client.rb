# frozen_string_literal: true

require 'httparty'
module SolidusSimpleShopifyImport
  class Client
    include ::HTTParty

    attr_reader :url

    def initialize(url)
      @url = URI(url)
      self.class.base_uri [@url.scheme, @url.host].join('://')
    end

    def each_product
      page = 1
      records = products(page: page)
      while records.count.positive?
        records.each do |record|
          yield record
        end
        page += 1
        records = products(page: page)
      end
    end

    def products(page:)
      extra_params = Rack::Utils.parse_nested_query(url.query).merge(page: page)
      results = self.class.get(url.path, query: default_options.merge(extra_params))
      ActiveSupport::JSON.decode(results.body)['products']
    end

    private

    def default_options
      {
        limit: 50
      }
    end
  end
end
