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
# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:project_id/issues/kanbans', :to => 'kanbans#index', :as => 'project_kanbans'

post '/redhopper_issues', :to => 'redhopper_issues#create', :as => 'create_redhopper_issue'
delete '/redhopper_issues', :to => 'redhopper_issues#delete', :as => 'delete_redhopper_issue'
post '/redhopper_issues/move', :to => 'redhopper_issues#move', :as => 'move_redhopper_issue'
post '/redhopper_issues/block', :to => 'redhopper_issues#block', :as => 'block_redhopper_issue'
delete '/redhopper_issues/block', :to => 'redhopper_issues#unblock', :as => 'unblock_redhopper_issue'
