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

class DueDeltaPresenterTest < ActiveSupport::TestCase

  test "returns correct values when on time" do
    # Given
    due_delta = DueDeltaPresenter.new(Date.today + 2.days)
    # When
    value = due_delta.value
    title = due_delta.title
    css_class = due_delta.css_class
    abs_value = due_delta.abs_value
    # Then
    assert_equal 2, value
    assert_equal '.on_time', title
    assert_equal '', css_class
    assert_equal "2", abs_value
  end

  test "returns correct values when overdue" do
    # Given
    due_delta = DueDeltaPresenter.new(Date.today - 2.days)
    # When
    value = due_delta.value
    title = due_delta.title
    css_class = due_delta.css_class
    abs_value = due_delta.abs_value
    # Then
    assert_equal -2, value
    assert_equal '.overdue', title
    assert_equal 'overdue', css_class
    assert_equal "2", abs_value
  end

end