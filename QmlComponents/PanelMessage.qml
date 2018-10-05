import QtQuick 2.9
import QtQuick.Controls 2.1
import "\QmlPrimitiveComponents"
import QmlSpMessage 1.0
import QtGraphicalEffects 1.0

Item {
    id: root
    width:  minimumWidth()//200//parent.width
    height: minimumHeight() + 10

    property int imagesHeight: 0

    property QmlSpMessage message

    property alias leftTopRounded: background.leftTopRounded
    property alias rightTopRounded: background.rightTopRounded
    property alias leftBottomRounded: background.leftBottomRounded
    property alias rightBottomRounded: background.rightBottomRounded

    RoundedRectangle {
        id: background
        anchors.fill: parent
        itemRadius: 10
        itemColor: "#90CAF9"
        leftTopRounded: true
        rightTopRounded: true
        leftBottomRounded: message.isMine
        rightBottomRounded: !message.isMine
    }

    Item {
        id: messageArea
        anchors {
            fill: parent
            topMargin: 5
            bottomMargin: 5
            leftMargin: 5
            rightMargin: 5
        }

        RoundImage {
            id: senderAvatar
            size: 40
            source: "file:///" + message.senderAvatar
        }

        Component.onCompleted: {
            message.imagesUrl.forEach(function(item, i, arr) {
                imagesModel.append({"imageSource": item})
            });

        }

        Item {
            id: payload
            anchors.left: senderAvatar.right
            anchors.leftMargin: 5
            width: (senderName.width + time.width + 5) > textMessage.width ? (senderName.width + time.width + 5) : textMessage.width
            height: senderName.height + textMessage.height + imageListView.height + 5

            Text {
                id: senderName
                text: message.senderName
                color: "#0D47A1"
                font.pixelSize: 14
                font.family: "Ubuntu"
            }

            Text {
                id: time
                text: message.time
                color: "white"
                font.pixelSize: 12
                font.family: "Ubuntu"
                anchors.left: senderName.right
                anchors.leftMargin: 5
                anchors.verticalCenter: senderName.verticalCenter
            }

            Text {
                id: textMessage
                text: message.textMessage
                color: "white"
                font.family: "Ubuntu"
                font.pixelSize: 13
                anchors.top: senderName.bottom
            }

            ListModel { id: imagesModel }

            Component {
                id: imageDelegate
                RoundedImage {
                    id: imageComponent
                    source: "file:///" + imageSource
                    width: sourceSize.width > parent.width ? parent.width : sourceSize.width
                    height: sourceSize.height * (width / sourceSize.width)
                    radius: 3
                    Component.onCompleted: imagesHeight = imagesHeight + imageComponent.height
                }
            }

            ListView {
                id: imageListView
                width: 250
                height: imagesHeight + (imageListView.count - 1) * spacing
                anchors.left: parent.left
                anchors.top: textMessage.bottom
                anchors.topMargin: 5
                orientation: ListView.Vertical
                delegate: imageDelegate
                spacing: 2
                model: imagesModel
            }
        }
    }

    function addImage(image){
        imagesModel.append(image)
    }

    function minimumHeight() {
        var heightOne = senderAvatar.height
        var heightTwo = payload.height

        if (heightOne > heightTwo)
            return heightOne
        else
            return heightTwo
    }

    function minimumWidth() {
        return senderAvatar.width + payload.width + 15;
    }
}
