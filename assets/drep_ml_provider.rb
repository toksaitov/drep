require 'open-uri'
require 'nokogiri'

module DRep
  
  class Task
    NAME        = 'DRep .*ML Parser'
    VERSION     = '0.0.2'
    DESCRIPTION = 'Simple HTML/XML values extractor based on Nokogiri and Open-URI libs.'

    AUTHOR      = 'Toksaitov Dmitriy Alexandrovich'

    $KCODE = 'U'

    attr_reader :env

    def initialize(environment)
      unless environment.nil?
        @env = environment
      else
        raise(ArgumentError, "Invalid environment", caller())
      end
    end

    def run(specs)
      result = {}

      sources, rules_list = specs[:sources], specs[:rules]

      raise "Invalid sources list" unless sources.is_a?(Enumerable)
      raise "Invalid rules list"   unless rules_list.is_a?(Enumerable)

      sources.each do |source|
        doc = load_doc(source)
        valid doc do
          rules_list.each do |rules|
            temp_res = process_rules_sources(doc, rules)
            result.update(temp_res) unless temp_res.nil?
          end
        end
      end

      return result
    end

    private
    def load_doc(source)
      result = nil

      begin
        msg("Processing source: #{source}")
        open(source) do |html|
          result = Nokogiri::HTML(html.read, nil, html.charset)
        end
      rescue Exception => e
        err("Failed to load the source: #{e.message}")
      end

      return result
    end

    def process_rules_sources(mldoc, rules)
      result = nil

      begin
        msg("Loading rules source: #{rules}")
        require File.expand_path(rules)

        if defined? Rules.new()
          msg("Processing rules source: #{rules}")
          result = process_rules(mldoc, Rules.new(@env).get())
        else
          err("Rules source were not defined in: #{rules}")
        end
      rescue Exception => e
        err("Failed to process rules source: #{e.message}")
      end

      return result
    end

    def process_rules(mldoc, rules)
      result = {}

      raise "Rules are invalid" unless rules.is_a?(Hash)

      rules.each do |var, rule|
        temp_res = extract_var(mldoc, rule)

        if valid?(var, temp_res) and !temp_res.empty?
          msg("Extracted #{var}: #{temp_res.inspect()}") if @env.options.debug
          result[var] = temp_res
        else
          err("Failed to extract #{var.nil? ? 'a variable' : "variable: #{var}"}")
        end
      end

      msg("Number of extracted vars: #{result.size}")

      return result
    end

    def extract_var(mldoc, rule)
      result = []

      xpath, str_proc = nil
      xpath, str_proc = rule[0], rule[1] if rule.is_a?(Array)

      if valid?(xpath, mldoc)
        search_res = mldoc.xpath(xpath)
        if str_proc.is_a?(Proc)
          search_res.each_with_index do |elem, i|
            content = elem.to_html().gsub(/<.*?>/,'')
            valid str_proc.call(content, i) do
              result << content
            end
          end
        else
          search_res.each do |elem|
            result << elem.to_html().gsub(/<.*?>/,'')
          end
        end
      end

      return result
    end
  end

end
