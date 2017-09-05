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
class RedhopperIssue < ActiveRecord::Base
  unloadable
  resort!

  belongs_to :issue
  attr_accessible :issue

  validates :issue, uniqueness: true

  def blocked_with_comment?
    blocked?
  end

  def blockers
    issue.relations_to.select {|ir| ir.relation_type == IssueRelation::TYPE_BLOCKS && ir.other_issue(issue).visible?}.map { |ir| ir.issue_from }
  end

  def blocked_with_issues?
    blockers.present?
  end

  def blocked_issues
    issue.relations_from.select {|ir| ir.relation_type == IssueRelation::TYPE_BLOCKS && ir.other_issue(issue).visible?}.map { |ir| ir.issue_to }
  end

  def blocking_issue?
    blocked_issues.present?
  end

  def comments
    # Some issue updates set notes to nil or "" hence the inline SQL :(
    issue.journals.visible.where("LENGTH(journals.notes) > 0")
  end

  def sortable?
    persisted?
  end

  def due_delta
    issue.due_before ? DueDeltaPresenter.new(issue.due_before) : nil
  end

  # Presenter

  def highlight_class
    blocked_with_issues? ? 'highlight_warning' : blocking_issue? || blocked_with_comment? ? 'highlight_danger' : ''
  end

  def tracker_color
    "##{Digest::SHA1.hexdigest(issue.tracker.id.to_s)[0..5]}"
  end
end
