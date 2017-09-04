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

class KanbansControllerTest < ActionController::TestCase
	fixtures :users

	setup do
    # Given
    Feature.stubs(:enabled).returns(false)
		User.current = User.find(@request.session[:user_id] = 1)

    Role.delete_all
    @dev = Role.create!(name: 'Dev')

    IssueStatus.delete_all
    @done = IssueStatus.create!(name: 'Done', is_closed: true, position: 3)
    @doing = IssueStatus.create!(name: 'Doing', position: 2)
    @todo = IssueStatus.create!(name: 'To do', position: 1)

    Tracker.delete_all
    @story = Tracker.create!(name: 'Story', default_status: @todo)
    @bug = Tracker.create!(name: 'Bug', default_status: @doing)

    WorkflowTransition.delete_all
    WorkflowTransition.create!(:role_id => @dev.id, :tracker_id => @story.id, :old_status_id => @doing.id, :new_status_id => @done.id)
    WorkflowTransition.create!(:role_id => @dev.id, :tracker_id => @story.id, :old_status_id => @todo.id, :new_status_id => @doing.id)
    WorkflowTransition.create!(:role_id => @dev.id, :tracker_id => @bug.id, :old_status_id => @doing.id, :new_status_id => @done.id)

    Project.delete_all
    @project = Project.create! name: 'Test Project', identifier: 'test-project'

    IssuePriority.delete_all
    @priority = IssuePriority.create! name:'Normal'

    Issue.delete_all
		@issue_idea = Issue.create!(subject: "Issue 4", project: @project, tracker: @story, status: @todo, priority: @priority, author: User.current)
    @issue_todo = Issue.create!(subject: "Issue 3", project: @project, tracker: @story, status: @todo, priority: @priority, author: User.current)
    @issue_doing = Issue.create!(subject: "Issue 2", project: @project, tracker: @bug, status: @doing, priority: @priority, author: User.current)
    @issue_done = Issue.create!(subject: "Issue 1", project: @project, tracker: @story, status: @done, priority: @priority, author: User.current)

    RedhopperIssue.delete_all
		@kanban_issue_todo = RedhopperIssue.create! issue: @issue_todo
    @kanban_issue_doing = RedhopperIssue.create! issue: @issue_doing
    @kanban_issue_done = RedhopperIssue.create! issue: @issue_done
	end

	def test_index
		get :index, :project_id => @project.id

		assert_response :success
		assert_template 'index'

		assert_not_nil assigns['kanban_board']
	end

	def test_index_board_structure
		get :index, :project_id => @project.id

		assert_select columns, 3 do |columns|
			todo_column, doing_column, done_column = columns

			assert_select todo_column, column_heading, "To do\n(2)"
			assert_select todo_column, sorted_column_cards, 1
			assert_select todo_column, unsorted_column_cards, 1

			assert_select doing_column, column_heading, "Doing\n(1)"
			assert_select doing_column, sorted_column_cards, 1
			assert_select doing_column, unsorted_column_cards, 0

			assert_select done_column, column_heading, "Done\n(1)"
			assert_select done_column, sorted_column_cards, 1
			assert_select done_column, unsorted_column_cards, 0
		end
	end

	private

	def columns
		'.Column'
	end

	def column_heading
		'h3'
	end

	def sorted_column_cards
		'ol .Kanban'
	end

	def unsorted_column_cards
		'ul .Kanban'
	end
end
