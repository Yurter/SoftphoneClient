import QtQuick 2.9
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: root

    property bool movable: false

    visible: true
    flags: Qt.FramelessWindowHint |
           Qt.WindowMinimizeButtonHint |
           Qt.Window
    width:  1024
    height: 576

    color: "#1976D2"

    MouseArea {
        anchors.fill: parent;
        property point clickPos

        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            if (movable) {
                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                var new_x = root.x + delta.x
                var new_y = root.y + delta.y
                if (root.visibility === root.Maximized)
                    root.visibility = root.Windowed
                root.x = new_x
                root.y = new_y
            }
        }
    }
}
