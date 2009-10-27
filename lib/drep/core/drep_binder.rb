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

extend_load_paths __FILE__
require 'alterers/drep_helpers'
require 'alterers/drep_validators'

module DRep

  class DRepBinder
    attr_reader :env

    attr_reader :__vars_data__

    def initialize(environment, vars_data)
      unless environment.nil?
        @env = environment
      else
        raise(ArgumentError, "Invalid environment", caller())
      end

      @__vars_data__ = vars_data
      inject_vars()
    end

    def get_binding()
      return binding()
    end

    private
    def inject_vars()
      if @__vars_data__.is_a?(Array)

        @__vars_data__.each do |data_blob|
          if data_blob.is_a?(Hash)

            data_blob.each do |name, value|
              var_str_name = "@#{name.to_s()}"
              unless var_str_name.nil?
                if instance_variable_defined?(var_str_name)
                  err("Variables overlapping occurred in #{var_str_name}")
                end
                instance_variable_set(var_str_name.intern(), value)
              else
                err('Variable name is in incorrect format')
              end
            end

          else
            err('Invalid inner data blob format')
          end
        end

      else
        err('Invalid variables data format')
      end
    end

    def method_missing(mid, *args)
      result = ''

      if args.size == 0
        if @__vars_data__.is_a?(Array)
          temp_data = nil
          @__vars_data__.each do |data_blob|
            if data_blob.is_a?(Hash)
              var_value = data_blob[mid]
              temp_data = var_value unless var_value.nil?
            else
              err('Invalid inner data blob format')
            end
          end
          valid temp_data do
            result = temp_data
          end
        else
          err('Invalid variables data format')
        end
      else
        err("Value binding failed. Invalid method call: #{mid}")
      end

      return result
    end
  end
  
end