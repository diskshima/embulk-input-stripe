# frozen_string_literal: true

require_relative 'stripe/customers'
require_relative 'stripe/invoices'
require_relative 'stripe/subscriptions'

module Embulk
  module Input
    class Stripe < InputPlugin
      Plugin.register_input('stripe', self)

      def self.transaction(config, &control)
        resource_type = config.param('resource_type', :string)
        keys = config.param('keys', :array)

        task = {
          'api_key' => config.param('api_key', :string),
          'resource_type' => resource_type,
          'keys' => keys
        }
        columns = keys.map.with_index do |key, index|
          key_name = key['name']
          key_type = key['type'].to_sym
          Column.new(index, key_name.gsub('.', '_'), key_type)
        end

        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        puts "Input started."
        task_reports = yield(task, columns, count)
        puts "Input finished. Commit reports = #{task_reports.to_json}"

        next_config_diff = {}
        return next_config_diff

        {} # next_config_diff
      end

      # TODO
      # def self.guess(config)
      # end

      def init
        resource_type = task['resource_type']
        api_key = task['api_key']
        keys = task['keys']

        case resource_type
        when 'customers'
          @customers = Customers.new(api_key, keys)
        when 'invoices'
          @invoices = Invoices.new(api_key, keys)
        when 'subscriptions'
          @subscriptions = Subscriptions.new(api_key, keys)
        else
          raise StandardError "Resource type #{resource_type} is not supporeted."
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
