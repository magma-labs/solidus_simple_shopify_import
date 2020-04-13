# frozen_string_literal: true

module SolidusSimpleShopifyImport
  module Handlers
    class OptionTypes
      attr_reader :options

      def initialize(options)
        @options = options
      end

      # Handles option types creation
      #     "options": [
      #         {
      #             "name": "Size",
      #             "position": 1,
      #             "values": [
      #                 "15 Kg.",
      #                 "20 Kg.",
      #                 "8 Kg."
      #             ]
      #         }
      def perform
        options.map do |option|
          record_option = Spree::OptionType.find_or_create_by(name: option['name'],
                                                              presentation: option['name'])
          option['values'].each do |value|
            record_option.option_values.find_or_create_by(name: value, presentation: value)
          end
          record_option
        end
      end
    end
  end
end
