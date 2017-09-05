#
# Redhopper - Kanban boards for Redmine, inspired by Jira Agile (formerly known as
# Greenhopper), but following its own path.
# Copyright (C) 2015-2017 infoPiiaf <contact@infopiiaf.fr>
#
# This file is part of Redhopper.
#
# Redhopper is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Redhopper is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Redhopper.  If not, see <http://www.gnu.org/licenses/>.
#
namespace :redhopper do
  desc "Inserts copyright and licence headers within code files"
  task :headers do
    require 'rubygems'
    require 'copyright_header'

    args = {
      license: 'AGPL3',
      copyright_software: 'Redhopper',
      copyright_software_description: "Kanban boards for Redmine, inspired by Jira Agile (formerly known as Greenhopper), but following its own path.",
      copyright_holders: ['infoPiiaf <contact@infopiiaf.fr>'],
      copyright_years: ['2015'],
      add_path: './plugins/redhopper',
      output_dir: './',
      guess_extension: true
    }

    command_line = CopyrightHeader::CommandLine.new( args )
    command_line.execute
  end
end
