// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready( function() {

  bindTooltip();
 
  $('#searchResultsContainer').hide();

  $('#filterButton').click(function() {
    postSearchRequest(1);
  });

  $('.paging_links a').live("click", function(event){
    href = $(this).attr('href');
    event.preventDefault();

    //take the last char from the url as this is the page number
    page = href.substr(href.length - 1);

    postSearchRequest(page);
  });

  $('#location_from').live('change', function() {
    $('#trip_all_dates').attr('checked', true);

    var fromLocationId = $('#trip_from_location_id').val();
    refreshToLocations(fromLocationId);
  });
 
  createDatepicker();
  getValidTripDates();
  
});

function refreshToLocations(fromLocationId)
  {
    params = { from_location_id: fromLocationId, authenticity_token: _token };
    $.post("/events/load_locations").success(function(partialHtml) {
      $('#toLocation').html(partialHtml);
      bindjQueryUI();
    });
}

function createDatepicker() {
    $('#dateDiv').datepicker({
      dateFormat: 'yy/mm/dd',
      showOn: "button",
      buttonImage: "/assets/calendar.gif",
      buttonImageOnly: true,
      onSelect: function (date) {
        //turn off the 'search all dates' checkbox when a date is selected
	$('#trip_all_dates').attr('checked', false);
      },
      beforeShowDay: setScheduledDays,
      numberOfMonths: 1
      });
    }

function postSearchRequest(page) {
  var locationFrom = $('#location_from').val();
  var locationId = $('#trip_from_location_id').val();
  var selectedDate = $('#dateDiv').datepicker("getDate");

  if (selectedDate != null) {
    selectedDate = formatDate(selectedDate,"yy/mm/dd");
  }

  if ($('#trip_all_dates').attr('checked')) {
    selectedDate = -1;
  }

  params = { page: page, location_id: locationId, location_from: locationFrom, event_date: selectedDate, authenticity_token: _token };

  $('#startupContainer').hide();
  $('#searchResults').hide();
  $('#searchResultsContainer').show();
  $('#loading').show();

  $.post("/" + locale + "/events/search", params).success(function(partialHtml) {
    $('#loading').hide();
    // reset fields for next search
    $('#trip_from_location_id').val('');
    $('#location_from').val('');
    refreshSearchResults(partialHtml);
    bindTooltip();
  });
}

function refreshSearchResults(partialHtml) {
 $('#searchResults').show();
 $('#searchResults').html(partialHtml);
}

function getValidTripDates() {
  var locationId = $('#location_id').val();

  params = { location_id: locationId, authenticity_token: _token };
   
  $.post("/trips/load_valid_dates", params).success(function(validDates) {
    availableDays = validDates;
    //recreateDatepicker();
  });
}

function setScheduledDays(date) {
  return checkDateIsInArray(date, availableDays);
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

var selectedDate;
var ListOfFullDates;
var availableDays = new Array();
var queryProcessing = false;

function bindTooltip() {

    $(".customTooltip span").tooltip({
        position: "top left",   // place tooltip on the left edge
        offset: [0, 7],           // a little tweaking of the position
        opacity: 1                  // custom opacity setting
    });

    $(".MFcustomTooltip span").tooltip({
        position: "top left",   // place tooltip on the left edge
        offset: [3, 13],         // a little tweaking of the position
        opacity: 1              // custom opacity setting
    });

    $(".customTooltip").click(function () {
        $(this).next().show();
    });
}