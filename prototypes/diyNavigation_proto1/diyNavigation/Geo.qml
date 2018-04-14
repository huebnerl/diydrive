import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtPositioning 5.8
import QtLocation 5.9

Item {
    function update(input) {
        geocodeModel.query = input;
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
        center: QtPositioning.coordinate(49.0084811,8.4570316)
        zoomLevel: 14
        // copyrightsVisible: false

        MapQuickItem {
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
        }

        MapItemView {
            model: routeModel
            delegate: Component {
                MapRoute {
                    route: routeData
                    line.color: Material.color(Material.LightBlue)
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
                routeDetails.clear();
                for (var i = 0; i < get(0).segments.length; i++) {
                    var maneuver = get(0).segments[i].maneuver;
                    routeDetails.append({"instruction": maneuver.instructionText});
                    //console.log("In " + maneuver.distanceToNextInstruction + " " +  maneuver.instructionText);
                }
            }
        }
    }

    GeocodeModel {
        id: geocodeModel
        plugin: osm
        query: "Graben Neudorf Lessingstrasse 1"
        onLocationsChanged: {
            if (count) {
                var destination = get(0).coordinate;

                routeQuery.clearWaypoints();
                routeQuery.addWaypoint(QtPositioning.coordinate(49.0107081,8.4335283));
                routeQuery.addWaypoint(destination);
                routeModel.update();

                map.center = destination;
                marker.coordinate = destination;
                marker.visible = true;
            }
            //for(var i = 0; i < count; i++)
            //    console.log(get(i).address.text + " @ " + get(i).coordinate);
        }
    }
}
