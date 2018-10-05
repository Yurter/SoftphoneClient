import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QmlSpUser 1.0
import QmlSpConversation 1.0
import "QmlPrimitiveComponents"

Item {
    id: root

    signal searchUser(var name)
    signal searchConversation(var conversationTitle)
    signal activeConversationChanged(var conver)

    signal addPressed(QmlSpUser spUser)
    signal removePressed(QmlSpUser spUser)
    signal blockPressed(QmlSpUser spUser)
    signal noPressed(QmlSpUser spUser)
    signal yesPressed(QmlSpUser spUser)

    RoundedRectangle {
        id: background
        anchors.top: switcher.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        itemRadius: 5
        itemColor: "#42A5F5"
        leftBottomRounded: true
        rightBottomRounded: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#42A5F5" }
            GradientStop { position: 1.0; color: "#2196F3" }
        }
    }

    PanelListSwitcher {
        id: switcher
        onFirendsPressed: {
            listView.model = userPanelModel
            listView.delegate = userPanelDelegate
        }
        onChatPressed: {
            listView.model = conversationPanelModel
            listView.delegate = conversationPanelDelegate
        }
    }

    LabelEdit {
        id: searchLine
        width: switcher.width
        height: 30
        anchors.top: switcher.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors {
            leftMargin: 2
            rightMargin: 2
            topMargin: 2
            bottomMargin: 2
        }
        placeholderText: "Поиск..."
        onTextChangedQML: {
            if (str.length > 0) {
                switch (switcher.index) {
                    case 0:
                        root.searchUser(str);
                    break;
                    case 1:
                        root.searchConversation(str);
                    break;
                }
            } else {
                searchCanceled();
            }
        }
    }

    ListModel { id: userPanelModel }
    ListModel { id: conversationPanelModel }
    ListModel { id: foundUserModel }
    ListModel { id: foundConversationModel }

    Component {
        id: userPanelDelegate
        PanelUser {
            id: userPanel
            user: userUser
            onAddPressed:    root.addPressed(spUser);
            onRemovePressed: root.removePressed(spUser);
            onBlockPressed:  root.blockPressed(spUser);
            onNoPressed:     root.noPressed(spUser);
            onYesPressed:    root.yesPressed(spUser);
        }
    }

    Component {
        id: conversationPanelDelegate
        PanelConversation {
            id: conversationPanel
            conversation: convConv
            onClicked: {
                root.activeConversationChanged(conv);
            }
        }
    }

    ListView {
        id: listView
        anchors.top: searchLine.bottom
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
    }

    function setUserList(userList) {
        userPanelModel.clear();
        var len = userList.length;
        for (var i = 0; i < len; i++) {
            userPanelModel.append({"userUser": userList[i]});
        }
    }

    function setConversationList(conversationList) {
        conversationPanelModel.clear()
        var len = conversationList.length
        for (var i = 0; i < len; i++) {
            conversationPanelModel.append({"convConv": conversationList[i]})
        }
    }

    function setFoundUserList(userList) {
        foundUserModel.clear()
        var len = userList.length
        for (var i = 0; i < len; i++) {
            foundUserModel.append({"userUser": userList[i]})
        }
        listView.model = foundUserModel
        listView.delegate = userPanelDelegate
    }

    function setFoundConversationList(conversationList) {
        foundConversationModel.clear()
        var len = conversationList.length
        for (var i = 0; i < len; i++) {
            foundConversationModel.append({"convConv": conversationList[i]})
        }
        listView.model = foundConversationModel
        listView.delegate = conversationPanelDelegate
    }

    function searchCanceled() {
        switch (switcher.index) {
            case 0:
                listView.model = userPanelModel
                listView.delegate = userPanelDelegate
            break;
            case 1:
                listView.model = conversationPanelModel
                listView.delegate = conversationPanelDelegate
            break;
        }
    }

    function updateConversation(newConversation) {
        var len = conversationPanelModel.count
        var targerId = newConversation.id
        for (var i = 0; i < len; i++) {
            if (conversationPanelModel.get(i).convConv.id === targerId) {
                conversationPanelModel.get(i).convConv = newConversation
                root.activeConversationChanged(newConversation)
                break
            }
        }
    }
}
