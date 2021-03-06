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

require 'optparse'
require 'ostruct'

require 'date'

extend_load_paths __FILE__
require 'alterers/drep_helpers'
require 'alterers/drep_validators'

require 'core/interfaces/drep_runnable'

require 'core/drep_environment'
require 'core/drep_executer'

module DRep

  class DRepCli
    include DRepRunnable

    DREP_EXEC_OPTIONS =
      {:provider_flag =>
         ['-p', '--provider PROVIDER[;SOURCE_1[,SOURCE_2]][;RULE_1[,RULE_2]][;OPTIONS]',
          'Provider path with sources and rules specifications.'],
       :template_flag =>
         ['-t', '--template PATH[>OUTPUT_PATH]',
          'Template in/out path. By default output will be flushed to "STDOUT"'],
       :version_flag =>
         ['-v', '--version', 'Display version information and exit.'],
       :help_flag =>
         ['-h', '--help', 'Display this help message and exit.'],
       :quiet_flag =>
         ['-q', '--quiet', 'Start in quiet mode without any CLI messages.'],
       :verbose_flag =>
         ['-V', '--verbose', 'Start in verbose mode (ignored in quiet mode).'],
       :debug_flag =>
         ['-d', '--debug', 'Start in debug mode.']}

    attr_reader :env

    attr_reader :options

    attr_reader :parser

    def initialize(stdin  = STDIN,
                   stdout = STDOUT,
                   stderr = STDERR, arguments = [])
      @options = OpenStruct.new()

      begin
        env_options = [stdin, stdout, stderr, @options]
        @env = DRepEnvironment.new(*env_options)
      rescue Exception => e
        unless @stderr.nil?
          @stderr.puts("#{UNIX_NAME}: initialization failed: #{e.message}")
        end
        exit(1)
      end

      @options.arguments = arguments.nil? ? [] : arguments
      
      @options.verbose = false
      @options.quiet   = false
      @options.debug   = false

      @options.output = @stdout

      @options.show_version = false
      @options.show_help    = false

      @options.providers = []
      @options.templates = []

      @parser = OptionParser.new()
    end

    def run()
      if options_parsed?()
        begin
          if @options.verbose
            welcome_message = "#{FULL_NAME} has started"
            msg("#{welcome_message}: #{DateTime.now}.")
          end

          perform_tasks()

          if @options.verbose
            end_message = "#{FULL_NAME} has finished all tasks"
            msg("#{end_message}: #{DateTime.now}.")
          end
        rescue Exception => e
          err("Execution failed: #{e.message}")
        end
      end
    end

    private
    def options_parsed?()
      result = true

      begin
        add_parser_arg(:version_flag) { @options.show_version = true }
        add_parser_arg(:help_flag)    { @options.show_help    = true }

        add_parser_arg(:verbose_flag) do
          @options.verbose = true if !@options.quiet
        end
        add_parser_arg(:quiet_flag) do
          @options.quiet   = true
          @options.verbose = false
        end
        add_parser_arg(:debug_flag) do
          @options.debug = true
        end
        
        add_parser_arg(:provider_flag) do |provider_def|
          add_provider(provider_def)
        end
        add_parser_arg(:template_flag) do |template_def|
          add_template(template_def)
        end

        parser.parse!(@options.arguments)

      rescue Exception => e
        err("Argument parsing failed: #{e.message}")
        result = false
      end

      return result
    end

    def add_parser_arg(arg_key, &block)
      valid @parser do
        if arg_key.is_a?(Symbol)
          arg_def = DREP_EXEC_OPTIONS[arg_key]
        else
          arg_def = nil
        end
        if valid?(arg_def)
          @parser.on(arg_def[0], arg_def[1], arg_def[2], &block)
        end
      end
    end

    def perform_tasks()
      if @options.show_version
        output_version()
      elsif @options.show_help
        output_help()
      else
        begin
          args = [@env, @options.providers, @options.templates]
          DRepExecuter.new(*args).run()
        rescue Exception => e
          err("Report population failed: #{e.message}")
        end
      end
    end

    def output_help()
      output_options()
    end

    def output_version()
      msg("#{FULL_NAME} version #{VERSION}")
      msg(COPYRIGHT)
    end

    def output_options()
      msg("Available options: \n\n")
      msg("Usage: #{UNIX_NAME} {[option] [parameter]}")

      DREP_EXEC_OPTIONS.each do |name, options|
        msg("\n\t#{options[2]}\n\t\t#{options[0]}, #{options[1]}")
      end
    end

    def add_provider(provider_def)
      if provider_def.is_a?(String)
        provider_specs = {}

        parts = provider_def.split(';')
        valid parts do
          provider_path = parts[0]
          sources_list  = parts[1]
          rules_list    = parts[2]
          options       = parts[3]

          unless provider_path.nil?
            provider_specs[:path] = provider_path
          else
            raise("Provider path is not specified")
          end

          provider_specs[:sources] = parse_args(sources_list)
          provider_specs[:rules]   = parse_args(rules_list)
          provider_specs[:options] = parse_args(options)
        end

        unless provider_specs.empty?
          @options.providers << provider_specs
        end
      end
    end

    def parse_args(args_list)
      result = []

      unless args_list.nil?
        args = args_list.split(',')

        valid args do
          args.each do |arg|
            result << arg unless arg.nil?
          end
        end
      end

      return result
    end

    def add_template(template_def)
      if template_def.is_a?(String)
        template_specs = {}

        parts = template_def.split('>')
        valid parts do
          template_path = parts[0]
          output_path   = parts[1]

          unless template_path.nil?
            template_specs[:path] = template_path
          else
            raise("Template path is not specified")
          end

          unless output_path.nil?
            template_specs[:output] = output_path
          else
            template_specs[:output] = @stdout
          end
        end

        unless template_specs.empty?
          @options.templates << template_specs
        end
      end
    end
  end
  
end