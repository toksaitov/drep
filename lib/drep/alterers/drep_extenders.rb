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

def extend_load_paths(src_file_name)
  unless src_file_name.nil?
    req_dir_name     = File.dirname(src_file_name)
    req_abs_dir_name = File.expand_path(req_dir_name)

    unless $LOAD_PATH.include?(req_dir_name) or
             $LOAD_PATH.include?(req_abs_dir_name) then
      $LOAD_PATH.unshift(req_dir_name)
    end
  end
end