module ColumnUtils
  def generate_columns(items)
    traversed =
      if items.is_a?(Hash)
        traverse_hash(items)
      elsif items.is_a?(Array)
        traverse_array(items)
      else
        raise StandardError, 'Passed in object must be a Hash or an Array.'
      end

    traversed.flatten
  end

  private

  def traverse_array(items, current_key = '')
    items.map do |item|
      if item.is_a?(Hash)
        traverse_hash(item, current_key)
      elsif item.is_a?(Array)
        traverse_array(item, current_key)
      else
        current_key != '' ? "#{current_key}_#{item}" : item
      end
    end
  end

  def traverse_hash(items, current_key = '')
    items.map do |key, item|
      new_key = current_key != '' ? "#{current_key}_#{key}" : key

      if item.is_a?(Hash)
        traverse_hash(item, new_key)
      elsif item.is_a?(Array)
        traverse_array(item, new_key)
      else
        "#{new_key}_#{item}"
      end
    end
  end
end
