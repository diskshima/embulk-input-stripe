# frozen_string_literal: true

require 'embulk/column'

class StripeItems
  def initialize(api_key, keys)
    Stripe.api_key = api_key
    @keys = keys
  end

  def get
    result = []

    items.auto_paging_each do |sub|
      result.push(to_row(sub))
    end
    result
  end

  private

  def items
    raise 'Please override this method and return the items.'
  end

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