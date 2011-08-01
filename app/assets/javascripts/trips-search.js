var selectedDate;
var ListOfFullDates;
var availableDays = new Array();
var queryProcessing = false;


function bindTooltip() {

    $(".customTooltip span").tooltip({
        position: "top left",   // place tooltip on the left edge
        offset: [0, 7],           // a little tweaking of the position
        //effect: "fade",             // use the built-in fadeIn/fadeOut effect
        opacity: 1                  // custom opacity setting
    });

    $(".MFcustomTooltip span").tooltip({
        position: "top left",   // place tooltip on the left edge
        offset: [3, 13],         // a little tweaking of the position
        //effect: "fade",       // use the built-in fadeIn/fadeOut effect
        opacity: 1              // custom opacity setting
    });

    $(".customTooltip").click(function () {
        $(this).next().show();
    });
}


$(document).ready(function () {

	bindTooltip();

	$('#searchResultsContainer').hide();

	$('#filterButton').click(function() {
		var selectedDate = $('#dateDiv').datepicker("getDate");
		selectedDate = formatDate(selectedDate,"yy/mm/dd");

		if ($('#trip_all_dates').attr('checked')) {
			selectedDate = -1;
		}

		postSearchRequest(selectedDate);
	});

	function createDatepicker() {
		$('#dateDiv').datepicker({
		    dateFormat: 'yy/mm/dd',
		    //constrainInput: false,
		    onSelect: function (date) {
		        //submitData(date);
		        //postSearchRequest(date);
		        $('#trip_all_dates').attr('checked', false);

		    },
		    beforeShowDay: setScheduledDays,
		    //beforeShow: test,
		    numberOfMonths: 1
		    //gotoCurrent: true,
		    //showAnim: ''
		});

    }

	createDatepicker();
	getValidTripDates();

    function recreateDatepicker() {
    	$('#dateDiv').datepicker( "destroy" );
    	createDatepicker();
    }

    $('#trip_to_location_id').live('change', function() {
		//postSearchRequest();
		getValidTripDates();
		$('#trip_all_dates').attr('checked', true);
    });

    $('#trip_from_location_id').live('change', function() {
		//postSearchRequest();
		getValidTripDates();
		$('#trip_all_dates').attr('checked', true);

		var fromLocationId = $('#trip_from_location_id').val();
		refreshToLocations(fromLocationId);
    });

	function refreshToLocations(fromLocationId)
	{
		params = { from_location_id: fromLocationId, authenticity_token: _token };
		$.post("/trips/load_to_locations", params)
			.success(function(partialHtml) {
				$('#toLocation').html(partialHtml);
				bindjQueryUI();
		});
	}

	function postSearchRequest(date) {
		var fromLocationId = $('#trip_from_location_id').val();
		var toLocationId = $('#trip_to_location_id').val();

		params = { from_location_id: fromLocationId, to_location_id: toLocationId, date: date, authenticity_token: _token };

		$('#searchResults').hide();
		$.post("/trips/load_search_results", params)
		  .success(function(partialHtml) {
		  	$('#searchResultsContainer').show();
			refreshSearchResults(partialHtml);
			bindTooltip();
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
			return checkDateIsInArray(date, availableDays);
		else
			return [false, 'CLOSED', 'There are no trips for this date'];
	}

	function checkDateIsInArray(date, array) {
		formattedDate = formatDate(date, "yy-mm-dd");

		if (jQuery.inArray(formattedDate, array) != -1)
			return [true, ''];
		else
			return [false, 'CLOSED', 'There are no trips for this date'];
	}

	function formatDate(date, format) {
		var year  = date.getFullYear();
		var month = date.getMonth()+1;
		var day   = date.getDate();

		if (month < 10) { month = "0" + month; }
		if (day < 10) { day = "0" + day; }

		if (format == "dd/mm/yy")
			return day + "/" + month + "/" + year;
		else if (format == "yy/mm/dd")
			return year + "/" + month + "/" + day;
		else if (format == "yy-mm-dd")
			return year + "-" + month + "-" + day;
	}

});

