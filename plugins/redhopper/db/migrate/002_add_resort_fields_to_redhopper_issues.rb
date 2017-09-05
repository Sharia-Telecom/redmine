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
# Migration to add the necessary fields to a resorted model
class AddResortFieldsToRedhopperIssues < ActiveRecord::Migration
  # Adds Resort fields, next_id and first, and indexes to a given model
  def change
    add_column :redhopper_issues, :next_id, :integer
    add_column :redhopper_issues, :first,   :boolean
    add_index :redhopper_issues, :next_id
    add_index :redhopper_issues, :first
  end
end
