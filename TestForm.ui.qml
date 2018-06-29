import QtQuick 2.4
import QtQuick.Dialogs.qml 1.0

Item {
    id: item1
    width: 400
    height: 250
    visible: true
    opacity: 1
    property alias item1: item1
    clip: false
    property alias positionNumber: txtPositionNumber
    property alias serialNumber: txtSerialNumber
    Rectangle {
        id: rectangle
        color: "#b4b8d4"
        anchors.fill: parent
        border.color: "black"
        border.width: 2

        Text {
            id: text1
            x: 19
            y: 15
            text: qsTr("Position: ")
            font.pixelSize: 12
        }

        Text {
            id: txtPositionNumber
            x: 107
            y: 15
            width: 38
            height: 14
            text: qsTr("Text")
            font.pixelSize: 12
        }

        Text {
            id: text2
            x: 19
            y: 35
            text: qsTr("Serial number: ")
            font.pixelSize: 12
        }

        TextInput {
            id: txtSerialNumber
            x: 107
            y: 35
            width: 135
            height: 43
            text: qsTr("Text Input")
            font.pixelSize: 12
        }



    }

}
