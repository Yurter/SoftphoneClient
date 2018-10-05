import QtQuick 2.0

Item {
    property color itemColor: "white"
    property int   itemRadius: 0

    property bool leftTopRounded: false
    property bool rightTopRounded: false
    property bool leftBottomRounded: false
    property bool rightBottomRounded: false

    property alias gradient: mainRect.gradient

    Rectangle {
        id: mainRect
        anchors.fill: parent
        color: itemColor
        radius: itemRadius
        Rectangle {
            id: leftTopRect
            anchors.left: parent.left
            anchors.top: parent.top
            color: itemColor
            width: itemRadius
            height: itemRadius
            visible: !leftTopRounded
        }
        Rectangle {
            id: rightTopRect
            anchors.right: parent.right
            anchors.top: parent.top
            color: itemColor
            width: itemRadius
            height: itemRadius
            visible: !rightTopRounded
        }
        Rectangle {
            id: leftBottomRect
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            color: itemColor
            width: itemRadius
            height: itemRadius
            visible: !leftBottomRounded
        }
        Rectangle {
            id: rightBottomRect
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: itemColor
            width: itemRadius
            height: itemRadius
            visible: !rightBottomRounded
        }
    }
}
