import QtQuick 2.0
import QtQuick.Controls 2.3

Item {
    id:tubeItem
    anchors.fill:parent;
    property alias text1:text1

    signal setPosition(var pos, var sn);

    MouseArea {

        anchors.fill:parent;
        onClicked: tubeItem.destroy();

        Rectangle {
            width:320
            height:240
            anchors.left: undefined
            anchors.top: undefined
            anchors.centerIn: parent
            anchors.verticalCenter: parent.Center
            MouseArea {
                anchors.fill: parent;
                onClicked: undefined
            }

            Rectangle {
                anchors.fill: parent
                color: "lightGray"
                Text {
                    id: text1
                    x: 20
                    y: 20
                    text: qsTr("Description")
                    font.pixelSize: 12
                }
                TextInput {
                    x:20
                    y:40
                    color:"White"
                    id: tbDescription
                    width:280
                }
                Text {
                    x:20
                    y:60
                    text: qsTr("Remarks")
                }
                TextArea {
                    x:20
                    y:80
                    height: 100
                    width:280
                }

                /*Text {
                    id: text2
                    x: 20
                    y: 40
                    text: qsTr("W: " + parent.width + " H: " + parent.height)
                    font.pixelSize: 12
                }*/

                Button {
                    id: button
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    text: qsTr("Close")
                    onClicked: {
                        tubeItem.setPosition(text1.text, "12345678")
                        tubeItem.destroy();
                    }

                }
            }
        }

    }

    Component.onCompleted: {
        tubeItem.setPosition.connect(mainForm.setPosition);
    }

}
