class Object
  def valid(item, *args, &block)
    if valid?(item, *args) and block_given?
      yield
    end
  end

  def valid?(item, *args, &block)
    result = item.nil? ? false : true

    if result and !args.nil?
      args.each do |obj|
        if obj.nil? or obj.is_a?(FalseClass)
          result = false
          break
        end
      end
    end

    if block_given?
      yield if result
    end

    return result
  end

  def first_valid(item, *args)
    result = item

    unless result and args.nil?
      args.each do |obj|
        unless obj.nil?
          result = item
          break
        end
      end
    end

    return result
  end
end