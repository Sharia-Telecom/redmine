/*
 * Redhopper - Kanban boards for Redmine, inspired by Jira Agile (formerly known as
 * Greenhopper), but following its own path.
 * Copyright (C) 2015-2017 infoPiiaf <contact@infopiiaf.fr>
 *
 * This file is part of Redhopper.
 *
 * Redhopper is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Redhopper is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Redhopper.  If not, see <http://www.gnu.org/licenses/>.
 */

(function ($) {
	$(function () {
		var $kanbanBoard = $(".KanbanBoard")
		$kanbanBoard.height(Math.max(document.documentElement.clientHeight, window.innerHeight || 0) - $kanbanBoard.offset().top - 10);
		var dragSrcEl;
		var dragSrcList;
		var dropzones;
		var dropzoneHeight;

		function handleDragStart(e) {
			this.style.opacity = '0.6';  // this / e.target is the source node.

			dragSrcEl = this;
			before_dz_to_exclude = $(this).prev('hr');
			after_dz_to_exclude = $(this).next('hr');
			dragSrcList = $(this).closest('ol');
			dropzones = $(dragSrcList).children('hr').not(before_dz_to_exclude).not(after_dz_to_exclude);

			dropzones.attr('dropzone', 'move');
			[].forEach.call(dropzones, function(dz) {
				dz.addEventListener('dragenter', handleDragEnter, false)
				dz.addEventListener('dragover', handleDragOver, false);
				dz.addEventListener('dragleave', handleDragLeave, false);
				dz.addEventListener('drop', handleDrop, false);
			});

			e.dataTransfer.effectAllowed = 'move';
			e.dataTransfer.setData('text/html', this.innerHTML);
		}

		function handleDragEnd(e) {
			this.style.opacity = '1';  // this / e.target is the source node.

			dropzones.attr('dropzone', '');
			[].forEach.call(dropzones, function(col) {
				col.removeEventListener('dragenter', handleDragEnter, false)
				col.removeEventListener('dragover', handleDragOver, false);
				col.removeEventListener('dragleave', handleDragLeave, false);
				col.removeEventListener('drop', handleDrop, false);
			});
		}

		function handleDragEnter(e) {
			dropzoneHeight = $(this).height();
			$(this).height($(dragSrcEl).height());

			this.classList.add('dragover');  // this / e.target is the target node.
		}

		function handleDragOver(e) {
			if (e.preventDefault) {
				e.preventDefault(); // Necessary. Allows us to drop.
			}
		}

		function handleDragLeave(e) {
			this.classList.remove('dragover');  // this / e.target is the target node.

			$(this).height(dropzoneHeight);
		}

		function handleDrop(e) {
			// this/e.target is current target element.
			this.classList.remove('dragover');  // this / e.target is the target node.

			if (e.stopPropagation) {
				e.stopPropagation(); // Stops some browsers from redirecting.
			}

			var kanbanToMove = $(dragSrcEl).attr('id').split('-')[3]
			var targetComponents = $(this).attr('id').split('-')
			var targetKanban = targetComponents[1]
			var movePosition = targetComponents[2]
			// Don't do anything if dropping the same column we're dragging.
			if (kanbanToMove !== targetKanban) {
				$.post('/redhopper_issues/move', {
					id: kanbanToMove,
					target_id: targetKanban,
					insert: movePosition
				}, function () {
					window.location.href = window.location.href;
				})
			}

			return false;
		}

		var issues = $kanbanBoard.find('[draggable]');
		[].forEach.call(issues, function(col) {
			col.addEventListener('dragstart', handleDragStart, false);
			col.addEventListener('dragend', handleDragEnd, false);
		});
	})
})(jQuery)
