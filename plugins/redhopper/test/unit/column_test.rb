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

class ColumnTest < ActiveSupport::TestCase
  fixtures :issues

  setup do
    # Given
    @issue_status = IssueStatus.new name: 'To do'
    @column = Column.new @issue_status
  end

  test ".initialize with issue status" do
    # Then
    assert_not_nil @column
  end

  test ".issue_status returns the status from initialization" do
    # Given
    expected = @issue_status
    # When
    result = @column.issue_status
    # Then
    assert_equal expected, result
  end

  test ".unsorted_issues returns an empty array after initialization" do
    # Given
    expected = []
    # When
    result = @column.unsorted_issues
    # Then
    assert_equal expected, result
  end

  test ".sorted_issues returns an empty array after initialization" do
    # Given
    expected = []
    # When
    result = @column.sorted_issues
    # Then
    assert_equal expected, result
  end

  test ".<< adds Redhopper issues to unsorted section" do
    # Given
    kanban = RedhopperIssue.new
    expected = [kanban]
    # When
    @column << kanban && result = @column.unsorted_issues
    # Then
    assert_equal expected, result
  end

  test ".<< adds sortable Redhopper issues to sorted section" do
    # Given
    kanban = RedhopperIssue.create issue: Issue.first
    expected = [kanban]
    # When
    @column << kanban && result = @column.sorted_issues
    # Then
    assert_equal expected, result
  end

  test ".work_in_progress returns the count of issues in both sections" do
    # Given
    @column << RedhopperIssue.new
    @column << RedhopperIssue.create(issue: Issue.first)
    # When
    result = @column.work_in_progress
    # Then
    assert_equal 2, result
  end

end
