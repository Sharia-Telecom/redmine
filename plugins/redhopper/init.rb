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
Redmine::Plugin.register :redhopper do
  name 'Redhopper plugin'
  author 'infoPiiaf'
  description 'Kanban boards for Redmine, inspired by Jira Agile (formerly known as Greenhopper), but following its own path.'
  version '1.0.9'
  url 'https://git.framasoft.org/infopiiaf/redhopper.git'
  author_url 'http://www.infopiiaf.fr'

  project_module :kanbans do
    permission :kanbans, { :kanbans => [:index] }, :public => true
  end

  menu :project_menu, :kanbans, { :controller => 'kanbans', :action => 'index' }, :caption => 'Kanbans', :after => :activity, :param => :project_id

  settings :partial => 'settings/kanbans'
end
