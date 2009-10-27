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

require 'rubygems'

gem 'hoe', '>= 2.1.0'
require 'hoe'

DREP_ROOT = File.expand_path(File.dirname(__FILE__))
require File.expand_path(File.join(DREP_ROOT, 'lib', 'drep'))

Hoe.plugin :newgem

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec DRep::UNIX_NAME do
  self.developer DRep::AUTHOR, DRep::EMAIL
  self.post_install_message = File.read('PostInstall.txt')

  self.readme_file = 'README.txt'

  self.extra_deps     = [['nokogiri', '>= 1.3.2']]
  self.extra_dev_deps = [['newgem', '>= 1.5.1']]
end

require 'newgem/tasks'

Dir[File.join(DREP_ROOT, 'tasks', '**', '*.{rb,task,tasks}')].each do |file| require(file) end