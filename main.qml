import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import io.qt.BackEnd 1.0


//https://github.com/retifrav/client-server/blob/master/client-server-qml/clientPart/main.qml

Window {
    visible: true
    width: 700
    minimumWidth: 500
    height: 450
    minimumHeight: 200
    title: "Client"
    color: "#CED0D4"

    BackEnd {
        id: backend

        onStatusChanged: {
            //console.log(currentStatus);
            ti.append(addMsg(newStatus));
            if (currentStatus !== true) {
                btn_connect.enabled = true;
            }
        }

        onSomeMessage: {
            ti.append(addMsg(msg));
        }
        onSomeError: {
            ti.append(addMsg("Error! " + err));
            if (currentStatus !== true) {
                backend.disconnectClicked();
            }
            btn_connect.enabled = true;
        }

    }


        Text {
            id: status
            anchors.centerIn: parent
            text: backend.currentStatus ? "CONNECTED" : "DISCONNECTED"
            font.weight: Font.Bold
        }
        Button {
            id: btn_connect
            //anchors.left: parent.left
            text: "Connect to server"
            y:500
            x:500
            //color: enabled ? this.down ? "#78C37F" : "#87DB8D" : "gray"
            //border.color: "#78C37F"
            onClicked: {
                ti.append(addMsg("Connecting to server..."));
                backend.connectClicked();
                this.enabled = false;
            }
        }
                Button {
                    id: btn_disconnect
                    enabled: !btn_connect.enabled
                    anchors.right: parent.right
                    text: "Disconnect from server"
                    //color: enabled ? this.down ? "#DB7A74" : "#FF7E79" : "gray"
                    //border.color: "#DB7A74"
                    onClicked: {
                        ti.append(addMsg("Disconnecting from server..."));
                        backend.disconnectClicked();
                        btn_connect.enabled = true;
                    }
                }


            TextArea {
                id: ti
                readOnly: true
                selectByMouse : true
                font.pixelSize: 14
                wrapMode: TextInput.WrapAnywhere
                    }


            Rectangle {
                    Layout.fillWidth: true
                    height: btn_send.height
                    color: "#F4F2F5"
                    border.color: "gray"
                    border.width: 1

                    TextInput {
                        id: msgToSend
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                        rightPadding: 10
                        text: "TEST"
                        width: parent.width
                        font.pixelSize: 14
                        clip: true
                    }
                }

                Button {
                    id: btn_send
                    enabled: !btn_connect.enabled
                    text: "Send"
                    //color: enabled ? this.down ? "#6FA3D2" : "#7DB7E9" : "gray"
                    //border.color: "#6FA3D2"
                    onClicked: {
                        ti.append(addMsg("Sending message..."));
                        backend.sendClicked(msgToSend.text);
                    }
                }



        Component.onCompleted: {
            ti.text = addMsg("Application started\n- - - - - -", false);
        }

        function addMsg(someText)
        {
            return "[" + currentTime() + "] " + someText;
        }

        function currentTime()
        {
            var now = new Date();
            var nowString = ("0" + now.getHours()).slice(-2) + ":"
                    + ("0" + now.getMinutes()).slice(-2) + ":"
                    + ("0" + now.getSeconds()).slice(-2);
            return nowString;
    }
}
