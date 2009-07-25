require 'erb'

require 'date'

extend_load_paths __FILE__
require 'alterers/drep_helpers'
require 'alterers/drep_validators'

require 'interfaces/drep_runnable'

require 'drep_binder'

module DRep

  class DRepExecuter
    include DRepRunnable

    attr_reader :env

    attr_reader :providers
    attr_reader :templates

    def initialize(environment, providers, templates)
      unless environment.nil?
        @env = environment
      else
        raise(ArgumentError, "Invalid environment", caller())
      end

      @providers = providers
      @templates = templates
    end

    def run()
      perform_tasks()
    end

    private
    def perform_tasks()
      vars = []

      if valid?(@providers)
        msg("Provider processing is about to start\n" +
            "Number of providers to process: #{@providers.size}")

        @providers.each do |provider|
          extracted_vars = process_provider(provider)

          unless extracted_vars.nil? or extracted_vars.empty?
            vars << extracted_vars
          end
        end
      else
        err("Providers were not specified")
      end

      if valid?(@templates) and !vars.empty?
        msg("Template processing is about to start\n" +
            "Number of templates to process: #{@templates.size}")

        @templates.each do |template|
          process_template(template, vars)
        end
      else
        err("Templates were not specified")
      end
    end

    def process_provider(provider_def)
      result = {}

      extracted_vars = nil

      provider = provider_def[:path]
      if valid?(provider)
        begin
          msg("Processing provider: #{provider}")

          require File.expand_path(provider)
          if defined? Task.new()
            extracted_vars = Task.new(@env).run(provider_def)
          end
        rescue Exception => e
          err("Provider execution failed: #{e.message}")
        end

        if valid?(extracted_vars)
          result = extracted_vars
        else
          err("Failed to get data from provider: #{provider}")
        end
      else
        err("Invalid provider defenition")
      end

      return result
    end

    def process_template(template_def, vars)
      if template_def.is_a?(Hash)
        template_path = template_def[:path]
        output        = template_def[:output]

        if valid?(template_path)
          begin
            msg("Processing template: #{template_path}")
            template_content = get_content(template_path)
            valid template_content do
              report = generate_report(template_content, vars)
              output_ios = get_ios(output)

              valid report, output_ios do
                output_ios.write(report)
              end
            end
          rescue Exception => e
            err("Template population failed: #{e.message}")
          end
        else
          err("Invalid template path")
        end
      else
        err("Template defenition has invalid format")
      end
    end

    def generate_report(template_content, vars)
      result = nil

      begin
        msg("Forming variables binding")
        data_binding = DRepBinder.new(@env, vars)

        msg("Generating result")
        erb_template = ERB.new(template_content, nil, '%<>')
        result = erb_template.result(data_binding.get_binding())
      rescue Exception => e
        err("Report generation failed: #{e.message}")
      end

      return result
    end

    def get_content(path)
      result = nil

      begin
        msg("Getting content: #{path}")
        open(path) do |content|
          result = content.read
        end
      rescue Exception => e
        err("Failed to get content: #{e.message}")
      end

      return result
    end
    
    def get_ios(output)
      result = nil

      begin
        msg("Checking type of output")
        if output.is_a?(String)
          msg("Output destination: #{output}")
          result = File.open(output, 'w+')
        elsif output.is_a?(IO)
          msg("Output provider: #{output.class}")
          result = output
        else
          err("Result output object is invalid")
        end
      rescue Exception => e
        err("Failed to check type of output: #{e.message}")
      end

      return result
    end
  end

end