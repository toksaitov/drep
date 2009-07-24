extend_load_paths __FILE__
require 'alterers/drep_helpers'
require 'alterers/drep_validators'

module DRep

  class DRepBinder
    $KCODE = 'U'

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
              if var_str_name
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
  end
  
end