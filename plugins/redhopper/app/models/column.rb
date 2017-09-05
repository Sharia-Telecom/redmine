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
class Column

	attr_reader :issue_status
	attr_reader :unsorted_issues
	attr_reader :sorted_issues

	def initialize issue_status
		@issue_status = issue_status
		@unsorted_issues = []
		@sorted_issues = []
	end

	def << issue
		(issue.sortable? ? @sorted_issues : @unsorted_issues) << issue
	end

	def work_in_progress
		@unsorted_issues.count + @sorted_issues.count
	end

end
