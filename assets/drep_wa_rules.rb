module DRep

  class Rules
    NAME        = 'DRep WA Rules'
    VERSION     = '0.0.1'
    VALID_DATE  = '23.07.2009'
    DESCRIPTION = "Rules for WA's chinese pornographic animation section."

    AUTHOR      = 'Toksaitov Dmitriy Alexandrovich'

    WA_RULES =
    {
      :ru_title =>
        ["//meta[@name='description']/@content"],
      :alt_title =>
        [
          "//a[@class='estimation']/parent::font/parent::td/text()",
          lambda { |str, i| res = str.strip(); res =~ /[a-z0-9]/i ? res : nil }
        ],
      :year =>
        ["//a[@class='estimation']/parent::font/parent::td/a"],

      :all_alt_titles =>
        [
          "//a[@class='estimation']/parent::font/parent::td/text()",
          lambda { |str, i| valid_string?(str) ? str.strip() : nil }
        ],

      :country =>
        [
          "//a[@class='estimation' and contains(@href, 'country')]",
          lambda { |str, i| valid_string?(str) ? str.strip() : nil }
        ],
      :genres =>
        [
          "//a[@class='estimation' and contains(@href, 'genre')]",
          lambda { |str, i| valid_string?(str) ? str.strip() : nil }
        ],
      :type =>
        [
          "//a[@class='estimation']/parent::font/b[text()='Òèï']/following-sibling::text()",
          lambda { |str, i| i == 0 ? str.strip() : nil }
        ],

      :brief_content =>
        ["//p[@class='review']"]
    }

    attr_reader :env

    def initialize(environment)
      unless environment.nil?
        @env = environment
      else
        raise(ArgumentError, "Invalid environment", caller())
      end
    end

    def get()
      msg("Rules are predefined. Number of rules: #{WA_RULES.size}")

      return WA_RULES
    end
  end

end