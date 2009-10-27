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