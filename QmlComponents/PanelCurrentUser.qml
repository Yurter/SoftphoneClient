import QtQuick 2.0
import "\QmlPrimitiveComponents"
import QmlSpUser 1.0

Item {
    width: 265
    height: 70

    property QmlSpUser user

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 5
        color: "#42A5F5"
    }

    RoundImage {
        id: currentUserAvatar
        source: "file:///" + user.avatarUrl
        size: 60
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    Text {
        id: currentUserName
        text: user.name
        color: "white"
        font.family: "Ubuntu"
        font.pixelSize: 16
        anchors.left: currentUserAvatar.right
        anchors.leftMargin: 10
        anchors.verticalCenter: currentUserAvatar.verticalCenter
    }

    Rectangle {
        id: status
        width: 10
        height: 10
        radius: 5
        color: statusColor()
        anchors.top: currentUserName.bottom
        anchors.topMargin: 5
        anchors.left: currentUserName.left
    }

    function statusColor() {
        switch (user.status){
        case 0 :
            return "#70F700"
        case 2 :
            return "yellow"
        case 3 :
            return "red"
        case 4 :
            return "gray"
        default :
            return "black"
        }
    }
}
