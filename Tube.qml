import QtQuick 2.0
import QtQuick.Controls 2.3

Item {
    id:tubeItem
    anchors.fill:parent;
    property alias text1:text1
    MouseArea {

        anchors.fill:parent;
        onClicked: tubeItem.destroy();

        Rectangle {
            width:320
            height:240
            anchors.left: undefined
            anchors.top: undefined
            anchors.centerIn: parent
            //anchors.centerIn: parent.Center
            anchors.verticalCenter: parent.Center
            Rectangle {
                anchors.fill: parent
                color: "lightGray"
                Text {
                    id: text1
                    x: 20
                    y: 20
                    text: qsTr("Text")
                    font.pixelSize: 12
                }
                Text {
                    id: text2
                    x: 20
                    y: 40
                    text: qsTr("W: " + parent.width + " H: " + parent.height)
                    font.pixelSize: 12
                }

                Button {
                    id: button
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    text: qsTr("Close")
                    onClicked: {
                        tubeItem.destroy();
                    }

                }
            }
        }
    }


}
