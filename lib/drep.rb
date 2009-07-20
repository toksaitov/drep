require File.dirname(__FILE__) + '/drep/alterers/drep_extenders'

extend_load_paths __FILE__
require 'drep/drep_cli'

module DRep
  # Name of the system
  FULL_NAME = 'Dango Report'

  # Unix name of the system
  UNIX_NAME = 'drep'

  # System version (rational versioning policy)
  VERSION = '0.0.1'

  # Full name of the author
  AUTHOR = 'Toksaitov Dmitriy Alexandrovich'

  # Support e-mail
  EMAIL = "#{UNIX_NAME}.support@85.17.184.9"

  # Offical website of the system
  URL = "http://85.17.184.9/#{UNIX_NAME}"

  # Copyright
  COPYRIGHT = "Copyright (C) 2009 #{AUTHOR}"

  # Main CLI Loader
  EXEC = DRepCli
end