module DRep

  class Rules
    NAME        = 'DRep WA Rules'
    PROVIDER    = 'drep_ml_provider'

    VERSION     = '0.0.1'
    VALID_DATE  = '23.07.2009'
    DESCRIPTION = "Rules for WA section."
    
    WA_RULES =
    {
      :ru_title =>
        [
          "//meta[@name='description']/@content",
          lambda { |strs| /content="(.*)"/.match(first_text(strs))[1] }
        ],
      :alt_title =>
        [
          "//a[@class='estimation']/parent::font/parent::td/text()",
          lambda { |strs| first_text(strs, /[a-z0-9\(\)\[\]{}\s:]+/i) }
        ],
      :year =>
        [
          "//a[@class='estimation']/parent::font/parent::td/a",
          lambda { |strs| first_text(strs) }
         ],

      :all_alt_titles =>
        [
          "//a[@class='estimation']/parent::font/parent::td/text()",
          lambda { |strs| strs.strip_tags() }
        ],

      :country =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Производство:.*/).lspart(':') }
        ],
      :genres =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Жанр:.*/).lspart(':') }
        ],
      :type =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Тип:.*/).lspart(':') }
        ],
      :release_date =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Премьера:.*/).lspart(':') }
        ],
      :air_period =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Выпуск:.*/).lspart(':') }
        ],
      :air_time =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Выпуск в.*/).lspart('в') }
        ],
      :director =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Режиссёр:.*/).lspart(':') }
        ],
      :screenwriter =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Сценарий:.*/).lspart(':') }
        ],
      :original_work_author=>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Автор оригинала:.*/).lspart(':') }
        ],
      :original_work =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Снято по.*/).rspart(':') }
        ],
      :original_work_name =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Снято по.*/).lspart(':') }
        ],

      :raiting_avg_score =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Средний балл:.*/).lspart(':') }
        ],

      :raiting_pos =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(first_text(strs).split("\n"), /Место в рейтинге:.*/).lspart(':') }
        ],
      :votes_num =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs|
            first_text(first_text(strs).split("\n"), /Проголосовало:.*/).lspart(':').gsub(/\[.+\]/, '')
          }
        ],

      :brief_content =>
        [
          "//p[@class='review']",
          lambda { |strs| first_text(strs) }
        ],

      :logical_view_order =>
        [
          "//table[descendant::*[@background='img/pixel.gif']]/following-sibling::table[1]",
          lambda { |strs| first_text(strs, /(\s*#\d+[^#]*)+/).gsub(/(#\d+)/, "\n\\1").safe_strip() }
        ],
      :episodes =>
        [
          "//table[descendant::*[@background='img/pixel.gif']]/following-sibling::table[1]",
          lambda { |strs| first_text(strs, /(\d+[\d\s\[\]\(\)]*\.).*/m) }
        ],

      :all_general_info =>
        [
          "//a[@class='estimation']/parent::font",
          lambda { |strs| first_text(strs).sub('Выпуск в', 'Выпуск в:') }
        ]
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