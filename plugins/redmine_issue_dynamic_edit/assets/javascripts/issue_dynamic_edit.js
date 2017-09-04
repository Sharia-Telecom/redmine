/* FontAwesome inclusion */
var cssId = 'fontAwesome';
	if (!document.getElementById(cssId))
	{
		var head  = document.getElementsByTagName('head')[0];
		var link  = document.createElement('link');
		link.id   = cssId;
		link.rel  = 'stylesheet';
		link.type = 'text/css';
		link.href = 'https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css';
		link.media = 'all';
		head.appendChild(link);
	}

$(document).on('click', function(e){
	$('.issue .attributes .attribute .value').removeClass('edited');
	if($(e.target).closest('.value').length) {
        $(e.target).closest('.value').addClass('edited');
    }
});
	
/* Put new dropdown lists in the detailed info block */	
if($('#statusListDropdown').length > 0) {
	var htmlCopy = $('#statusListDropdown').get(0).outerHTML;
	$('#statusListDropdown').remove();
	$('.details .attributes .status.attribute .value').html( '<span class="showValue">' + 
		$('.details .attributes .status.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}
	  
if($('#usersListDropdown').length > 0) {
	var htmlCopy = $('#usersListDropdown').get(0).outerHTML;
	$('#usersListDropdown').remove();
	$('.details .attributes .assigned-to.attribute .value').html( '<span class="showValue">' + 
		$('.details .attributes .assigned-to.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}
	  
if($('#prioritiesListDropdown').length > 0) {
	var htmlCopy = $('#prioritiesListDropdown').get(0).outerHTML;
	$('#prioritiesListDropdown').remove();
	$('.details .attributes .priority.attribute .value').html( '<span class="showValue">' + 
		$('.details .attributes .priority.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}

if($('#doneRatioListDropdown').length > 0) {
	var htmlCopy = $('#doneRatioListDropdown').get(0).outerHTML;
	$('#doneRatioListDropdown').remove();
	$('.details .attributes .progress.attribute .value').html('<span class="showValue">' + 
		$('.details .attributes .progress.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}

if($('#EstimatedTimeInput').length > 0) {
	var htmlCopy = $('#EstimatedTimeInput').get(0).outerHTML;
	$('#EstimatedTimeInput').remove();
	$('.details .attributes .estimated-hours.attribute .value').html('<span class="showValue">' + 
		$('.details .attributes .estimated-hours.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}

if($('#StartDateInput').length > 0) {
	var htmlCopy = $('#StartDateInput').get(0).outerHTML;
	$('#StartDateInput').remove();
	$('.details .attributes .start-date.attribute .value').html('<span class="showValue">' + 
		$('.details .attributes .start-date.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}

if($('#DueDateInput').length > 0) {
	var htmlCopy = $('#DueDateInput').get(0).outerHTML;
	$('#DueDateInput').remove();
	$('.details .attributes .due-date.attribute .value').html('<span class="showValue">' + 
		$('.details .attributes .due-date.attribute .value').html() + '</span> <i class="fa fa-pencil fa-fw" aria-hidden="true"></i>' +
		htmlCopy);
}

$('body').on('click', '.btn.close', function(e){
	e.preventDefault();
	$(e.target).closest('.value').removeClass('edited');
	return false;
});

function issueDynamicUpdate(field_name, field_value, type, cssClass){
	
	/* hide edit field */
	$('.details .attributes .' + cssClass + '.attribute .value').removeClass('edited');

	/* add spin notification */
	if(type == "progress") { // specific case for progress bar
		$('.details .attributes .' + cssClass + '.attribute .value').append(' <i class="fa fa-refresh fa-spin fa-fw"></i>');
	} else {
		$('.details .attributes .' + cssClass + '.attribute .value').append(' <i class="fa fa-refresh fa-spin fa-fw"></i>');
	}
	
	/* update value displayed */
	$('.details .attributes .' + cssClass + '.attribute .showValue').html(function(){
		if(type == "select")
		{
			return $('.details .attributes .' + cssClass + '.attribute .value select option:selected').html()
		} else if (type == "input")
		{
			return $('.details .attributes .' + cssClass + '.attribute .value input').val()
		} else if(type == "date")
		{
			return "XXXX/XX/XX";
		}
	});
	
	/* lost focus on element */
	if( type != "select")
	{
		$('.details .attributes .' + cssClass + '.attribute .value input').blur();
	}
	
	var token = $("meta[name=csrf-token]").attr('content');
	// we prepare the return url which is the updated issue detail page with new values
	var prepareReturnUrl = encodeURIComponent(_BASE_REDMINE_PATH + '/issues/' + _ISSUE_ID);
	jQuery.ajax({
	    type: 'POST',
	    url: _BASE_REDMINE_PATH + '/issues/bulk_update?back_url=' + prepareReturnUrl + '&amp;ids%5B%5D=' + _ISSUE_ID + '&amp;issue%5B' + field_name + '%5D=' + field_value,
	    data: { "authenticity_token" : token },
		crossDomain: true,
	    async: false,
	    beforeSend: function(xhr) {
	        xhr.setRequestHeader("authenticity_token", token);
	    },
	    success: function(msg) {
	    	// get result page content (updated issue detail page with new status)
	    	var parsed = $.parseHTML(msg);
        	var statusListDropdown = $(parsed).find("#statusListDropdown select");
        	var prioritiesListDropdown = $(parsed).find('#prioritiesListDropdown select');
        	// we update dropdown status with new one from updated page
        	$('#statusListDropdown select').html(statusListDropdown.html());
        	$('#issue_status_id').html(statusListDropdown.html());
        	$('#prioritiesListDropdown select').html(prioritiesListDropdown.html());
        	$('#issue_priority_id').html(prioritiesListDropdown.html());

			/* data updated, remove spin and add success icon for 2sec */
			setTimeout(function(){
				$('.details .attributes .' + cssClass + '.attribute i.fa-spin').removeClass('fa-refresh fa-spin').addClass('fa-check statusOk');
				setTimeout(function(){
					$('.details .attributes .' + cssClass + '.attribute i.fa-check.statusOk').remove();
				}, 2000);
			}, 500);
			
			if(type == "progress") { // specific case for progress bar, we need to update the progress bar view
				var progressBar = "<tbody><tr>";
				var percentTodo = 100 - parseInt(field_value);
				if(field_value != 0) { progressBar += "<td style='width: " + field_value + "%;' class='closed' title='" + field_value + "%'></td>"; }
				if(percentTodo != 0) { progressBar += "<td style='width: " + percentTodo + "%;' class='todo'></td>"; }
				progressBar += "</tr></tbody>";
				$('.details .attributes .' + cssClass + '.attribute table.progress').attr('class', 'progress progress-' + field_value).html(progressBar);
				$('.details .attributes .' + cssClass + ' .percent').html(field_value + "%");
			} else if( type == "date") { // specific case for start date and due date, we have to update min and max date allowed
				if(field_name == "start_date")
				{
					$('body').find('#DueDateInput input').attr('min', field_value);
				} else if (field_name == "due_date")
				{
					$('body').find('#StartDateInput input').attr('max', field_value);
				}
			}
	
			// update other fields to avoid conflict
			$('#issue_lock_version').val(parseInt($('#issue_lock_version').val()) + 1 );
			$('#last_journal_id').val(parseInt($('#last_journal_id').val()) + 1 );
			if(type == "select")
			{
				$('#issue_' + field_name + ' option').removeAttr('selected').filter('[value=' + field_value + ']').prop('selected', true);
			} else if (type == "input" || type == "date")
			{
				$('#issue_' + field_name).val(field_value);
			}
		},
	    error: function(xhr, msg, error) {
			/* error and no update, info logged into console */
			console.log('%c -------- Error while updating the issue attribute dynamically -------- ', 'background: #ff0000; color: white; font-weight:900');
			console.log('%c xhr data: ', 'background: black; color: white;');
			console.log(xhr);
			console.log('%c msg data: ', 'background: black; color: white;');
			console.log(msg);
			console.log('%c error data: ', 'background: black; color: white;');;
			console.log(error);
			console.log('%c ---------------------------------------------------------- ', 'background: #ff0000; color: white; font-weight:900');
			$('.details .attributes .' + cssClass + '.attribute i.fa-spin').removeClass('fa-refresh fa-spin').addClass('fa-times').html(" " + _TXT_ERROR_AJAX_CALL);
				setTimeout(function(){
					$('.details .attributes .' + cssClass + '.attribute i.fa-times').remove();
				}, 2000);
		}
	 });
};

/* Listeners foreach attribute */
	  
 var domSelectStatus = $('body').find('#statusListDropdown select');
 domSelectStatus.on('change', function(e){ 
 	issueDynamicUpdate('status_id', domSelectStatus.val(), 'select', 'status');

 	/* update the classes status from */
 	$("#content > div.issue").removeClass(function (index, className) {
	    return (className.match (/(^|\s)status-\S+/g) || []).join(' ');
	}).addClass('status-' + domSelectStatus.val());
 }); /* end on change domSelectStatus */
	  
 var domSelectPriorities = $('body').find('#prioritiesListDropdown select');
 domSelectPriorities.on('change', function(e){
 	issueDynamicUpdate('priority_id', domSelectPriorities.val(), 'select', 'priority');

 	/* update the classes priority from */
 	$("#content > div.issue").removeClass(function (index, className) {
	    return (className.match (/(^|\s)priority-\S+/g) || []).join(' ');
	}).addClass('priority-' + domSelectStatus.val());
 }); /* end on change domSelectPriorities */
	  
 var domSelectUsers = $('body').find('#usersListDropdown select');
 domSelectUsers.on('change', function(e){
 	issueDynamicUpdate('assigned_to_id', domSelectUsers.val(), 'select', 'assigned-to');
 }); /* end on change domSelectUsers */
 
 var domSelectRatio = $('body').find('#doneRatioListDropdown select');
 domSelectRatio.on('change', function(e){
 	issueDynamicUpdate('done_ratio', domSelectRatio.val(), 'progress', 'progress');
 }); /* end on change domSelectRatio */
 
 var domInputEstimatedTime = $('body').find('#EstimatedTimeInput input');
 $('#EstimatedTimeInput a.btn.validate').on('click', function(e)
 {
	e.preventDefault();
	$('.estimated-hours .value .error').remove();
	var estimatedTime = parseFloat(domInputEstimatedTime.val());
	if(estimatedTime >= 0)
	{
		issueDynamicUpdate('estimated_hours', estimatedTime, 'input', 'estimated-hours');
	} else {
		/* estimated time must be > 0 */
		$('.estimated-hours .value').append('<span class="error"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> ' + _TXT_ERROR_POSITIVE_NUMBER + '</span>');
	}
	return false;
 });
 
 domInputEstimatedTime.on('keyup', function(e){
	$('.details .attributes .estimated-hours.attribute .selectedValue span').html(
		$('.details .attributes .estimated-hours.attribute .value input').val()
	);
	if (e.keyCode == 13) {
        $('#EstimatedTimeInput a.btn.validate').click();
    }
 });/* end EstimatedTime */
 
 var domInputStartDate = $('body').find('#StartDateInput input');
 $('#StartDateInput a.btn.validate').on('click', function(e)
 {
	e.preventDefault();
	$('.start-date .value .error').remove();
	if(new Date(domInputStartDate.val()).getTime() <= new Date($('body').find('#DueDateInput input').val()).getTime())
	{
		issueDynamicUpdate('start_date', domInputStartDate.val(), 'date', 'start-date');
	} else {
		/* start date must be < due date */
		$('.start-date .value').append('<span class="error"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> ' + _TXT_ERROR_START_DATE + '</span>');
	}
	return false;
 }); 
 
 domInputStartDate.on('keyup', function(e){
	if (e.keyCode == 13) {
        $('#StartDateInput a.btn.validate').click();
    }
 });/* end StartDate */
 
 var domInputDueDate = $('body').find('#DueDateInput input');
 $('#DueDateInput a.btn.validate').on('click', function(e)
 {
	e.preventDefault();
	$('.due-date .value .error').remove();
	if(new Date($('body').find('#StartDateInput input').val()).getTime() <= new Date(domInputDueDate.val()).getTime())
	{
		issueDynamicUpdate('due_date', domInputDueDate.val(), 'date', 'due-date');
	} else {
		/* start date must be < due date */
		$('.due-date .value').append('<span class="error"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> ' + _TXT_ERROR_DUE_DATE + '</span>');
	}
	return false;
 }); 
 
 domInputDueDate.on('keyup', function(e){
	if (e.keyCode == 13) {
        $('#DueDateInput a.btn.validate').click();
    }
 });/* end StartDate */