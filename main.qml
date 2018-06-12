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
            ti.insert(0, addMsg(newStatus));
            if (currentStatus !== true) {
                btn_connect.enabled = true;
            }
        }

        onSomeMessage: {
            //Received result from server

            ti.insert(0, addMsg(msg));
            //while (ti.length>400) ti.remove(100,0);       //TODO: improve this stuff, this isn't right
            //ti.append(addMsg(msg));
            //ti.update();

        }
        onSomeError: {
            ti.insert(0, addMsg("Error! " + err));
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
        anchors.right: parent.right
        anchors.top: parent.top;
        width: 200
        //color: enabled ? this.down ? "#78C37F" : "#87DB8D" : "gray"
        //border.color: "#78C37F"
        onClicked: {
            ti.insert(0, addMsg("Connecting to server...\n"));
            backend.connectClicked();
            this.enabled = false;
        }
    }
    Button {
        id: btn_send
        enabled: !btn_connect.enabled
        text: "Send message"
        anchors.right: parent.right
        y:btn_connect.height
        width:200
        //color: enabled ? this.down ? "#6FA3D2" : "#7DB7E9" : "gray"
        //border.color: "#6FA3D2"
        onClicked: {
            ti.insert(0, addMsg("Sending message: " + msgToSend.text));
            backend.sendClicked(msgToSend.text);
        }
    }
    Button {
        id: btn_disconnect
        enabled: !btn_connect.enabled
        anchors.right: parent.right
        y: btn_connect.height + btn_send.height
        text: "Disconnect from server"
        width:200
        //color: enabled ? this.down ? "#DB7A74" : "#FF7E79" : "gray"
        //border.color: "#DB7A74"
        onClicked: {
            ti.insert(0, addMsg("Disconnecting from server..."));
            backend.disconnectClicked();
            btn_connect.enabled = true;
        }
    }
    Button {
        id: btnVibrateOn;
        enabled: !btn_connect.enabled
        anchors.right:  parent.right
        y: 4*btn_connect.height
        text:"Vibrate On"
        width:200
        onClicked: {
            backend.sendClicked("setVibrate", "1");
        }
    }

    Button {
        id: btnVibrateOff;
        enabled: !btn_connect.enabled
        anchors.right:  parent.right
        y: 5*btn_connect.height
        text:"Vibrate Off"
        width:200
        onClicked: {
            backend.sendClicked("setVibrate", "0");
        }
    }
    Button {
        id: btnTubesOn;
        enabled: !btn_connect.enabled
        anchors.right:  parent.right
        y: 7*btn_connect.height
        text:"Tubes On"
        width:200
        onClicked: {
            backend.sendClicked("setTubes", "1");
        }
    }

    Button {
        id: btnTubesOff;
        enabled: !btn_connect.enabled
        anchors.right:  parent.right
        y: 8*btn_connect.height
        text:"Tubes Off"
        width:200
        onClicked: {
            backend.sendClicked("setTubes", "0");
        }
    }

    Button {
            id: btn01mlux;
            enabled: !btn_connect.enabled
            anchors.right:  parent.right
            y: 9*btn_connect.height
            text:"0.1 mlux"
            width:70
            onClicked: {
                backend.sendClicked("set01mlux", "0");
            }
        }
        Button {
            id: btn5mlux;
            enabled: !btn_connect.enabled
            anchors.right:  btn01mlux.left
            y: 9*btn_connect.height
            text:"5 mlux"
            width:70
            onClicked: {
                backend.sendClicked("set5mlux", "0");
            }
        }
        Button {
            id: btn50lux;
            enabled: !btn_connect.enabled
            anchors.right:  btn5mlux.left
            y: 9*btn_connect.height
            text:"50 lux"
            width:70
            onClicked: {
                backend.sendClicked("set50lux", "0");
            }
        }
        Button {
            id: btnLightOff;
            enabled: !btn_connect.enabled
            anchors.right:  btn50lux.left
            y: 9*btn_connect.height
            text:"Off"
            width:70
            onClicked: {
                backend.sendClicked("setLights", "0");
            }
        }



    TextInput {
        id: msgToSend
        anchors.horizontalCenter: parent.horizontalCenter
        y:10
        leftPadding: 10
        rightPadding: 10
        text: "{ \"command\": \"getConfig\" }"
        width: 200
        font.pixelSize: 14
        clip: true
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
            height: btn_send.height + btn_connect.height + btn_disconnect.height+10;
            color: "#F4F2F5"
            border.color: "red"
            border.width: 1


        }





        Component.onCompleted: {
            ti.text = addMsg("Application started\n", false);
        }

        function addMsg(someText)
        {
            return "[" + currentTime() + "] " + someText + "\n";
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
