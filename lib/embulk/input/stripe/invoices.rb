# frozen_string_literal: true

require 'stripe'
require_relative './stripe_items'

class Invoices < StripeItems
  def items
    Stripe::Invoice.list
  end
end
