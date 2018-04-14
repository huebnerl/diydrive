import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.2


Window {
    visible: true
    x: 0
    y: 0
    width: 1600
    height: 900
    title: "diyNavigation"

    Material.theme: Material.Light
    Material.accent: Material.LightBlue

    Geo {
        id: geo
        anchors.fill: parent
    }

    TextField {
        id: addressInput
        anchors.left: parent.left
        anchors.right: submitButton.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        placeholderText: "Enter your destination"

        selectByMouse: true
    }

    Button {
        id: submitButton
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 10

        text: "Route"
        highlighted: true

        onClicked: {
            var input = addressInput.text.trim();
            if (input.length)
                geo.update(input);
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: addressInput.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        ListView {
            anchors.fill: parent

            model: geo.getRouteDetails()

            interactive: true
            delegate: Text {
                style: Text.Raised
                styleColor: "lightgray"
                font.pointSize: 12
                text: instruction
            }
        }
    }
}
