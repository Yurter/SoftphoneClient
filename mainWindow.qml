import QtQuick 2.9
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import "\QmlComponents"
import "\QmlComponents\\QmlPrimitiveComponents"
import QmlSpClient 1.0
import QmlSpUser 1.0
import QmlSpMessage 1.0
import QmlSpConversation 1.0

BlueWindow {
    id: root
    width:  940
    height: 780

    property QmlSpClient client

    Connections {
        target: client
        onQmlFriedListUpdated:          { panelList.setUserList(friendList) }
        onQmlConversationListUpdated:   { panelList.setConversationList(conversationList) }
        onQmlConversationUpdate:        { panelList.updateConversation(conversation) }
        onQmlSearchUserResultReceived:  { panelList.setFoundUserList(userList) }
    }

    Component.onCompleted: {
        currenUserPanel.user = client.currentUser();
        client.startCheckEvents(1000);
        client.requestFriendList();
        client.requestConversationList();
    }

    TopWindowPanel {
        id: topWindowPanel

        onToolsClicked: {
            console.log("Кнопка общих настроек");
        }
        onMinimizeClicked: {
            root.showMinimized();
        }
        onMaximizeClicked: {
            root.showMaximized()
        }
        onNormalizeClicked: {
            root.showNormal();
        }
        onExitClicked: {
            root.close();
        }
        onNewPosition: {
            root.x = root.x + new_x;
            root.y = root.y + new_y;
        }
    }

    PanelCurrentUser {
        id: currenUserPanel
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: topWindowPanel.bottom
        anchors.topMargin: 10
    }

    PanelList {
        id: panelList
        width: 265
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: currenUserPanel.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        onSearchUser: {
            client.findUserByName(name)
        }
        onSearchConversation: {
            //
        }
        onActiveConversationChanged: {
            conversationArea.enable = true;
            conversationArea.setConversation(conver);
        }

        onAddPressed:    client.addUserToFiends(spUser)
        onRemovePressed: client.removeUserFromFriends(spUser)
        onBlockPressed:  client.blockUser(spUser)
        onNoPressed:     client.removeUserFromFriends(spUser)
        onYesPressed:    client.addUserToFiends(spUser)
    }

    ConversationArea {
        id: conversationArea
        anchors.left: panelList.right
        anchors.leftMargin: 20
        anchors.top: topWindowPanel.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        onMessageReady: {
            message.senderId = client.currentUser().id;
            client.sendMessage(message);
        }
    }
}
