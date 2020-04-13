# frozen_string_literal: true

module SolidusSimpleShopifyImport
  class Utils
    class << self
      SHOPIFY_ID_DIVIDER = -8

      def build_sku(product, variant_attrs)
        "#{product.name.split.map(&:first).join}#{variant_attrs['title'].split.join}#{SecureRandom.hex(2)}".upcase # rubocop:disable Metrics/LineLength
      end

      def sanitize_id(id)
        id.to_s[SHOPIFY_ID_DIVIDER..].to_i
      end

      def add_taxon(product, *taxons)
        taxons.each do |taxon|
          product.taxons << taxon unless product.taxons.find_by(id: taxon.id)
        end
      end

      def add_option_value(variant, option_value)
        return if variant.option_values.find_by(id: option_value.id)

        variant.option_values << option_value
      end
    end
  end
end
