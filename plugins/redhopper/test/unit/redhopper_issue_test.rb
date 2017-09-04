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

class RedhopperIssueTest < ActiveSupport::TestCase
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

  def test_sortable_in_sorted_zone
    # Given
    redhopper_issue = RedhopperIssue.create issue: Issue.find(1)
    # When
    result = redhopper_issue.sortable?
    # Then
    assert result
  end

  def test_unsortable_in_unsorted_zone
    # Given
    redhopper_issue = RedhopperIssue.new issue: Issue.find(1)
    # When
    result = redhopper_issue.sortable?
    # Then
    assert_not result
  end

  test "due delta is nil when no due date" do
    # Given
    redhopper_issue = RedhopperIssue.new issue: Issue.find(2)
    # When
    result = redhopper_issue.due_delta
    # Then
    assert_nil result
  end

  test "due delta returns returns a DueDeltaPresenter object when due date set" do
    # Given
    redhopper_issue = RedhopperIssue.new issue: Issue.find(1)
    # When
    result = redhopper_issue.due_delta
    # Then
    assert_instance_of DueDeltaPresenter, result
  end

  # Presenter

  def test_highlight_class_when_not_blocked
    # Given
    redhopper_issue = RedhopperIssue.new issue: Issue.find(1)
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal '', result
  end

  def test_highlight_class_when_blocked_with_comment
    # Given
    redhopper_issue = RedhopperIssue.new issue: Issue.find(1)
    redhopper_issue.blocked = true
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal 'highlight_danger', result
  end

  def test_highlight_class_when_blocked_with_issue
    # Given
    blocked_issue = Issue.find(1)
    blocking_issue = Issue.find(2)
    IssueRelation.create!(
      :issue_from => blocking_issue, :issue_to => blocked_issue,
      :relation_type => IssueRelation::TYPE_BLOCKS
    )

    redhopper_issue = RedhopperIssue.new(issue: blocked_issue)
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal 'highlight_warning', result
  end

  def test_highlight_class_when_blocked_with_issue_and_with_comment
    # Given
    blocked_issue = Issue.find(1)
    blocking_issue = Issue.find(2)
    IssueRelation.create!(
      :issue_from => blocking_issue, :issue_to => blocked_issue,
      :relation_type => IssueRelation::TYPE_BLOCKS
    )

    redhopper_issue = RedhopperIssue.new(issue: blocked_issue)
    redhopper_issue.blocked = true
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal 'highlight_warning', result
  end

  def test_highlight_class_when_blocking_issue
    # Given
    blocked_issue = Issue.find(1)
    blocking_issue = Issue.find(2)
    IssueRelation.create!(
      :issue_from => blocking_issue, :issue_to => blocked_issue,
      :relation_type => IssueRelation::TYPE_BLOCKS
    )

    redhopper_issue = RedhopperIssue.new(issue: blocking_issue)
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal 'highlight_danger', result
  end

  def test_highlight_class_when_blocking_issue_blocked_with_comment
    # Given
    blocked_issue = Issue.find(1)
    blocking_issue = Issue.find(2)
    IssueRelation.create!(
      :issue_from => blocking_issue, :issue_to => blocked_issue,
      :relation_type => IssueRelation::TYPE_BLOCKS
    )

    redhopper_issue = RedhopperIssue.new(issue: blocking_issue)
    redhopper_issue.blocked = true
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal 'highlight_danger', result
  end

  def test_highlight_class_when_blocking_issue_blocked_with_issue
    # Given
    blocked_issue = Issue.find(1)
    blocking_blocked_issue = Issue.find(2)
    blocking_issue = Issue.find(3)
    IssueRelation.create!(
      :issue_from => blocking_issue, :issue_to => blocking_blocked_issue,
      :relation_type => IssueRelation::TYPE_BLOCKS
    )
    IssueRelation.create!(
      :issue_from => blocking_blocked_issue, :issue_to => blocked_issue,
      :relation_type => IssueRelation::TYPE_BLOCKS
    )

    redhopper_issue = RedhopperIssue.new(issue: blocking_blocked_issue)
    # When
    result = redhopper_issue.highlight_class
    #Then
    assert_equal 'highlight_warning', result
  end

  def test_automatically_generates_color_regarding_associated_tracker
    # Given
    redhopper_issue = RedhopperIssue.new issue: Issue.find(1)
    redhopper_issue.issue.tracker.stubs(:id).returns(42)
    # when
    result = redhopper_issue.tracker_color
    # Then
    assert_equal '#92cfce', result
  end

end
