import QtQuick 2.4
import QtQuick.Controls 2.3

Item {
    id: cycleItem
    anchors.fill:parent;
    property alias cycleItem:cycleItem
    property alias cycleItemMA:cycleItemMA
    //property alias text1:text1
    property alias tbDescription: tbDescription
    property alias taRemarks: taRemarks

    property alias button: button

    signal setPosition(var pos, var sn);

    MouseArea {
        id: cycleItemMA;
        anchors.fill:parent;
        //onClicked: cycleItem.destroy();
        z:0
        /*Rectangle {
            anchors.fill: parent
            color:"Blue"
        }*/

        Rectangle {
            z:1
            width:320
            height:240

            anchors.left: undefined
            anchors.top: undefined
            anchors.centerIn: parent
            //anchors.centerIn: parent.Center
            anchors.verticalCenter: parent.Center
            MouseArea {
                anchors.fill: parent;
                onClicked: undefined
            }

            Rectangle {
                id: rectangle
                anchors.fill: parent
                color: "lightGray"
                radius: 5
                Text {
                    id: text1
                    x: 20
                    y: 10
                    text: qsTr("Description")
                    font.pixelSize: 12
                }
                TextField {
                    id: tbDescription
                    x:20
                    anchors.top: text1.bottom
                    anchors.topMargin: 1
                    background: Rectangle {
                        implicitHeight: 20
                        implicitWidth: 280
                        color:"White"
                        radius:4
                    }


                    //width:280
                    //font.pixelSize: 12
                }
                Text {
                    id: text2
                    x:20
                    text: qsTr("Remarks")
                    anchors.top: tbDescription.bottom
                    anchors.topMargin: 5

                }
                TextArea {
                    id: taRemarks
                    x:20
                    height: 100
                    anchors.top: text2.bottom
                    anchors.topMargin: 1
                    wrapMode: Text.WordWrap
                    width:280
                    background: Rectangle {
                        implicitHeight: 100
                        implicitWidth: 280
                        color:"White"
                        radius:4
                    }

                }
                TextArea {
                    x: 3
                    width: 211
                    height: 64
                    readOnly: true
                    color: "Red"
                    text: qsTr("Note: \nThis action will reset the current cycle \nand the counters will be set to zero.\nThis can not be undone.")
                    anchors.top: taRemarks.bottom
                    anchors.topMargin: 5
                }

                Button {
                    id: button
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    text: qsTr("OK")
                    anchors.rightMargin: 5
                    anchors.bottomMargin: 5


                }
            }
        }

    }



}
