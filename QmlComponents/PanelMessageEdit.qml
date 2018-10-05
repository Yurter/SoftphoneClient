import QtQuick 2.9
import "\QmlPrimitiveComponents"
import QmlSpMessage 1.0
import QtQuick.Controls 1.4

Item {
    id: root
    signal messageReady(QmlSpMessage spMessage)

    QmlSpMessage {
        id: message
    }

    height: 33

    RectangleImageButton {
        id: attachmentButton
        size: parent.height - 4
        source: "/Pictures/attachment.png"
        onClicked: {
            console.log("Нажата кнопка \"Добавить вложения к соообщению\"")
        }
        anchors {
            left: parent.left
            leftMargin: 2
            bottom: parent.bottom
            bottomMargin: 2
        }
    }

    Edit {
        id: textEdit
        placeholderText: "Напишите сообщение..."
        anchors {
            left: attachmentButton.right
            leftMargin: 2
            top: parent.top
            right: parent.right
            rightMargin: 2
            bottom: parent.bottom
            bottomMargin: 2
        }
        onEnterPressed: {
            if (str !== "") {
                message.textMessage = str
                root.messageReady(message)
                textEdit.clear()
            }
        }
    }
}
