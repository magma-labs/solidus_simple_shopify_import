# frozen_string_literal: true

module SolidusSimpleShopifyImport
  # Imports products from shopify using the normal API endpoints, the public ones
  # without the need of hit graphql endpoint and tokens
  class Importer
    attr_reader :client

    def initialize(url)
      @client = SolidusSimpleShopifyImport::Client.new(url)
    end

    # Performs shopify import, it also yields the just created/updated product to a given block
    #
    #     importer.perform(taxons: [taxon1, taxonN],
    #                      product_property: product_property,
    #                      available_on: 1.day.ago) do |product|
    #       product.custom_code('param')
    #     end
    #
    # rubocop:disable Layout/LineLength
    def perform(taxons:, product_property:, shipping_category:, available_on: nil)
      client.each_product do |product|
        option_types = SolidusSimpleShopifyImport::Handlers::OptionTypes.new(product['options']).perform
        product_attrs = {
          name: product['title'],
          slug: product['handle'],
          price: product['variants'].first['price'],
          shipping_category_id: shipping_category.id,
          description: product['body_html'],
          available_on: available_on
        }

        record = Spree::Product.find_or_initialize_by(id: SolidusSimpleShopifyImport::Utils.sanitize_id(product['id']))
        record.assign_attributes(product_attrs)
        record.option_types = option_types
        record.save!

        record.product_properties.create(property_id: product_property.id,
                                         value: product['product_type'])

        product['variants'].each do |variant|
          option_value = option_types.first.option_values.find_by(presentation: variant['option1'])
          variant_attrs = {
            product_id: record.id,
            price: variant['price'],
            cost_price: 0
          }
          new_variant = record.variants.find_or_initialize_by(id: SolidusSimpleShopifyImport::Utils.sanitize_id(variant['id']))
          variant_attrs[:sku] = SolidusSimpleShopifyImport::Utils.build_sku(record, variant) if new_variant.new_record?
          new_variant.assign_attributes(variant_attrs)
          new_variant.save!

          SolidusSimpleShopifyImport::Utils.add_option_value(new_variant, option_value)
        end

        SolidusSimpleShopifyImport::Utils.add_taxon(record, *taxons)

        product['images'].each do |image|
          variant_image = record.master.images.find_or_initialize_by(id: SolidusSimpleShopifyImport::Utils.sanitize_id(image['id']))
          begin
            variant_image.attachment = URI.parse(image['src'])
            variant_image.save!
          rescue Net::OpenTimeout
            Rails.logger.error("Unable to download image for product #{record.slug}")
          end
        end

        yield(record) if block_given?
      end
    end
    # rubocop:enable Layout/LineLength
  end
end
