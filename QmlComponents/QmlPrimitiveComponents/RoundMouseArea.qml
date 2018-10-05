import QtQuick 2.0

Item {
    id: root

    property alias mouseX: mouseArea.mouseX
    property alias mouseY: mouseArea.mouseY

    property bool containsMouse: {
        var x1 = width / 2;
        var y1 = height / 2;
        var x2 = mouseX;
        var y2 = mouseY;
        var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
        var radiusSquared = Math.pow(Math.min(width, height) / 2, 2);
        var isWithinOurRadius = distanceFromCenter < radiusSquared;
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
