import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtPositioning 5.8
import QtLocation 5.9

Item {
    property bool updateRoute: false
    property string destinationString: ""

    function update(start, dest) {
        routeQuery.clearWaypoints();
        updateRoute = false;
        destinationString = dest;

        geocodeModel.query = start;
        geocodeModel.update();
    }

    function getRouteDetails() {
        return routeDetails
    }

    /*PositionSource {
        active: true
        onPositionChanged: {
            console.log(position.coordinate);
        }
    }*/

    Plugin {
        id: osm
        name: "osm"
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: osm
        zoomLevel: 14
        // copyrightsVisible: false

        /*MapQuickItem {
            id: marker
            visible: false

            sourceItem: Image {
                id: image
                source: "/files/marker.png"
                width: 20
                fillMode: Image.PreserveAspectFit
            }
            anchorPoint.x: image.width / 2
            anchorPoint.y: image.height
        }*/

        MapItemView {
            model: routeModel
            delegate: Component {
                MapRoute {
                    route: routeData
                    line.color: "blue"
                    line.width: 4
                }
            }
        }
    }

    ListModel {
        id: routeDetails
    }

    RouteModel {
        id: routeModel
        plugin: osm
        query: RouteQuery {
            id: routeQuery
        }
        autoUpdate: false

        onRoutesChanged: {
            if (count) {
                routeInfo.text = "Travel distance: " + get(0).distance + "m, Travel time: about " + (get(0).travelTime / 60).toFixed(0) + " min";

                routeDetails.clear();
                for (var i = 0; i < get(0).segments.length; i++) {
                    var maneuver = get(0).segments[i].maneuver;
                    routeDetails.append({
                                            "instruction": maneuver.instructionText
                                        });
                }
            }
        }
    }

    GeocodeModel {
        id: geocodeModel
        plugin: osm
        onLocationsChanged: {
            if (count) {
                var location = get(0).coordinate;
                routeQuery.addWaypoint(location);

                if (!updateRoute) {
                    query = destinationString;
                    updateRoute = true;
                    update();
                }
                else {
                    routeModel.update();
                    // Instead of centering the map to our destination,
                    // we should try and fit the routes bounds to the viewport.
                    map.center = location;
                }
            }
        }
    }
}
