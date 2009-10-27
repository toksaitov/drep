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

require File.dirname(__FILE__) + '/drep/alterers/drep_extenders'

extend_load_paths __FILE__
require 'drep/drep_cli'

module DRep
  # Name of the system
  FULL_NAME = 'Dango Report'

  # Unix name of the system
  UNIX_NAME = 'drep'

  # System version (rational version policy)
  VERSION = '0.3.3'

  # Full name of the author
  AUTHOR = 'Toksaitov Dmitrii Alexandrovich'

  # Support e-mail
  EMAIL = "#{UNIX_NAME}.support@85.17.184.9"

  # Official website of the system
  URL = "http://85.17.184.9/#{UNIX_NAME}"

  # Copyright
  COPYRIGHT = "Copyright (C) 2009 #{AUTHOR}"

  # Main CLI Loader
  EXEC = DRepCli
end