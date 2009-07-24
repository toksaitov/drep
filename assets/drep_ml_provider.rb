require 'open-uri'
require 'nokogiri'

module Task
  NAME        = 'DRep .*ML Parser'
  VERSION     = '0.0.2'
  DESCRIPTION = 'Simple HTML/XML values extractor based on Nokogiri and Open-URI libs.'

  AUTHOR      = 'Toksaitov Dmitriy Alexandrovich'

  def self.run(env, specs)
    result = {}

    raise "Invalid environment" if env.nil?

    sources, rules_list = specs[:sources], specs[:rules]

    raise "Invalid sources list" unless sources.is_a?(Enumerable)
    raise "Invalid rules list"   unless rules_list.is_a?(Enumerable)

    $KCODE = 'U'

    sources.each do |source|
      doc = load_doc(source, env)
      valid doc do
        rules_list.each do |rules|
          temp_res = process_rules_sources(doc, rules, env)
          result.update(temp_res) unless temp_res.nil?
        end
      end
    end

    return result
  end

  private
  def self.load_doc(source, env)
    result = nil

    begin
      env.message("Processing source: #{source}")
      open(source) do |html|
        result = Nokogiri::HTML(html.read, nil, html.charset)
      end
    rescue Exception => e
      env.error("Failed to load the source: #{e.message}")
    end

    return result
  end

  def self.process_rules_sources(doc, rules, env)
    result = nil

    begin
      env.message("Loading rules source: #{rules}")
      require File.expand_path(rules)

      if defined? Rules.get()
        env.message("Processing rules source: #{rules}")
        result = process_rules(doc, Rules.get(), env)
      else
        env.error("Rules source were not defined in: #{rules}")
      end
    rescue Exception => e
      env.error("Failed to process rules source: #{e.message}")
    end

    return result
  end

  def self.process_rules(doc, rules, env)
    result = {}

    raise "Rules are invalid" unless rules.is_a?(Hash)

    rules.each do |var, rule|
      temp_res = []

      xpath, str_proc = nil
      xpath, str_proc = rule[0], rule[1] if rule.is_a?(Array)

      if valid?(xpath, doc)
        search_res = doc.xpath(xpath)

        if str_proc.is_a?(Proc)
          search_res.each_with_index do |elem, index|
            content = elem.content().to_s()
            valid str_proc.call(content, index) do
              temp_res << content
            end
          end
        else
          search_res.each do |elem|
            temp_res << elem.content().to_s()
          end
        end
      else
        env.error("Rule #{i} has invalid format or data")
      end

      if valid?(var, temp_res)
        env.message("Extracted #{var}: #{temp_res.inspect()}") if $DEBUG
        result[var] = temp_res
      else
        env.error("Failed to extract #{var.nil? ? 'a variable' : var}")
      end
    end

    env.message("Number of extracted vars: #{result.size}")

    return result
  end
end