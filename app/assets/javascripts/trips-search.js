var selectedDate;
var ListOfFullDates;
var availableDays = new Array();
var queryProcessing = false;

$(document).ready(function () {

	function createDatepicker() {
		$('#dateDiv').datepicker({
		    dateFormat: 'dd-mm-yy',
		    constrainInput: false,
		    onSelect: function (date) {
		        //submitData(date);
		        postSearchRequest();
		    },
		    beforeShowDay: setScheduledDays,
		    //beforeShow: getValidTripDates,
		    numberOfMonths: 1,
		    gotoCurrent: true,
		    showAnim: ''
		});
    }

	createDatepicker();

    function recreateDatepicker() {
    	$('#dateDiv').datepicker( "destroy" );
    	createDatepicker();
    }

    //$('#dateDiv').datepicker( "option", "disabled", true );


    $('#trip_to_location_id').live('change', function() {
		//postSearchRequest();
		getValidTripDates();
    });

    $('#trip_from_location_id').live('change', function() {
		//postSearchRequest();

		var fromLocationId = $('#trip_from_location_id').val();
		refreshToLocations(fromLocationId);
    });

	function refreshToLocations(fromLocationId)
	{
		params = { from_location_id: fromLocationId, authenticity_token: _token };
		$.post("/trips/load_to_locations", params)
			.success(function(partialHtml) {
				$('#toLocation').html(partialHtml);
		});
	}

	function postSearchRequest() {
		var fromLocationId = $('#trip_from_location_id').val();
		var toLocationId = $('#trip_to_location_id').val();

		params = { from_location_id: fromLocationId, to_location_id: toLocationId, authenticity_token: _token };

		$('#searchResults').hide();
		$.post("/trips/load_search_results", params)
		  .success(function(partialHtml) {
			refreshSearchResults(partialHtml);
		  });
	}

    function refreshSearchResults(partialHtml) {
	  $('#searchResults').show();
	  $('#searchResults').html(partialHtml);
    }


	function getValidTripDates() {

		var fromLocationId = $('#trip_from_location_id').val();
		var toLocationId = $('#trip_to_location_id').val();

		params = { from_location_id: fromLocationId, to_location_id: toLocationId, authenticity_token: _token };
		$.post("/trips/load_valid_dates", params)
		  .success(function(validDates) {
			availableDays = validDates;

			//$('#DateDiv').datepicker('refresh');
			recreateDatepicker();
		  });
	}


	function setScheduledDays(date) {
		today = new Date();
		today.setDate(today.getDate()-1);

		if (date >= today)
			return checkDateIsInArray(date);
		else
			return [false, 'CLOSED', 'There are no trips for this date'];
	}

	function checkDateIsInArray(date) {
		var year  = date.getFullYear()
		var month = date.getMonth()+1;
		var day   = date.getDate();
		formattedDate = year + "-0" + month + "-" + day;

		if (jQuery.inArray(formattedDate, availableDays) != -1)
			return [true, ''];
		else
			return [false, 'CLOSED', 'There are no trips for this date'];
	}

});

