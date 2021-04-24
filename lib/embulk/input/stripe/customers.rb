# frozen_string_literal: true

require 'stripe'
require_relative './stripe_items'

class Customers < StripeItems
  def items
    Stripe::Customer.list
  end
end
