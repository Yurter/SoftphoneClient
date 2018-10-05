import QtQuick 2.0

Item {
    id: root

    property alias mouseX: mouseArea.mouseX
    property alias mouseY: mouseArea.mouseY

    property bool containsMouse: {
        var isWithinOurRadius = ( mouseY < height ) && ( mouseX < width )

        if (isWithinOurRadius)
            root.mouseAppeared()
        else
            root.mouseDisappeared()

        return isWithinOurRadius;
    }

    signal mouseAppeared
    signal mouseDisappeared
    signal clicked
    signal pressed
    signal released

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked:  if (root.containsMouse) root.clicked()
        onPressed:  if (root.containsMouse) root.pressed()
        onReleased: if (root.containsMouse) root.released()
    }
}
