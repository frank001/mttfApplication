import QtQuick 2.4

CycleForm {
    id: item
    signal newCycle(var description, var remarks);

    button.onClicked: {
        newCycle(tbDescription.text, taRemarks.text)
        cycleItem.destroy();
    }
    cycleItemMA.onClicked: cycleItem.destroy();

    Component.onCompleted: {
        //tubeItem.setPosition.connect(mainForm.setPosition);
        item.newCycle.connect(mainForm.newCycleExec);
        tbDescription.forceActiveFocus();
        tbDescription.selectAll();

    }
}
