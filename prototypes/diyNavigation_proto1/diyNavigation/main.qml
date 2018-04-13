import QtQuick 2.6
import QtQuick.Window 2.2
import QtPositioning 5.8
import QtLocation 5.9

Window {
    visible: true
    width: 1600
    height: 900
    title: qsTr("diyNavigation - prototype v1")

    Map {
        Plugin {
            id: mapPlugin
            name: "osm"
        }

        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(49.015, 8.403)
        zoomLevel: 14
        copyrightsVisible: false

        RouteQuery {
            id: routeQuery
        }

        RouteModel {
            id: routeModel
            plugin: mapPlugin
            query: routeQuery
            autoUpdate: false
        }

        MapItemView {
            model: routeModel
            delegate: routeDelegate
        }

        Component {
            id: routeDelegate

            MapRoute {
                route: routeModel.get(0)
                line.color: "blue"
                line.width: 5
                smooth: true
                opacity: 0.6
            }
        }
    }

    function setupRoute(){
        routeQuery.addWaypoint(QtPositioning.coordinate(49.0107081,8.4335283));
        routeQuery.addWaypoint(QtPositioning.coordinate(49.0017365,8.416579));
        routeQuery.addWaypoint(QtPositioning.coordinate(49.1610111,8.4846428));
        routeModel.update();
    }

    Component.onCompleted: {
        setupRoute();
    }
}
