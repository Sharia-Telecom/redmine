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
class KanbanBoard

	attr_reader :columns

	def initialize project
		@project = project
		@columns_by_status = {}

		@columns = statuses.map do |status|
			@columns_by_status[status] = Column.new status
		end

		project_issues = issues

		RedhopperIssue.ordered.each do |redhopper_issue|
			issue = redhopper_issue.issue
			if project_issues.include?(issue)
				column_for_issue_status(issue.status) << redhopper_issue
				project_issues.delete issue
			end
		end

		project_issues.each do |issue|
			column_for_issue_status(issue.status) << RedhopperIssue.new(issue: issue)
		end
	end

	private

	def column_for_issue_status status
		@columns_by_status[status]
	end

	def issues
		project_issues = Issue.visible(User.current, :project => @project)
		project_issues = project_issues.open if Feature.enabled("only_open_statuses")
		project_issues = project_issues.where(tracker_id: tracker_ids)

		project_issues.to_a
	end

	def tracker_ids
		trackers_to_remove = (Setting.plugin_redhopper && Setting.plugin_redhopper["hidden_tracker_ids"] || []).map(&:to_i)

		@project.trackers.map(&:id) - trackers_to_remove
	end

	def statuses
		result = IssueStatus.sorted
		result = result.where(is_closed: false) if Feature.enabled("only_open_statuses")

		necessary_statuses = []
		WorkflowTransition.where(:tracker_id => tracker_ids, :role_id => Role.all.map(&:id)).each do |transition|
			necessary_statuses << transition.old_status
			necessary_statuses << transition.new_status
		end

		result & necessary_statuses.uniq
	end

end
