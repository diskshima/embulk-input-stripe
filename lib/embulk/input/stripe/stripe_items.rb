# frozen_string_literal: true

require 'embulk/column'

class StripeItems
  BEFORE_BRACKET_REGEX = Regexp.compile(/^([^\[]+)/)
  INDEX_REGEX = Regexp.compile(/\[([0-9]+)\]/)

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
        name_match = BEFORE_BRACKET_REGEX.match(sub_field)
        before_bracket = name_match[1]

        child = memo[before_bracket]

        index_match = INDEX_REGEX.match(sub_field)

        if index_match
          index = index_match[1]
          child[index.to_i]
        else
          child
        end
      end
    end
  end
end
