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
class DueDeltaPresenter

  def initialize(due_date)
    @due_date = due_date
  end

  def title
    on_time? ? '.on_time' : '.overdue'
  end

  def css_class
    on_time? ? '' : 'overdue'
  end

  def value
    (@due_date - Date.today).to_i
  end

  def abs_value
    value.abs.to_s
  end

  private

  def on_time?
    value > 0
  end
end