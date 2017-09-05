# "Custom values per project" redmine plugin
#
# Copyright (C) 2014   Francisco Javier Pérez Ferrer <contacto@javiferrer.es>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

RedmineApp::Application.routes.draw do
  match '/projects/:id/manage_possible_values/:custom_field_id', :to => 'possible_value_projects#manage', :as => 'manage_possible_values', :via => [:get, :post]
  match '/projects/:id/destroy_possible_values/:custom_field_id', :to => 'possible_value_projects#destroy', :as => 'delete_possible_values', :via => :delete
end