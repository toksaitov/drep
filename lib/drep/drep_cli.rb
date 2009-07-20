require 'optparse'
require 'ostruct'

require 'date'

require 'open-uri'
require 'hpricot'

extend_load_paths __FILE__
require 'alterers/drep_validators'

module DRep

  class DRepCli
    DREP_EXEC_OPTIONS =
      {:version_flag =>
         ['-v', '--version', 'Display version information and exit.'],
       :help_flag =>
         ['-h', '--help', 'Display this help message and exit.'],
       :quiet_flag =>
         ['-q', '--quiet', 'Start in quiet mode without any CLI messages.'],
       :verbose_flag =>
         ['-V', '--verbose', 'Start in verbose mode (ignored in quiet mode).'],
       :new_task_flag =>
         ['-t', '--task [source:connector, rules:file, template:file]', 'Add new report task.']}

    attr_reader :stdin, :stdout, :arguments

    attr_reader :options

    attr_reader :parser

    def initialize(stdin = STDIN, stdout = STDOUT, arguments = [])
      unless stdin.nil? and stdout.nil?
        @stdin  = stdin
        @stdout = stdout
      else
        raise("Invalid standard input or output.")
      end

      unless arguments.nil?
        @arguments = arguments
      else
        @arguments = []
      end

      @options = OpenStruct.new()

      @options.arguments = arguments

      @options.verbose = false
      @options.quiet   = false

      @options.tasks = OpenStruct.new()

      @options.tasks.show_version = false
      @options.tasks.show_help    = false

      @options.tasks.generate_reports = []

      @parser = OptionParser.new()
    end

    def execute()
      if options_parsed?()
        begin
          welcome_message = "#{FULL_NAME} has started"
          @stdout.puts("#{welcome_message}: #{DateTime.now}.") if @options.verbose

          perform_tasks()

          end_message = "#{FULL_NAME} has finished all tasks"
          @stdout.puts("#{end_message}: #{DateTime.now}.") if @options.verbose
        rescue Exception => e
          @stdout.puts("Execution failed: #{e.message}")
        end
      end
    end

    private
    def options_parsed?()
      result = true

      begin
        add_parser_arg(:version_flag)  { @tasks.show_version = true }
        add_parser_arg(:help_flag)     { @tasks.show_help    = true }

        add_parser_arg(:verbose_flag) do
          @options.verbose = true if !@options.quiet
        end
        add_parser_arg(:quiet_flag) do
          @options.quiet = true
          @options.verbose = false
        end

        add_parser_arg(:new_task_flag) do |task|
          add_task(task)
        end

        parser.parse!(@arguments)
      rescue Exception => e
        unless @options.quiet
          @stdout.puts("Argument parsing failed, #{e.message}")
        end
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
      if @options.tasks.show_version
        output_version(); exit(0)
      end
      if @options.tasks.show_help
        output_help(); exit(0)
      end
    end

    def output_help()
      @stdout.puts("Available options: \n\n")
      output_options()
    end

    def output_version()
      @stdout.puts("Usage: #{UNIX_NAME} {[option] [parameter]}")
      @stdout.puts(COPYRIGHT)
    end

    def output_options()
      @stdout.puts(@env.lang.exec_options_title) # ToDo lang

      DREP_EXEC_OPTIONS.each do |name, options|
        @stdout.puts("\n\t#{options[2]}\n\t\t#{options[0]}, #{options[1]}")
      end
    end

    def add_task(task_defenition)
      puts(task_defenition)
    end
  end

end