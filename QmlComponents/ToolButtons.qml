import QtQuick 2.0
import QtQuick.Controls 2.1
import "\QmlPrimitiveComponents"

Item {
    id: toolButtons

    property int unitSize: 30
    property int margin: 5

    width: unitSize * 4 + margin * 3
    height: unitSize

    signal toolsClicked
    signal minimizeClicked
    signal maximizeClicked
    signal normalizeClicked
    signal exitClicked

    property bool normalState: true

    RectangleImageButton {
        id: buttonSettings
        size: unitSize
        source: "/Pictures/settings.png"
        onClicked: toolButtons.toolsClicked()
    }
    RectangleImageButton {
        id: buttonMinimize
        size: unitSize
        source: "/Pictures/minimize.png"
        anchors.left: buttonSettings.right
        anchors.leftMargin: margin
        onClicked: toolButtons.minimizeClicked()
    }
    RectangleImageButton {
        id: buttonMaxNormal
        size: unitSize
        source: normalState ? "/Pictures/maximize.png" : "/Pictures/normalize.png"
        anchors.left: buttonMinimize.right
        anchors.leftMargin: margin
        onClicked: {
            if (normalState)
                toolButtons.maximizeClicked();
            else
                toolButtons.normalizeClicked();
            normalState = !normalState;
        }
    }
    RectangleImageButton {
        id: buttonExit
        size: unitSize
        source: "/Pictures/exit.png"
        anchors.left: buttonMaxNormal.right
        anchors.leftMargin: margin
        onClicked: toolButtons.exitClicked()
    }
}
