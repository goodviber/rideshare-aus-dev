//Google Maps
var fromLocationLat = 0;
var fromLocationLng = 0;
var toLocationLat = 0;
var toLocationLng = 0;

var directionDisplay;
var directionsService;
var map;

$().ready(function () {
	initializeMap();
	setDefaultLatLngOnEdit();

	$("#liTripTime").show();

	$('#trip_time_of_day_e').click(function () {
		$("#liTripTime").show();
	});

	$('#trip_time_of_day_m').click(function () {
		$("#liTripTime").hide();
	});

	$('#trip_time_of_day_a').click(function () {
		$("#liTripTime").hide();
	});

	$('#trip_from_location_id').change(function () { setLatLng(this.id, this.value); });
	$('#trip_to_location_id').change(function () { setLatLng(this.id, this.value); });
});

function setLatLng(selListId, selListValue) {
  $.post("/trips/get_lat_lng.json", { location_id: selListValue, authenticity_token: _token })
  .success(function(data) {
    if (selListId == "trip_from_location_id")
    {
      fromLocationLat = data[0].latitude;
      fromLocationLng = data[0].longitude;
    }
    else if (selListId == "trip_to_location_id")
    {
      toLocationLat = data[0].latitude;
      toLocationLng = data[0].longitude;
    }
    //Redraw the route
    calcRoute();
  });
}

function setDefaultLatLngOnEdit() {
	if($('#trip_from_location_id').val() != "")
		setLatLng($('#trip_from_location_id')[0].id, $('#trip_from_location_id').val());
	if($('#trip_to_location_id').val() != "")
		setLatLng($('#trip_to_location_id')[0].id, $('#trip_to_location_id').val());
}

function initializeMap() {
    directionsDisplay = new google.maps.DirectionsRenderer();
    directionsService = new google.maps.DirectionsService();
    var mapCenter = new google.maps.LatLng(54.8968721, 23.8924264);
    var myOptions = {
        zoom: 5,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        center: mapCenter
    }
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    directionsDisplay.setMap(map);
}

function calcRoute() {
    var start = new google.maps.LatLng(fromLocationLat, fromLocationLng);
    var end = new google.maps.LatLng(toLocationLat, toLocationLng);

    //var passloc = new google.maps.LatLng(54.9, 23.9);
    /*
    var waypts = [];
    for ( var i=0; i < appConfig.waypoints.length; ++i){
        var newWaypoint = new google.maps.LatLng(appConfig.waypoints[i].lat, appConfig.waypoints[i].lng);
        waypts.push({
            location: newWaypoint,
            stopover: true,
        });
    }
	*/

    var request = {
        origin: start,
        destination: end,
        //waypoints: waypts,
        //optimizeWaypoints: true,
        //region: lt, //Lithuania
        travelMode: google.maps.DirectionsTravelMode.DRIVING,
        unitSystem: google.maps.DirectionsUnitSystem.METRIC //google.maps.DirectionsUnitSystem.IMPERIAL
    };

    directionsService.route(request, function (result, status) {
        if (status == google.maps.DirectionsStatus.OK) {

            updateTimeDistance(result);
            directionsDisplay.setDirections(result);
            directionsDisplay.setMap(map);

            //re-sort the order of waypoints to correspond to google optimised route.
            /*
            appConfig.optWaypoints = []; //newly created
            for ( var i=0; i < result.routes[0].optimized_waypoint_order.length; ++i){

                var oldArrayIndex = result.routes[0].optimized_waypoint_order[i];
                appConfig.optWaypoints[i] = appConfig.waypoints[oldArrayIndex];
            }
            */
        }
    });
}

function clearMapDirections() {
    directionsDisplay.setMap(null);
}

function updateTimeDistance(_data) {
    var meters = 0;
    var seconds = 0;

    //Raw values. Count all legs of the trip
    for ( var i=0; i < _data.routes[0].legs.length; ++i){
        meters += _data.routes[0].legs[i].distance.value;
        seconds += _data.routes[0].legs[i].duration.value;
    }

    var tm = new Date(seconds * 1000)
    var hours = tm.getUTCHours();
    var minutes = tm.getUTCMinutes();

    $('#trip_trip_distance').val(Math.round(meters/1000));
    $('#trip_trip_duration').val(hours + ':' + minutes)
}

