# frozen_string_literal: true

require 'embulk/column'

class StripeItems
  def initialize(fields)
    @fields = fields
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
    @fields.map do |field|
      # Drill down into sub items (assumes fields are delimited with '.').
      sub_fields = field['name'].split('.')
      sub_fields.reduce(sub) do |memo, sub_field|
        memo[sub_field]
      end
    end
  end
end
