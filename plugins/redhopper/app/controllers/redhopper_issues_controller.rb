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
class RedhopperIssuesController < ApplicationController
  unloadable

  def create
    redhopper_issue = RedhopperIssue.create(issue: Issue.find(params[:issue_id]))

    redirect_to project_kanbans_path(redhopper_issue.issue.project)
  end

  def move
    issue_to_move = RedhopperIssue.find(params[:id])
    target_issue = RedhopperIssue.find(params[:target_id])

    new_previous = "after" == params[:insert] ? target_issue : target_issue.previous

    if new_previous
      issue_to_move.append_to new_previous
    else
      issue_to_move.prepend
    end

    redirect_to project_kanbans_path(issue_to_move.issue.project)
  end

  def block
    issue_to_block = RedhopperIssue.find(params[:id])
    issue_to_block.blocked = true

    issue_to_block.save

    redirect_to project_kanbans_path(issue_to_block.issue.project)
  end

  def unblock
    issue_to_unblock = RedhopperIssue.find(params[:id])
    issue_to_unblock.blocked = false

    issue_to_unblock.save

    redirect_to project_kanbans_path(issue_to_unblock.issue.project)
  end

  def delete
    issue_to_delete = RedhopperIssue.find(params[:id])
    project = issue_to_delete.issue.project

    issue_to_delete.destroy

    redirect_to project_kanbans_path(project)
  end
end