import QtQuick 2.9
import "\QmlPrimitiveComponents"

Item {
    property alias titleText: title.text
    property string avatar: ""

    anchors.left: parent.left
    anchors.right: parent.right
    height: 50

    RoundedRectangle {
        anchors.fill: parent
        itemColor: "#1565C0"
        itemRadius: 5
        leftTopRounded: true
        rightTopRounded: true
    }

    Text {
        id: title
        text: "Название беседы"
        color: "white"
        font.family: "Ubuntu"
        font.pixelSize: 13
        anchors.centerIn: parent
    }

    RectangleImageButton {
        id: buttonSettings
        size: 30
        source: "/Pictures/settings.png"
        anchors.right: conversationAvatar.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            console.log("Кнопка настройки беседы")
        }
    }

    RoundImage {
        id: conversationAvatar
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        size: 30
        source: "file:///" + avatar
    }
}
