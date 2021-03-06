# frozen_string_literal: true

require 'stripe'
require_relative './stripe_items'

class Subscriptions < StripeItems
  def items
    Stripe::Subscription.list(status: 'all')
  end
end
