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
require File.expand_path('../../test_helper', __FILE__)

class RedhopperIssuesControllerTest < ActionController::TestCase

  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :enabled_modules,
           :enumerations,
           :trackers,
           :projects_trackers

  def setup
    @kanban = RedhopperIssue.create! issue: Issue.find(1)
  end

  def test_create
    # Given
    requested_issue = Issue.find(2)
    # When
    assert_difference('RedhopperIssue.count', +1) do
      post :create, :issue_id => requested_issue.id
    end
    # Then
    assert_redirected_to project_kanbans_path(requested_issue.project)
  end

  def test_move_in_first_place
    # Given
    to_move_up = RedhopperIssue.create! issue: Issue.find(2)
    # When
    get :move, id: to_move_up.id, target_id: @kanban.id, insert: 'before'
    # Then
    assert_equal [to_move_up, @kanban], RedhopperIssue.ordered
    assert_redirected_to project_kanbans_path(to_move_up.issue.project)
  end

  def test_move_up_in_second_place
    # Given
    second_kanban = RedhopperIssue.create! issue: Issue.find(2)
    to_move_up = RedhopperIssue.create! issue: Issue.find(3)
    # When
    get :move, id: to_move_up.id, target_id: second_kanban.id, insert: 'before'
    # Then
    assert_equal [@kanban, to_move_up, second_kanban], RedhopperIssue.ordered
    assert_redirected_to project_kanbans_path(to_move_up.issue.project)
  end

  def test_move_down
    # Given
    to_move_up = RedhopperIssue.create! issue: Issue.find(2)
    # When
    get :move, id: @kanban.id, target_id: to_move_up.id, insert: 'after'
    # Then
    assert_equal [to_move_up, @kanban], RedhopperIssue.ordered
    assert_redirected_to project_kanbans_path(to_move_up.issue.project)
  end

  def test_block
    # When
    get :block, id: @kanban.id
    # Then
    assert @kanban.reload.blocked?
    assert_redirected_to project_kanbans_path(@kanban.issue.project)
  end

  def test_unblock
    # Given
    blocked_issue = RedhopperIssue.create! issue: Issue.find(2), blocked: true
    # When
    get :unblock, id: @kanban.id
    # Then
    assert_not @kanban.reload.blocked?
    assert_redirected_to project_kanbans_path(@kanban.issue.project)
  end

  def test_delete
    # Given
    requested_issue = @kanban.issue
    # When
    assert_difference('RedhopperIssue.count', -1) do
      post :delete, :id => @kanban
    end
    # Then
    assert_redirected_to project_kanbans_path(requested_issue.project)
  end

end