import QtQuick 2.6
import QtQuick.Window 2.2
import QtPositioning 5.8
import QtLocation 5.9

Window {
    visible: true
    width: 1524
    height: 968
    title: qsTr("Dashboard")

    Rectangle{
        anchors.fill: parent
        color: "black"

        Rectangle{
            id: mapContainer
            width: tachoCircle.radius
            anchors.horizontalCenter: tachoCircle.horizontalCenter
            anchors.horizontalCenterOffset: -1.0 * tachoCircle.radius - width * 0.5 / 2
            anchors.verticalCenter: tachoCircle.verticalCenter
            anchors.verticalCenterOffset: tachoCircle.radius * 0.5
            height: width
            radius: width*0.5

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

            Image {
                anchors.fill: mapContainer
                source: "mask.png"
        }
        }


        function setupRoute(){
            routeQuery.addWaypoint(QtPositioning.coordinate(49.0107081,8.4335283));
            routeQuery.addWaypoint(QtPositioning.coordinate(49.0017365,8.416579));
            routeQuery.addWaypoint(QtPositioning.coordinate(49.1610111,8.4846428));
            routeModel.update();
        }

        Rectangle {
            width: tachoCircle.radius * 2
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            radius: width * 0.5
            color: "black"
        }

        Canvas {
            id: tachoCircle

            width: parent.height
            height: width

            property int radius: width * 0.375

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var centreX = width / 2;
                var centreY = height / 2;

                ctx.beginPath();
                ctx.lineWidth = 4;
                ctx.strokeStyle = "white";
                ctx.arc(centreX, centreY, radius, Math.PI * 0.7, Math.PI * 2.05, false);
                ctx.stroke();

                ctx.beginPath();
                ctx.lineWidth = 6;
                ctx.strokeStyle = "red";
                ctx.arc(centreX, centreY, radius, Math.PI * 2.05, Math.PI * 2.3, false);
                ctx.stroke();
            }
        }

        Text {
            id: veloText

            property int velocity: 0
            text: "" + velocity
            anchors.centerIn: tachoCircle
            color: "white"
            font.pixelSize: 200
        }

        Text {
            text: "km/h"
            anchors.top: veloText.bottom
            anchors.topMargin: 1
            anchors.horizontalCenter: veloText.horizontalCenter
            color: "white"
            font.pixelSize: 30
        }

        Text {
            property int km: 106376
            text: "" + km
            anchors.centerIn: tachoCircle
            anchors.verticalCenterOffset: tachoCircle.radius * 0.85
            anchors.horizontalCenterOffset: tachoCircle.radius * -0.38
            color: "lightgray"
            font.pixelSize: 30

            Text {
                text: "km"
                anchors.bottom: parent.top
                anchors.left: parent.left
                color: "lightgray"
                font.pixelSize: 20
            }
        }




        Text {
            property double trip: 573.5
            text: "" + trip
            anchors.centerIn: tachoCircle
            anchors.verticalCenterOffset: tachoCircle.radius * 0.85
            anchors.horizontalCenterOffset: tachoCircle.radius * 0.38
            color: "lightgray"
            font.pixelSize: 30

            Text {
                text: "trip"
                anchors.bottom: parent.top
                anchors.right: parent.right
                color: "lightgray"
                font.pixelSize: 20
            }
        }


        Canvas {
            id: tacho

            property double angular: 0.7
            property int change: 1

            width: parent.height
            height: width

            property int radius: width * 0.375

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var centreX = width / 2;
                var centreY = height / 2;

                ctx.beginPath();
                ctx.lineWidth = 11;
                ctx.strokeStyle = "blue";
                // ctx.shadowBlur=20;
                // ctx.shadowColor="white";
                ctx.arc(centreX, centreY, radius, Math.PI * 0.7, Math.PI * angular, false);
                ctx.stroke();
            }

            function updateTacho() {
                if (tacho.angular > 1.65) {
                    tacho.change = -1;
                } else if (tacho.angular == 0.7) {
                    tacho.change = 1;
                }
                tacho.angular = tacho.angular + tacho.change * 0.01;
                tacho.requestPaint();

                veloText.velocity = veloText.velocity + tacho.change * 1
                veloText.text = "" + veloText.velocity
            }

            Timer {
                interval: 70; running: true; repeat: true
                onTriggered: tacho.updateTacho()
            }

        }

        Canvas {
            id: leftCircle

            width: tachoCircle.radius * 1.1
            height: width
            anchors.horizontalCenter: tachoCircle.horizontalCenter
            anchors.horizontalCenterOffset: -1.0 * tachoCircle.radius - width / 1.1 * 0.5 / 2
            anchors.verticalCenter: tachoCircle.verticalCenter
            anchors.verticalCenterOffset: tachoCircle.radius * 0.5
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var centreX = width / 2;
                var centreY = height / 2;

                ctx.beginPath();
                ctx.lineWidth = 4;
                ctx.strokeStyle = "white";
                ctx.arc(centreX, centreY, width / 1.1 * 0.5, Math.PI * 0.15, Math.PI * 1.6, false);
                ctx.stroke();
            }
        }

        Canvas {
            id: rightCircle

            width: tachoCircle.radius * 1.1
            height: width
            anchors.horizontalCenter: tachoCircle.horizontalCenter
            anchors.horizontalCenterOffset: 1.0 * tachoCircle.radius + width / 1.1 * 0.5 / 2
            anchors.verticalCenter: tachoCircle.verticalCenter
            anchors.verticalCenterOffset: tachoCircle.radius * 0.5
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var centreX = width / 2;
                var centreY = height / 2;

                ctx.beginPath();
                ctx.lineWidth = 4;
                ctx.strokeStyle = "white";
                ctx.arc(centreX, centreY, width / 1.1 * 0.5, Math.PI * 1.4, Math.PI * 2.85, false);
                ctx.stroke();
            }
        }

        Canvas {
            id: fuelCircle

            width: tachoCircle.radius * 1.1
            height: width
            anchors.horizontalCenter: tachoCircle.horizontalCenter
            anchors.horizontalCenterOffset: 1.0 * tachoCircle.radius + width / 1.1 * 0.5 / 2
            anchors.verticalCenter: tachoCircle.verticalCenter
            anchors.verticalCenterOffset: tachoCircle.radius * 0.5
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var centreX = width / 2;
                var centreY = height / 2;

                ctx.beginPath();
                ctx.lineWidth = 8;
                ctx.strokeStyle = "blue";
                ctx.arc(centreX, centreY, width / 1.1 * 0.5, Math.PI * 1.9, Math.PI * 2.85, false);
                ctx.stroke();
            }
        }

        Image {
            anchors.centerIn: rightCircle
            anchors.verticalCenterOffset: rightCircle.width / 1.1 * 0.4
            width: 35; height: 35
            source: "fuel.png"
        }

        Component.onCompleted: {
            setupRoute();
        }


    }
}
