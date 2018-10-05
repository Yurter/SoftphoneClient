import QtQuick 2.9
import "\QmlPrimitiveComponents"

Item {
    id: root
    width: 265
    height: 50

    property int index: 1

    signal firendsPressed
    signal chatPressed

    readonly property string activeColor: "#42A5F5"
    readonly property string passiveColor: "#2196F3"

    Component.onCompleted: {
        switch (index) {
            case 0:
                root.firendsPressed()
            break;
            case 1:
                root.chatPressed()
            break;
            default:
                console.log("[ERROR] PanelListSwitcher: указан некорректный индекс.")
            break;
        }
    }

    RoundedRectangle {
        id: friends
        leftTopRounded: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width / 2
        itemColor: index == 0 ? activeColor : passiveColor
        itemRadius: 7
        Item {
            id: friendsButton
            anchors.centerIn: parent
            width: friendsImage.width + friendText.width + 5
            height: friendsImage.height
            Image {
                id: friendsImage
                anchors.verticalCenter: parent.verticalCenter
                width: root.height * 0.7
                height: root.height * 0.7
                source: "qrc:/Pictures/friends.png"
            }
            Text {
                id: friendText
                text: "Друзья"
                color: "white"
                font.family: "Ubuntu"
                font.pixelSize: 13
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: friendsImage.right
                anchors.leftMargin: 5
            }
        }
        transform: Scale {
            id: friendsScale
            origin.x: friends.width
            origin.y: friends.height
            xScale: index == 0 ? 1.0 : 0.9
            yScale: index == 0 ? 1.0 : 0.9
        }
        MouseArea {
            id: friendsMouseArea
            anchors.fill: parent
            onClicked: {
                index = 0
                friendsScale.xScale = 1.0
                friendsScale.yScale = 1.0
                chatScale.xScale = 0.9
                chatScale.yScale = 0.9
                root.firendsPressed()
            }
        }
    }

    RoundedRectangle {
        id: conversations
        rightTopRounded: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 50
        anchors.left: friends.right
        itemColor: index == 1 ? activeColor : passiveColor
        itemRadius: 7
        Item {
            id: chatButton
            anchors.centerIn: parent
            width: chatImage.width + chatText.width + 5
            height: chatImage.height
            Image {
                id: chatImage
                anchors.verticalCenter: parent.verticalCenter
                width: root.height * 0.7
                height: root.height * 0.7
                source: "qrc:/Pictures/chat.png"
            }
            Text {
                id: chatText
                text: "Беседы"
                color: "white"
                font.family: "Ubuntu"
                font.pixelSize: 13
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: chatImage.right
                anchors.leftMargin: 5
            }
        }
        transform: Scale {
            id: chatScale
            origin.x: 0
            origin.y: chatButton.height
            xScale: index == 1 ? 1.0 : 0.9
            yScale: index == 1 ? 1.0 : 0.9

        }
        MouseArea {
            id: chatMouseArea
            anchors.fill: parent
            onClicked: {
                index = 1
                friendsScale.xScale = 0.9
                friendsScale.yScale = 0.9
                chatScale.xScale = 1.0
                chatScale.yScale = 1.0
                root.chatPressed()
            }
        }
    }
}
