# frozen_string_literal: true

require 'stripe'
require_relative 'stripe/customers'
require_relative 'stripe/invoices'
require_relative 'stripe/subscriptions'

module Embulk
  module Input
    class Stripe < InputPlugin
      Plugin.register_input('stripe', self)

      def self.transaction(config, &control)
        ::Stripe.api_key = config.param('api_key', :string)
        resource_type = config.param('resource_type', :string)
        fields = config.param('fields', :array)

        task = {
          'resource_type' => resource_type,
          'fields' => fields
        }
        columns = fields.map.with_index do |field, index|
          field_name = field['name']
          field_type = field['type'].to_sym
          Column.new(index, field_name.gsub('.', '_'), field_type)
        end

        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        puts "Input started."
        task_reports = yield(task, columns, count)
        puts "Input finished. Commit reports = #{task_reports.to_json}"

        {} # next_config_diff
      end

      def init
        resource_type = task['resource_type']
        fields = task['fields']

        case resource_type
        when 'customers'
          @customers = Customers.new(fields)
        when 'invoices'
          @invoices = Invoices.new(fields)
        when 'subscriptions'
          @subscriptions = Subscriptions.new(fields)
        else
          raise StandardError "Resource type #{resource_type} is not supported."
        end
      end

      def run
        target_items = case task['resource_type']
                       when 'customers'
                         @customers
                       when 'invoices'
                         @invoices
                       when 'subscriptions'
                         @subscriptions
                       end

        target_items.get.each do |item|
          page_builder.add(item)
        end

        page_builder.finish

        {} # task_report
      end
    end
  end
end
