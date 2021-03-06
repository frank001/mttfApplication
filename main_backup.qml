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
        property var lightLevel : [ "OFF", "0.54 mlux", "5.4 mlux", "54 lux"];
        property var machineState : [];
        property var machineConfig : [];
        property var portInfo:[];
        property var cycleInfo:[];

        onStatusChanged: {
            //console.log(currentStatus);
            ti.insert(0, addMsg(newStatus));
            if (currentStatus !== true) {
                btn_connect.enabled = true;
            } else {
                btn_connect.enabled = false;
                backend.sendClicked("{ \"command\": \"getState\" }");

            }
        }

        onSomeMessage: {
            //Received result from server
            var data = msg;
            ti.insert(0, addMsg(msg));

        }
        onSomeError: {
            ti.insert(0, addMsg("Error! " + err));
            if (currentStatus !== true) {
                backend.disconnectClicked();
            }
            btn_connect.enabled = true;
        }
        onConfigChange: {
            machineConfig = JSON.parse(data);
            config.text = data.toString().replace("\n","").replace("\r","");
            for (var i=0;i<cbBaudRate.model.length;i++) {
                if (cbBaudRate.model[i] === machineConfig["config"]["baudrate"].toString()) {
                    cbBaudRate.currentIndex=i;
                    break;
                }
            }
        }


        onStateChange: {
            machineState = JSON.parse(data)["state"];
            var color=machineState.tubes?"#05a018":"#013605";

            for (var i=0;i<positions.children.length;i++) {
                positions.children[i].color=color;
            }


            liText.text = lightLevel[machineState.light];

            txtCycles.text = machineState.cycles;
            txtHours.text = machineState.cycles / 5;

            if (machineState.vibrate) {
                saVibrateX.start();
                saVibrateY.start();
            } else {
                saVibrateX.stop();
                saVibrateY.stop();
            }

            state.text = data.toString().replace("\n","").replace("\r","");

        }
        onPortInfo: {
            portInfo = JSON.parse(data);
            ports.text = data.toString().replace("\n","").replace("\r","");
            var opt = [];

            var p = portInfo["ports"];
            var idx=0
            for (var i=0;i<portInfo["ports"]["count"];i++) {
                opt.push(portInfo["ports"][i.toString()]);
                if (opt[i]===machineConfig["config"]["portname"]) idx=i;

            }
            cbPorts.model = opt;
            cbPorts.currentIndex = idx;
        }



    }



    Rectangle {     //MainWindow
        id:mainWindow
        anchors.fill:parent


        Rectangle {
            id:positionHolder
            width:parent.width/2
            height:width
            //border.width: 1
            //border.color:"red"
            anchors.right:parent.right
            anchors.margins: 10
            y:10

            Rectangle {
                id: positions
                width:parent.width
                height: parent.height
                //anchors.fill: parent
                SequentialAnimation on y  {
                    id: saVibrateY;

                    loops: Animation.Infinite;
                    NumberAnimation {

                        from: -0.5
                        to: 0.5
                        easing.type: Easing.OutExpo
                        duration: 50
                    }
                    NumberAnimation {

                        from: 0.5
                        to:-0.5
                        easing.type: Easing.OutBounce
                        duration: 50
                    }
                }
                SequentialAnimation on x  {
                    id: saVibrateX;

                    loops: Animation.Infinite;
                    NumberAnimation {

                        from: -0.5
                        to: 0.5
                        easing.type: Easing.OutExpo
                        duration: 50
                    }
                    NumberAnimation {

                        from: 0.5
                        to:-0.5
                        easing.type: Easing.OutBounce
                        duration: 50
                    }
                }

            }



            Rectangle {
                id: lightIndicator
                anchors.centerIn: parent

                Text {

                    id: liText
                    text: "OFF"
                    x:-width/2
                    y:-height/2
                }
            }
        }


        Rectangle {
            y:300;
            x:10;
            property int pSize : parent.width/30
            Text {
                font.pointSize: parent.pSize;
                text:"Cycles: ";
                Text {
                    id:txtCycles
                    anchors.left:parent.right;
                    text:"---";
                    font:parent.font
                }
            }
            Text {
                y: txtCycles.height;
                font.pointSize: parent.pSize;
                text:"Hours: ";
                Text {
                    id:txtHours;

                    anchors.left:parent.right;
                    width:50;
                    text:"---";
                    font:parent.font
                }
            }
        }
        /*Button {
            id:btnTest
            x:100
            y:100
            text: "Test"
            //onClicked: test1.show();
        }*/
        TestForm {
            id:test1
            visible: false;
            anchors.centerIn: parent
            //x:100
            //y:100
        }


        Button {
            id: btnCycleOn;
            enabled: !btn_connect.enabled
            //anchors.right:  btnCycleOff.left
            //y: 10*btn_connect.height
            text:"Cycle On"
            width:70
            onClicked: {
                backend.sendClicked("setCycle", "1");
            }
        }
        Button {
            id: btnCycleOff;
            enabled: !btn_connect.enabled
            anchors.left:  btnCycleOn.right
            //y: btn_connect.height
            text:"Cycle Off"
            width:70
            onClicked: {
                backend.sendClicked("setCycle", "0");
            }
        }


        Button {
            id: btnConfig;
            text:"Configuration"
            anchors.right: btnCalibration.left
            anchors.bottom: parent.bottom
            width:90
            onClicked: configWindow.visible=!configWindow.visible
        }

        Button {
            id: btnCalibration;
            anchors.right:  btnDebug.left
            anchors.bottom: parent.bottom
            text:"Calibration"
            width:90
            onClicked: calibrationWindow.visible=!calibrationWindow.visible
        }

        Button {
            id: btnDebug;
            anchors.right:  parent.right
            anchors.bottom: parent.bottom
            text:"Debug"
            width:90
            onClicked: debugWindow.visible=!debugWindow.visible

        }


    //{ "command": "setCycle","value":"0" }


    }

    Rectangle {     //DebugWindow
        id: debugWindow
        anchors.fill:parent
        visible: false
        color: "white"
        Button {
            id:btnDebugWindowClose
            text:"Back"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: {
                debugWindow.visible=false;
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
        Text {
            id: state
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200

            color: "red"
        }
        Text {
            id: config
            anchors.bottom: parent.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: state.right
            width: 200
            color: "blue"
        }
        Text {
            id: ports
            anchors.bottom: parent.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.right: state.left
            width: 200
            color: "green"
        }

    }

    Rectangle {     //calibrationWindow
        id: calibrationWindow
        anchors.fill:parent
        visible: false
        Button {
            id:btnCalibrationWindowClose
            text:"Back"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: {
                calibrationWindow.visible=false;
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
                backend.sendClicked("setLight", "1");
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
                backend.sendClicked("setLight", "2");
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
                backend.sendClicked("setLight", "3");
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
                backend.sendClicked("setLight", "0");
            }
        }
    }

    Rectangle {     //Configuration window
        id:configWindow
        anchors.fill:parent
        width: 500
        height: 100;
        visible: false;
        Button {
            id:btnConfigWindowClose
            text:"Back"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: {
                configWindow.visible=false;
            }
        }
        Button {
            id: btn_connect
            text: "Connect to server"
            width: 200
            onClicked: {
                ti.insert(0, addMsg("Connecting to server...\n"));
                backend.connectClicked();
            }
        }

        Button {
            id: btn_disconnect
            enabled: !btn_connect.enabled
            y: btn_connect.height
            text: "Disconnect from server"
            width:200
            onClicked: {
                ti.insert(0, addMsg("Disconnecting from server..."));
                backend.disconnectClicked();
                btn_connect.enabled = true;
            }
        }
        ComboBox {
            id: cbPorts;
            width:150;
            anchors.left:parent.left;
            anchors.bottom: parent.bottom;
        }
        ComboBox {
            id: cbBaudRate;
            width:150;
            anchors.left:cbPorts.right;
            anchors.bottom: parent.bottom;
            model: [ "9600" , "115200" ];
        }
        Button {
            enabled: false;
            id : tbUartInit;
            width:150;
            anchors.left:cbBaudRate.right;
            anchors.bottom: parent.bottom;
            text: "Initialize";
            onClicked: backend.sendClicked("resetUart", cbPorts.currentText +"," + cbBaudRate.currentText);

        }

        Text {
            id: status
            anchors.centerIn: parent
            text: backend.currentStatus ? "CONNECTED" : "DISCONNECTED"
            font.weight: Font.Bold
        }

    }

    /*
        Position {
                id:center
                width:parent.width/20
                height:width
                x:parent.width/2 - width/2
                y:parent.height/2 - height/2
                text:"EMPTY"
            }
            */





    Component.onCompleted: {
        var component;
        var sprite;
        var i,j;
        j=0;

        saVibrateX.stop();
        saVibrateY.stop();

        for (i=0;i<3;i++){
            component = Qt.createComponent("Position.qml");     //1st row
            sprite = component.createObject(positions, { "id": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 2 , "ycount" : -2 });
            j++;

        }
        for (i=0;i<4;i++){
            component = Qt.createComponent("Position.qml");     //2nd row
            sprite = component.createObject(positions, { "id": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 1,  "ycount" : -1 });
            j++;
        }
        for (i=0;i<5;i++){
            if (i!==2) {
                component = Qt.createComponent("Position.qml");     //3rd row (center)
                sprite = component.createObject(positions, { "id": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 0, "ycount" : 0 });
                j++;
            }

        }
        for (i=0;i<4;i++){
            component = Qt.createComponent("Position.qml");     //4th row
            sprite = component.createObject(positions, { "id": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 1, "ycount" : 1 });
            j++;
        }
        for (i=0;i<3;i++){
            component = Qt.createComponent("Position.qml");     //5th row
            sprite = component.createObject(positions, { "id": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 2, "ycount" : 2, });
            j++;

        }

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
    function showConfig() {

    }


}
