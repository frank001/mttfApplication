import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Item {
    id: item1
    width: 400
    height: 400
    property alias posHolder: posHolder
    property alias configHolder: configHolder
    property alias btnConnect: btnConnect
    property alias btnDisconnect: btnDisconnect
    property alias debugLog: debugLog

    property alias cbPorts: cbPorts
    property alias cbBaudrate: cbBaudrate

    property alias currentState: currentState
    property alias currentConfig: currentConfig
    property alias currentPorts: currentPorts
    property alias currentCycle: currentCycle

    property alias btnTubesOn: btnTubesOn
    property alias btnTubesOff: btnTubesOff

    property alias btnVibrateOn: btnVibrateOn
    property alias btnVibrateOff: btnVibrateOff

    property alias btnLight0: btnLight0
    property alias btnLight1: btnLight1
    property alias btnLight2: btnLight2
    property alias btnLight3: btnLight3

    property alias btnCycleNew: btnCycleNew
    property alias btnCycleEdit: btnCycleEdit
    property alias button: button


    //property alias btnConnect: btnConnect
    //property alias btnDisconnect: btnDisconnect
    TabBar {
        id: bar
        x: 0
        y: 360
        width: parent.width
        position: TabBar.Footer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        TabButton {
            text: qsTr("Home")
        }
        TabButton {
            text: qsTr("Config")
        }
        TabButton {
            text: qsTr("Calibration")
        }
        TabButton {
            text: qsTr("Debug")
        }
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: bar.currentIndex

        Item {
            id: homeTab
            Rectangle {
                id: posHolder
                //border.color: "Red"
                //border.width:5
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height - bar.height
            }

            Button {
                id: button
                x: 292
                y: 315
                text: qsTr("Button")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 45
                anchors.right: parent.right
                anchors.rightMargin: 8
            }
        }
        Item {
            //anchors.fill:parent;
            //layout.alignment:
            //Layout.alignment: parent.alignment

            id: configTab
            Rectangle {
                id: configHolder
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height - bar.height
                Button {
                    id: btnConnect
                    width: 200
                    text: qsTr("Connect")
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    anchors.top: parent.top
                    anchors.topMargin: 1
                }
                Button {
                    id: btnDisconnect
                    width: 200
                    text: qsTr("Disconnect")
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    anchors.top: btnConnect.bottom
                    anchors.topMargin: 1
                }
                ComboBox {
                    id: cbPorts
                    width: 200
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    anchors.left: btnConnect.right
                    anchors.leftMargin: 1
                    //anchors.left:parent.left;
                    //anchors.bottom: parent.bottom;
                }

                ComboBox {
                    id: cbBaudrate
                    width: 200
                    anchors.top: cbPorts.bottom
                    anchors.topMargin: 1
                    anchors.left: btnDisconnect.right
                    anchors.leftMargin: 1
                }
                Button {
                    id: btnCycleNew
                    width: 200
                    text: qsTr("New Cycle")
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    anchors.top: btnDisconnect.bottom
                    anchors.topMargin: 1
                }
                Button {
                    id: btnCycleEdit
                    width: 200
                    text: qsTr("Edit Cycle")
                    anchors.left: btnCycleNew.right;
                    anchors.leftMargin: 1
                    anchors.top: cbBaudrate.bottom
                    anchors.topMargin: 1
                }
            }

        }
        Item {
            id: calibrationTab
            Button {
                id: btnVibrateOn
                width: 200
                text: qsTr("Vibrate On")
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 1
            }
            Button {
                id: btnVibrateOff
                width: 200
                text: qsTr("Vibrate Off")
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.top: btnVibrateOn.bottom
                anchors.topMargin: 1
            }
            Button {
                id: btnTubesOn
                width: 200
                text: qsTr("Tubes On")
                anchors.left: btnVibrateOn.right
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 1
            }
            Button {
                id: btnTubesOff
                width: 200
                text: qsTr("Tubes Off")
                anchors.left: btnVibrateOff.right
                anchors.leftMargin: 1
                anchors.top: btnTubesOn.bottom
                anchors.topMargin: 1
            }
            Button {
                id: btnLight0
                width: 100
                text: "Off"
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.top: btnVibrateOff.bottom
                anchors.topMargin: 1
            }
            Button {
                id: btnLight1
                width: 99
                text: "0.54mlux"
                anchors.left: btnLight0.right
                anchors.leftMargin: 1
                anchors.top: btnVibrateOff.bottom
                anchors.topMargin: 1
            }
            Button {
                id: btnLight2
                width: 99
                text: "5.4mlux"
                anchors.left: btnLight1.right
                anchors.leftMargin: 1
                anchors.top: btnVibrateOff.bottom
                anchors.topMargin: 1
            }
            Button {
                id: btnLight3
                width: 100
                text: "54lux"
                anchors.left: btnLight2.right
                anchors.leftMargin: 1
                anchors.top: btnVibrateOff.bottom
                anchors.topMargin: 1
            }
        }
        Item {
            id: debugTab
            TextArea {
                id: debugLog
                readOnly: true
                selectByMouse: true
                font.pixelSize: 14
                wrapMode: TextInput.WrapAnywhere
            }
            Text {
                id: currentState
                width: 200
                color: "red"
                anchors.left: debugLog.right
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 1
            }
            Text {
                id: currentConfig
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.left: currentState.right
                width: 200
                color: "blue"
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 1
            }
            Text {
                id: currentCycle
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.left: currentConfig.right
                width: 200
                color: "#4e0080"
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 1
            }
            Text {
                id: currentPorts
                //anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                color: "green"
                anchors.left: currentCycle.right
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 1
            }
        }
    }
}
