import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Universal 2.2
import QtQuick.Window 2.2


Window {
    visible: true
    x: 0
    y: 0
    width: 1600
    height: 900
    title: "diyNavigation"

    Universal.accent: Universal.Steel

    Geo {
        id: geo
        anchors.fill: parent
    }

    TextField {
        id: startAddress
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: parent.width / 5

        placeholderText: "Starting point"
        selectByMouse: true
    }

    TextField {
        id: destAddress
        anchors.right: parent.right
        anchors.top: startAddress.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: parent.width / 5

        placeholderText: "Destination"
        selectByMouse: true
    }

    Button {
        id: submitButton
        anchors.right: parent.right
        anchors.top: destAddress.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 10

        text: "Route"

        onClicked: {
            var start = startAddress.text.trim();
            var dest = destAddress.text.trim();
            if (start.length && dest.length)
                geo.update(start, dest);
        }
    }

    Text {
        id: routeInfo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10

        font.pointSize: 16
        style: Text.Raised
        styleColor: "lightgray"
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: routeInfo.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        ListView {
            anchors.fill: parent

            model: geo.getRouteDetails()

            interactive: true
            delegate: Text {
                font.pointSize: 12
                style: Text.Raised
                styleColor: "lightgray"

                text: instruction
            }
        }
    }
}
