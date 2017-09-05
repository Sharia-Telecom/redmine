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

class KanbanBoardTest < ActiveSupport::TestCase
  fixtures :users

  def subject
    KanbanBoard.new @project
  end

  setup do
    # Given
    Feature.stubs(:enabled).returns(false)
    User.current = User.find 1

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
    @issue_todo = Issue.create!(subject: "Issue 1", project: @project, tracker: @story, status: @todo, priority: @priority, author: User.current)
    @issue_doing = Issue.create!(subject: "Issue 1", project: @project, tracker: @bug, status: @doing, priority: @priority, author: User.current)
    @issue_done = Issue.create!(subject: "Issue 1", project: @project, tracker: @story, status: @done, priority: @priority, author: User.current)

    RedhopperIssue.delete_all
    @kanban_issue_doing = RedhopperIssue.create! issue: @issue_doing
    @kanban_issue_done = RedhopperIssue.create! issue: @issue_done
  end

  test ".initialize with project" do
    assert_not_nil subject
  end

  test ".columns returns all the issue statuses sorted wrapped in columns" do
    # Given
    expected = [@todo, @doing, @done]

    # When
    result = subject.columns

    # Then
    assert_equal expected.length, result.length
    expected.each_with_index do |status, index|
      assert_equal status, result[index].issue_status
    end
  end

  test ".columns returns only the necessary columns for project trackers" do
    # Given
    expected = [@doing, @done]
    @project = Project.create!(name: 'Bugs Project', identifier: 'bugs-project', trackers: [@bug])

    # When
    result = subject.columns

    # Then
    assert_equal expected.length, result.length
    expected.each_with_index do |status, index|
      assert_equal status, result[index].issue_status
    end
  end

  test ".columns returns only the necessary columns for project trackers sorted" do
    # Given
    expected = [@todo, @doing, @done]
    @project = Project.create!(name: 'Bugs Project', identifier: 'bugs-project', trackers: [@story])

    # When
    result = subject.columns

    # Then
    assert_equal expected.length, result.length
    expected.each_with_index do |status, index|
      assert_equal status, result[index].issue_status
    end
  end

  test ".columns returns only the necessary columns for displayed trackers" do
    # Given
    Setting.plugin_redhopper = { "hidden_tracker_ids" => [ @story.id.to_s ] }
    expected = [@doing, @done]

    # When
    result = subject.columns

    # Then
    assert_equal expected.length, result.length
    expected.each_with_index do |status, index|
      assert_equal status, result[index].issue_status
    end
    Setting.plugin_redhopper = nil
  end

  test ".columns returns only the columns for open statuses" do
    # Given
    Feature.stubs(:enabled).with("only_open_statuses").returns(true)

    expected = [@todo, @doing]
    # When
    result = subject.columns

    # Then
    assert_equal expected.length, result.length
    expected.each_with_index do |status, index|
      assert_equal status, result[index].issue_status
    end
  end

  test ".columns returns columns with the right number of kanbans" do
    # Given
    expected = [@todo, @doing, @done]
    # When
    result = subject.columns
    # Then
    expected.each_with_index do |status, index|
      assert_equal status, result[index].issue_status
      assert_equal 1, result[index].work_in_progress
    end
  end

  test ".column_for_issue_status returns the right column" do
    expected = @done

    # When
    result = subject.send :column_for_issue_status, expected

    # Then
    assert_equal expected, result.issue_status
  end

  test ".issues returns an array" do
    # When
    result = subject.send :issues
    # Then
    assert_instance_of Array, result
  end

  test ".issues returns all visible issues for project" do
    # Given
    expected = [@issue_todo, @issue_doing, @issue_done]
    # When
    result = subject.send :issues
    # Then
    assert_equal expected, result
  end

  test ".issues returns only open issues" do
    # Given
    Feature.stubs(:enabled).with("only_open_statuses").returns(true)
    expected = [@issue_todo, @issue_doing]
    # When
    result = subject.send :issues
    # Then
    assert_equal expected, result
    Feature.stubs(:enabled).with("only_open_statuses").returns(false)
  end

  test ".issues returns only issues with displayed trackers" do
    # Given
    Setting.plugin_redhopper = { "hidden_tracker_ids" => [ @bug.id.to_s ] }
    expected = [@issue_todo, @issue_done]
    # When
    result = subject.send :issues
    # Then
    assert_equal expected, result
    Setting.plugin_redhopper = nil
  end

  test ".trackers returns the project trackers" do
    # Given
    @project = Project.create!(name: 'Bugs Project', identifier: 'bugs-project', trackers: [@bug])
    expected = [@bug.id]
    # When
    result = subject.send :tracker_ids
    # Then
    assert_equal expected, result
  end

  test ".trackers returns the project trackers except the hidden ones" do
    # Given
    Setting.plugin_redhopper = { "hidden_tracker_ids" => [ @story.id.to_s ] }
    @project = Project.create!(name: 'Bugs Project', identifier: 'bugs-project', trackers: [@bug, @story])
    expected = [@bug.id]
    # When
    result = subject.send :tracker_ids
    # Then
    assert_equal expected, result
    Setting.plugin_redhopper = nil
  end

end
