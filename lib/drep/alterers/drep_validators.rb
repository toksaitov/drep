#    DRep - Modular Open Software Tester.
#    Copyright (C) 2009  Dmitrii Toksaitov
#
#    This file is part of DRep.
#
#    DRep is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    DRep is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with DRep. If not, see <http://www.gnu.org/licenses/>.

class Object
  def valid(item, *args, &block)
    if valid?(item, *args)
      yield block if block_given?
    end
  end

  def valid?(item, *args, &block)
    result = item.nil? ? false : true

    if result and args.is_a?(Enumerable)
      args.each do |obj|
        if obj.nil? or obj.is_a?(FalseClass)
          result = false; break
        end
      end
    end

    if block_given?
      yield block if result
    end

    return result
  end

  def valid_string(item, *args, &block)
    if valid_string?(item, *args)
      yield block if block_given?
    end
  end

  def valid_string?(item, *args, &block)
    if item.is_a?(String) and !item.strip().empty?
      result = true
    else
      result = false
    end

    if result and args.is_a?(Enumerable)
      args.each do |obj|
        if obj.nil? or
             !obj.is_a?(String) or
              obj.strip().empty? then
          result = false; break
        end
      end
    end

    if block_given?
      yield block if result
    end

    return result
  end 

  def valid_hash_args(*args, &block)
    if valid_hash_args?(args)
      yield block if block_given?
    end
  end

  def valid_hash_args?(*args, &block)
    result = args.is_a?(Array) ? true : false

    if result
      args.each do |property|

        if property.is_a?(Hash)
          property.each do |name, value|
            unless name.is_a?(Symbol) or
                    name.is_a?(String) then
              result = false
            end
          end
        else
          result = false
        end

        break unless result
      end
    end

    yield block if result and block_given?

    return result
  end 

  def matched?(str, pattern)
    result = false

    if str.is_a?(String) and pattern.is_a?(Regexp)
      if pattern.match(str).to_s().size == str.size
        result = true
      end 
    end

    return result
  end
end