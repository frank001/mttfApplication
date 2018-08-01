import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import io.qt.BackEnd 1.0

Window {
    visible: true
    width: 700
    minimumWidth: 500
    height: 450
    minimumHeight: 200

    BackEnd {
        id: backend
        property var lightLevel : [ "OFF", "0.54 mlux", "5.4 mlux", "54 lux"];
        property var machineState : [];
        property var machineConfig : [];
        property var portInfo:[];
        property alias _btnConnect: mainForm.btnConnect;
        property alias _btnDisconnect: mainForm.btnDisconnect;
        property alias _debugLog: mainForm.debugLog
        property alias _cbPorts: mainForm.cbPorts
        property alias _cbBaudrate: mainForm.cbBaudrate
        property alias _currentState: mainForm.currentState
        property alias _currentConfig: mainForm.currentConfig
        property alias _currentPorts: mainForm.currentPorts




        onStatusChanged: {
            //console.log(currentStatus);
            _debugLog.insert(0, addMsg(newStatus));

            if (currentStatus !== true) {
                _btnDisconnect.enabled = false;
                _btnConnect.enabled = true;

            } else {
                _btnDisconnect.enabled = true;
                _btnConnect.enabled = false;
                backend.sendClicked("{ \"command\": \"getState\" }");

            }
        }
        onSomeMessage: {
            //Received result from server
            var data = msg;
            _debugLog.insert(0, addMsg(msg));
        }
        onSomeError: {
            _debugLog.insert(0, addMsg("Error! " + err));
            if (currentStatus !== true) {
                backend.disconnectClicked();
            }
            _btnConnect.enabled = true;
        }
        onStateChange: {
            machineState = JSON.parse(data)["state"];
            var color=machineState.tubes?"#05a018":"#013605";

            for (var i=0;i<positions.children.length;i++) {
                positions.children[i].color=color;
            }


            liText.text = lightLevel[machineState.light];

            //txtCycles.text = machineState.cycles;
            //txtHours.text = machineState.cycles / 5;

            if (machineState.vibrate) {
                saVibrateX.start();
                saVibrateY.start();
            } else {
                saVibrateX.stop();
                saVibrateY.stop();
            }

            _currentState.text = data.toString().replace("\n","").replace("\r","");

        }

        onConfigChange: {
            machineConfig = JSON.parse(data);
            _currentConfig.text = data.toString().replace("\n","").replace("\r","");
            if (!_cbBaudrate.model) _cbBaudrate.model= [ "9600" , "115200" ];

            for (var i=0;i<_cbBaudrate.model.length;i++) {
                if (_cbBaudrate.model[i] === machineConfig["config"]["baudrate"].toString()) {
                    _cbBaudrate.currentIndex=i;
                    break;
                }
            }
        }

        onPortInfo: {
            portInfo = JSON.parse(data);
            _currentPorts.text = data.toString().replace("\n","").replace("\r","");
            var opt = [];

            var p = portInfo["ports"];
            var idx=0
            for (var i=0;i<portInfo["ports"]["count"];i++) {
                opt.push(portInfo["ports"][i.toString()]);
                if (opt[i]===machineConfig["config"]["portname"]) idx=i;

            }
            _cbPorts.model = opt;
            _cbPorts.currentIndex = idx;

        }


    }


    MainForm {
        id: mainForm;
        anchors.fill: parent;

        btnConnect.onClicked: backend.connectClicked();
        btnDisconnect.onClicked: backend.disconnectClicked();
        btnVibrateOn.onClicked: backend.sendClicked("setVibrate", "1");
        btnVibrateOff.onClicked: backend.sendClicked("setVibrate", "0");
        btnTubesOn.onClicked: backend.sendClicked("setTubes", "1");
        btnTubesOff.onClicked: backend.sendClicked("setTubes", "0");
        btnLight0.onClicked: backend.sendClicked("setLight",0);
        btnLight1.onClicked: backend.sendClicked("setLight",1);
        btnLight2.onClicked: backend.sendClicked("setLight",2);
        btnLight3.onClicked: backend.sendClicked("setLight",3);
        btnCycleNew.onClicked: mainForm.newCycle();


        Rectangle {
            id:positionHolder
            width:parent.width/2
            height:width
            visible: false;
            anchors.right:parent.right
            anchors.margins: 10
            y:10

            Rectangle {
                id: positions
                width:parent.width
                height: parent.height
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



        Component.onCompleted: {
            var component;
            var sprite;
            var i,j;
            j=0;

            saVibrateX.stop();
            saVibrateY.stop();
            positionHolder.parent=posHolder;

            for (i=0;i<3;i++){
                component = Qt.createComponent("Position.qml");     //1st row
                sprite = component.createObject(positions, { "objectName": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 2 , "ycount" : -2 });
                j++;

            }
            for (i=0;i<4;i++){
                component = Qt.createComponent("Position.qml");     //2nd row
                sprite = component.createObject(positions, { "objectName": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 1,  "ycount" : -1 });
                j++;
            }
            for (i=0;i<5;i++){
                if (i!==2) {
                    component = Qt.createComponent("Position.qml");     //3rd row (center)
                    sprite = component.createObject(positions, { "objectName": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 0, "ycount" : 0 });
                    j++;
                }

            }
            for (i=0;i<4;i++){
                component = Qt.createComponent("Position.qml");     //4th row
                sprite = component.createObject(positions, { "objectName": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 1, "ycount" : 1 });
                j++;
            }
            for (i=0;i<3;i++){
                component = Qt.createComponent("Position.qml");     //5th row
                sprite = component.createObject(positions, { "objectName": "position"+j, "text": "EMPTY"+j, "xcount": i, "xoffset": 2, "ycount" : 2, });

                j++;

            }


            backend.connectClicked();
            positionHolder.visible = true;
            //ti.text = addMsg("Application started\n", false);
        }
        function setPosition(pos, serialnumber) {
            var i=0;
            backend.sendClicked("setPosition", "{pos:"+pos+", sn:"+serialnumber+"}");
        }

        function getPosition(pos) {
            var component;
            var sprite;
            component = Qt.createComponent("Tube.qml");
            sprite = component.createObject(posHolder, {"text1.text": pos });

            var i=0;

        }
        function newCycle() {
            var component;
            var sprite;
            component = Qt.createComponent("Cycle.qml");
            sprite = component.createObject(configHolder, {});
        }
        function newCycleExec(description, remarks) {
            //TODO: escape the texts and unescape them when importing back again.
            //Maybe here at mttfApplication, or better at mttfControl?

            //backend.sendClicked("newCycle", description + ":" + remarks);

            backend.sendClicked("{ \"command\":\"newCycle\", \"value\": { \"description\":\""+description + "\", \"remarks\":\"" + remarks + "\"}}");
            var i=0;
        }

    }

    function currentTime() {
        var now = new Date();
        var nowString = ("0" + now.getHours()).slice(-2) + ":"
                + ("0" + now.getMinutes()).slice(-2) + ":"
                + ("0" + now.getSeconds()).slice(-2);
        return nowString;
    }
    function addMsg(someText) {
        return "[" + currentTime() + "] " + someText + "\n";
    }






}


