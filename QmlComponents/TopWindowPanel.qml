import QtQuick 2.9

Item {
    id: root
    width: parent.width
    height: toolButtons.height + 10

    signal newPosition(var new_x, var new_y)

    MouseArea {
        anchors.fill: parent;
        property point clickPos

        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            var new_x = parent.x + delta.x
            var new_y = parent.y + delta.y
            root.newPosition(new_x,new_y)
        }
    }

    signal toolsClicked
    signal minimizeClicked
    signal maximizeClicked
    signal normalizeClicked
    signal exitClicked

    Rectangle {
        anchors.fill: parent
        color: "#0D47A1"
    }

    Image {
        width: 63
        height: 30
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/Pictures/logo.PNG"
    }

    ToolButtons {
        id: toolButtons
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        onToolsClicked:     root.toolsClicked()
        onMinimizeClicked:  root.minimizeClicked()
        onMaximizeClicked:  root.maximizeClicked()
        onNormalizeClicked: root.normalizeClicked()
        onExitClicked:      root.exitClicked()
    }
}
