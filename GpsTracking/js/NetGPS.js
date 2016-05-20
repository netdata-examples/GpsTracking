/// <reference path="jquery.cookie.js" />
var map; var infowindow;
var marker = new google.maps.Marker();
var ltlng = [];
var markers = [];
var array = [];
var newmarkers = [];
var allPoints;

$(document).ready(function InitializeMap() {

});


function ChangeLang(lang) {
    window.location.href = window.location.origin + window.location.pathname + "?lang=" + lang;
}

function DrawRoute() {

    var flightPlanCoordinates = [
    { lat: 37.772, lng: -122.214 },
    { lat: 21.291, lng: -157.821 },
    { lat: -18.142, lng: 178.431 },
    { lat: -27.467, lng: 153.027 }
    ];
    var flightPath = new google.maps.Polyline({
        path: flightPlanCoordinates,
        geodesic: true,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 2
    });

    flightPath.setMap(map);
    var center = new google.maps.LatLng(flightPlanCoordinates[0].lat, flightPlanCoordinates[0].lng);
    map.panTo(center);

}

function GetMarkers() {

    var startDate = $('#startDate').val();
    var endDate = $('#endDate').val();

    $.ajax({
        type: "POST",
        url: "Default.aspx/GetMarkers",
        contentType: "application/json; charset=utf-8",
        data: "{url:" + JSON.stringify($('#txtUrl').val()) + ",startDate:" + JSON.stringify(startDate) + ",endDate:" + JSON.stringify(endDate) + "}",
        dataType: "json",
        async: false,
        cache: false,
        success: function (response) {

            //var latlng = new google.maps.LatLng(40.756, -73.986);
            var myOptions =
            {
                scrollWheel: false,
                zoom: 13
            };
            map = new google.maps.Map(document.getElementById("map"), myOptions);


            console.log(response);
            var result = JSON.parse(response.d);
            var points = result.points;
            allPoints = points;

            if (result.setDate == "true") {
                $('#startDate').val(result.MinDate);
                $('#endDate').val(result.MaxDate);
            }

            console.log(points);
            $('#namePanel').hide();
            $('#mapPanel').show();



            if ($('#chkShowPoints').prop("checked")) {
                showMarkers("all", points);
            }
            else {
                showMarkers("startend", points);
            }


        },
        error: function (request, status, error) {
            sweetAlert(ntdtdilHataliGiris, ntdtdilHataliGirisAciklama, "error");
        }
    });
}
function ShowPoint(i) {

    for (var z = 0; z < markers.length; z++) {
        if (!(z == 0 || z == markers.length - 1)) {
            markers[z].setMap(null);

        }

        markers[0].setMap(map)
    }

    markers[i].setMap(map);
    var latLng = markers[i].getPosition(); // returns LatLng object
    map.setCenter(latLng); // setCenter takes a LatLng object
    //map.setZoom(18);


    markers[i].setAnimation(google.maps.Animation.BOUNCE);
    setTimeout(function () {
        markers[i].setAnimation(null);
    }, 3700);
}

function showMarkers(type, points) {
    setMapOnAll(null);
    markers = [];
    var markerBounds = new google.maps.LatLngBounds();
    if (typeof points == 'undefined') {
        points = allPoints;
    }
    else {
        allPoints = points;
    }

    var pointLocation = new google.maps.Polyline({
        path: points,
        geodesic: true,
        strokeColor: '#00B3FD',
        strokeOpacity: 0.5,
        strokeWeight: 6
    });

    pointLocation.setMap(map);

    $('#mapjs').html('');

    for (var i = 0; i < points.length; i++) {

        markerBounds.extend(new google.maps.LatLng(points[i].lat, points[i].lng));

        $('#mapjs').append(
               '<a id="point-0" onclick="ShowPoint(' + i + ')" class="list-group-item point" style="cursor: pointer;"><span class="badge">' + (i + 1) + '</span><h4 class="list-group-item-heading">' + points[i].date + '</h4>'
                           + '<p class="list-group-item-text">'
                       + 'Latitude:' + points[i].lat + '<br>'
                       + 'Longitude:' + points[i].lng + ''
                   + '</p>'
               + '</a>');


        marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(points[i].lat, points[i].lng),
            draggable: false,
            title: points[i].date,
            content: points[i].date,
            id: i,
            dataid: "" + i,
        });

        if ((i == 0 || i == points.length - 1) || type == "all") {
            var tmpString = "";

            if (i == 0)
                tmpString = ntdtdilBaslangicNoktasi;
            else if (i > 0 && i == points.length - 1)
                tmpString = ntdtdilBitisNoktasi;


            if (i > 0 && i == points.length - 1) {
                var pinIcon = new google.maps.MarkerImage(
                        "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                        null, /* size is determined at runtime */
                        null, /* origin is 0,0 */
                        null, /* anchor is bottom center of the scaled image */
                        new google.maps.Size(48, 48)
                    );
                marker.setIcon(pinIcon);
            }
            if (i == 0) {
                var pinIcon = new google.maps.MarkerImage(
                       "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
                       null, /* size is determined at runtime */
                       null, /* origin is 0,0 */
                       null, /* anchor is bottom center of the scaled image */
                       new google.maps.Size(48, 48)
                   );
                marker.setIcon(pinIcon);
            }
            marker.set("content", marker.get("content") + tmpString);

            google.maps.event.addListener(marker, 'click', function () {
                // Calling the open method of the infoWindow 
                if (!infowindow) {
                    infowindow = new google.maps.InfoWindow();
                }
                infowindow.setContent(this.content);
                infowindow.open(map, this);
            });



        }
        else {
            marker.setMap(null);
        }
        markers.push(marker);
    }
    map.setCenter(markerBounds.getCenter(), 0);
    map.fitBounds(markerBounds);

}

function getZoomByBounds(map, bounds) {
    var MAX_ZOOM = map.mapTypes.get(map.getMapTypeId()).maxZoom || 21;
    var MIN_ZOOM = map.mapTypes.get(map.getMapTypeId()).minZoom || 0;

    var ne = map.getProjection().fromLatLngToPoint(bounds.getNorthEast());
    var sw = map.getProjection().fromLatLngToPoint(bounds.getSouthWest());

    var worldCoordWidth = Math.abs(ne.x - sw.x);
    var worldCoordHeight = Math.abs(ne.y - sw.y);

    //Fit padding in pixels 
    var FIT_PAD = 40;

    for (var zoom = MAX_ZOOM; zoom >= MIN_ZOOM; --zoom) {
        if (worldCoordWidth * (1 << zoom) + 2 * FIT_PAD < $(map.getDiv()).width() &&
            worldCoordHeight * (1 << zoom) + 2 * FIT_PAD < $(map.getDiv()).height())
            return zoom;
    }
    return 0;
}

function setMapOnAll(map) {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
    }
}



