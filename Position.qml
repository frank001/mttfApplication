import QtQuick 2.0


Item {
    id: item
    property alias text: position.text

    width: parent.width/7

    //property alias parent:pHolder.parent

    property var size
    property int xcount: 0
    property int xoffset: 0
    property int ycount: 0
    property alias color: pHolder.color
    property alias positionMA: positionMA
    property alias objectName: pHolder.objectName
    //property alias width: pHolder.width
    //width:parent.width
    Rectangle {     //TODO: make this an object to include 18 times. almost done. Done.
        id:pHolder
        objectName: ""
        width: parent.width
        height: width
        color: "#013605"
        border.color: "black"
        border.width: width/4.5
        radius: width*.5
        x:(xcount * 1.5 * width) + xoffset/2*1.5*width;

        y:parent.parent.height/2 - height/2 + ycount * 1.5 * height

        signal getPosition(var posid)

        Text {
            id:position
            anchors.centerIn: parent
            color: "yellow"
            font.pointSize: parent.width/6
            text: "8030673"
            MouseArea {
                id:positionMA
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: pHolder.getPosition(pHolder.objectName)
                /*onClicked:  {
                    var i=0;
                    i++;
                    test1.visible=!test1.visible;
                    test1.positionNumber.text=parent.text;
                    test1.serialNumber.selectAll();
                    test1.serialNumber.focus=true;
                }*/
            }
        }

    }
    Component.onCompleted: {
        pHolder.getPosition.connect(mainForm.getPosition);
    }


}
