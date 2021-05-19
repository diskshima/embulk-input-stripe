# frozen_string_literal: true

require 'stripe'
require_relative './stripe_items'

class Charges < StripeItems
  def items
    Stripe::Charge.list(limit: 100)
  end
end
