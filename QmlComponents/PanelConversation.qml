import QtQuick 2.0
import QtGraphicalEffects 1.0
import "\QmlPrimitiveComponents"
import QmlSpConversation 1.0
import QmlSpMessage 1.0

Item {
    id: root
    width: 250
    height: 50

    property QmlSpConversation conversation

    signal clicked(var conv)

    RoundedRectangle {
        id: background
        anchors.fill: parent
        itemRadius: 5
        itemColor: "#64B5F6"
        leftTopRounded: true
        rightTopRounded: true
        leftBottomRounded: true
        rightBottomRounded: true
    }

    transform: Scale {
        id: panelScale
        origin.x: parent.width / 2
        origin.y: parent.height / 2
    }

    RoundImage {
        id: conversationAvatar
        source: "file:///" + conversation.picture
        width: 40
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        Component.onCompleted: console.log("RoundImage", conversation.picture)
    }

    Text {
        id: conversationTitle
        text: conversation.title
        color: "white"
        font.family: "Ubuntu"
        anchors.left: conversationAvatar.right
        anchors.leftMargin: 5
        anchors.top: conversationAvatar.top
        anchors.topMargin: 2
        font.pixelSize: 13
    }

    RoundImage {
        id: lastSenderAvatar
        source: "file:///" + getLastMessageAvatar()
        width: 15
        height: 15
        anchors.left: conversationAvatar.right
        anchors.leftMargin: 5
        anchors.bottom: conversationAvatar.bottom
        anchors.bottomMargin: 2
    }

    Text {
        id: lastMessage
        text: getLastMessageText()
        color: "white"
        font.pixelSize: 13
        font.family: "Ubuntu"
        anchors.left: lastSenderAvatar.right
        anchors.leftMargin: 5
        anchors.bottom: conversationAvatar.bottom
        anchors.bottomMargin: 2
    }

    Text {
        id: lastTime
        text: getLastUpdate()
        color: "white"
        font.pixelSize: 12
        font.family: "Ubuntu"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
    }

    Rectangle {
        width: 16
        height: width
        color: "#2E73A8"
        radius: width / 2
        anchors.top: lastTime.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 8

        Text {
            id: unreadMesageCount
            text: conversation.messages.length
            color: "white"
            font.pixelSize: 10
            font.family: "Ubuntu"
            anchors.centerIn: parent
        }
    }

    RectangleMouseArea {
        id: rectangleMouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked(conversation)
        }
        onPressed: {
            panelScale.xScale = 0.99
            panelScale.yScale = 0.99
        }
        onReleased: {
            panelScale.xScale = 1.00
            panelScale.yScale = 1.00
        }
        onMouseDisappeared: {
            panelScale.xScale = 1.0
            panelScale.yScale = 1.0
        }
    }

    function getLastUpdate() {
        var lastIndex = conversation.messages.length - 1;
        return conversation.messages[lastIndex].time;
    }

    function getLastMessageText() {
        var lastIndex = conversation.messages.length - 1;
        return conversation.messages[lastIndex].textMessage;
    }

    function getLastMessageAvatar() {
        var lastIndex = conversation.messages.length - 1;
        console.log("getLastMessageAvatar", conversation.messages[lastIndex].senderAvatar)
        return conversation.messages[lastIndex].senderAvatar;
    }
}
