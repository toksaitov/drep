extend_load_paths __FILE__
require 'alterers/drep_helpers'
require 'alterers/drep_validators'

module DRep
  
  class DRepEnvironment
    attr_reader :stdin, :stdout, :stderr

    attr_reader :options

    def initialize(stdin, stdout, stderr, options)
      if valid?(stdin, stdout, stderr)
        @stdin  = stdin
        @stdout = stdout
        @stderr = stderr
      else
        raise('Not all standard streams are valid')
      end

      if valid?(options)
        @options = options
      else
        raise('Options were not specified')
      end
    end
  end

end