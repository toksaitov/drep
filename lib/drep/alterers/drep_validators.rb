class Object
  def valid(item, *args, &block)
    if valid?(item, *args)
      yield if block_given?
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

  def valid_enum(item, *smth, &block)
    if valid_enum?(item, *smth)
      yield if block_given?
    end
  end

  def valid_enum?(enum, *smth, &block)
    result = enum.is_a?(Enumerable) ? true : false

    if result
      if smth.is_a?(Array)
        smth.each do |property|
          
          if property.is_a?(Hash)
            property.each do |name, value|

              if name.is_a?(Symbol) or name.is_a?(String)
                if value.is_a?(Array) and value.size == 2
                  if enum.send(name, value[0]) != value[1]
                    result = false
                    break
                  end
                else
                  if enum.send(name) != value
                    result = false
                    break
                  end
                end
              end

            end
          end

          break unless result
        end
      end

      if result
        enum.each do |obj|
          if obj.nil?
            result = false
            break
          end
        end
      end
    end

    if block_given?
      yield if result
    end

    return result
  end
end