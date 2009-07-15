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
  def message(message)
    if defined? @env.stdout
      if not defined? @env.options.quiet or !@env.options.quiet
        report(@env.stdout, message)
      end
    else
      report(STDOUT, message)
    end
  end
  alias msg message

  def error(message)
    if defined? @env.stderr
      if not defined? @env.options.quiet or not @env.options.quiet
        report(@env.stderr, message)
      end
    else
      report(STDERR, message)
    end
  end
  alias err error

  def report(ios, message)
    if ios.is_a?(IO) and
         message.is_a?(String) then
      ios.puts(message)
    end
  end

  def form_str_from_list(list, separator = ', ')
    result = ''

    if list.is_a?(Array)
      list.each_index do |i|
        result += list[i].to_s()
        result += (i != list.size - 1) ? separator.to_s() : ''
      end
    end

    return result
  end

  def first_valid(item, *args)
    result = item

    if result.nil? and not args.nil?
      args.each do |obj|
        unless obj.nil?
          result = obj; break
        end
      end
    end

    return result
  end

  def first_valid_text(strs, *patterns)
    result = nil

    if strs.is_a?(Array)
      strs.each do |str|
        if str.is_a?(String)
          temp_str = str

          if not temp_str.empty? and patterns.is_a?(Array)
            temp_str.remove_nl!();  temp_str.br_to_nl!()
            temp_str.strip_tags!(); temp_str.safe_strip!()

            result = temp_str

            patterns.each do |pattern|
              if pattern.is_a?(Regexp) and
                   not pattern.match(result).to_s().size == result.size
                result = nil
                break
              end
            end
          end

        end

        break unless result.nil?
      end
    end

    if result.nil?
      result = ''
    else
      result.safe_strip!()
    end

    return result
  end
  alias first_text first_valid_text
end

class Array
  def strip_tags()
    result = []

    self.each do |str|
      if str.is_a?(String)
        result << str.strip_tags()
      end
    end

    return result
  end
end

class Hash
  def strip_tags()
    result = {}

    self.each do |key, str|
      if str.is_a?(String)
        result[key] = str.strip_tags()
      end
    end

    return result
  end
end

class String
  def remove_nl!()
    self.gsub!(/\n+/, '')
    self.gsub!(/\r+/, '')
    self.gsub!('\n', '')

    return self
  end

  def remove_nl()
    result = ''

    result = self.gsub(/\n+/, '')

    result.gsub!(/\r+/, '')
    result.gsub!('\n', '')

    return result
  end

  def safe_strip!()
    self.gsub!(/\A[\s]+|[\s]+\z/m, '')

    return self
  end

  def safe_strip()
    return self.gsub(/\A[\s]+|[\s]+\z/m, '')
  end

  def strip_tags!()
    self.gsub!(/<.*?>/, '')

    return self
  end

  def strip_tags()
    return self.gsub(/<.*?>/, '')
  end

  def br_to_nl!()
    self.replace(self.split(/<br\s*[\/]?>/).join("\n"))

    return self
  end

  def br_to_nl()
    return self.split(/<br\s*[\/]?>/).join("\n")
  end

  def lspart(arg)
    result = ''

    pos = index(arg)
    unless pos.nil?
      result = self[(pos + 1)..-1]
      unless result.nil?
        result.safe_strip!()
      end
    end

    return result
  end

  def rspart(arg)
    result = ''

    pos = index(arg)
    unless pos.nil?
      result = self[0..(pos - 1)]
      unless result.nil?
        result.safe_strip!()
      end
    end

    return result
  end

  def quotate()
    "'#{self}'"
  end

  def double_quotate()
    "\"#{self}\""
  end
end