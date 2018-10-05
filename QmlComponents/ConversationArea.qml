import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QmlSpMessage 1.0

Item {
    id: root
    property bool enable: false

    signal messageReady(QmlSpMessage message)

    Item {
        anchors.fill: parent
        visible: enable
        Rectangle {
            id: background
            anchors.fill: parent
            radius: 5
            color: "#64B5F6"
        }

        ConversationTitle {
            id: conversationTitle
        }

        Component {
            id: messageDelegate
            PanelMessage {
                message: parentMessage
                Component.onCompleted: {
                    if (message.isMine) {
                        anchors.right = parent.right
                        anchors.rightMargin = 10
                    } else {
                        anchors.left = parent.left
                        anchors.leftMargin = 10
                    }
                }
            }
        }

        Item {
            id: contentArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: conversationTitle.bottom
            anchors.topMargin: 10
            anchors.bottom: editPanel.top
            anchors.bottomMargin: 10
            ListView {
                id: listView
                anchors.fill: parent
                orientation: ListView.Vertical
                delegate: messageDelegate
                spacing: 5
                model: ListModel { id: listModel }
                ScrollBar.vertical: ScrollBar {}
                clip: true
            }
        }

        PanelMessageEdit {
            id: editPanel
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onMessageReady: {
                spMessage.conversationId = conversationId;
                root.messageReady(spMessage);
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#30000000"
        visible: !enable
        Text {
            text: "Выберите беседу"
            color: "white"
            font.family: "Ubuntu"
            font.pixelSize: 13
            anchors.centerIn: parent
        }
    }

    property int conversationId: -1

    function setConversation(conversation) {
        listModel.clear()
        conversationId = conversation.id
        var messages = conversation.messages
        var len = messages.length
        for (var i = 0; i < len; i++) {
            listModel.append({"parentMessage": messages[i]})
        }
        conversationTitle.titleText = conversation.title;
        conversationTitle.avatar = conversation.picture;
    }
}

