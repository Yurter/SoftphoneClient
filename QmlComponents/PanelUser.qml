import QtQuick 2.0
import QtGraphicalEffects 1.0
import "\QmlPrimitiveComponents"
import QmlSpUser 1.0

Item {
    id: root
    width: 250
    height: 50

    property QmlSpUser user

    signal addPressed(QmlSpUser spUser)
    signal removePressed(QmlSpUser spUser)
    signal blockPressed(QmlSpUser spUser)
    signal noPressed(QmlSpUser spUser)
    signal yesPressed(QmlSpUser spUser)

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
        id: userAvatar
        source: "file:///" + user.avatarUrl
        width: 40
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
    }

    Text {
        id: userName
        text: user.name
        color: "white"
        font.family: "Ubuntu"
        anchors.left: userAvatar.right
        anchors.leftMargin: 5
        anchors.top: userAvatar.top
        anchors.topMargin: 2
        font.pixelSize: 13
    }

    Text {
        id: userStatus
        text: getStatusText()
        color: getStatusColor()
        font.family: "Ubuntu"
        anchors.left: userAvatar.right
        anchors.leftMargin: 5
        anchors.top: userName.bottom
        anchors.topMargin: 2
        font.pixelSize: 11
    }

    RectangleMouseArea {
        id: rectangleMouseArea
        anchors.fill: parent
        onClicked: {
            console.log(userName.text)
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

    RectangleImageButton {
        id: actionButton
        size: 25
        source: actionButtonSource()
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 5
        property int type
        onClicked: {
            switch (type) {
            case 0 :
                root.addPressed(user)
                break
            case 1 :
                root.removePressed(user)
                break
            case 2 :
                root.blockPressed(user)
                break
            case 3 :
                root.yesPressed(user)
                break
            default:
                break
            }
        }
    }

    RectangleImageButton {
        id: extraButton
        size: 25
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: actionButton.left
        anchors.rightMargin: 5
        visible: false
        onClicked: {
            root.noPressed(user)
        }
    }

    function actionButtonSource() {
        switch (user.relationship.first){
        case 0 :
            actionButton.type = 0
            return "qrc:/Pictures/addFriend.png"
        case 1 :
            extraButton.visible = true
            extraButton.source = "qrc:/Pictures/no.png"
            actionButton.type = 3
            return "qrc:/Pictures/yes.png"
        case 2 :
            actionButton.type = 1
            return "qrc:/Pictures/removeFriend.png"
        default :
            return ""
        }
    }

    function getStatusText() {
        switch (user.status) {
        case 0:
            return "Online"
        case 1:
            return "Offline"
        case 2:
            return "Away"
        case 3:
            return "DoNotDisturb"
        case 5:
            return "Deleted"
        default:
            return "Error"
        }
    }

    function getStatusColor() {
        switch (user.status) {
        case 0:
            return "#70F700"
        case 1:
            return "gray"
        case 2:
            return "yellow"
        case 3:
            return "red"
        case 5:
            return "white"
        default:
            return "black"
        }
    }
}
