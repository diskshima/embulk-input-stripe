# frozen_string_literal: true

require 'embulk/column'
require 'stripe'

class Subscriptions
  def initialize(api_key, keys)
    Stripe.api_key = api_key
    @keys = keys
  end

  def get
    subs = Stripe::Subscription.list(status: 'all')

    result = []

    subs.auto_paging_each do |sub|
      result.push(to_row(sub))
    end

    result
  end

  private

  def to_row(sub)
    @keys.map do |key|
      # Drill down into sub items (assumes keys are delimited with '.').
      sub_keys = key['name'].split('.')
      sub_keys.reduce(sub) do |memo, sub_key|
        memo[sub_key]
      end
    end
  end
end
