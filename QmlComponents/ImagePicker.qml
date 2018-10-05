import QtQuick 2.9
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import "\QmlPrimitiveComponents"

Item {
    property string path: "qrc:/Pictures/defaultAvatar.png"

    Item {
        width:  128
        height: 128

        RoundImage {
            id: image
            anchors.fill: parent
            source: path
        }

        FileDialog {
            id: fileDialog
            title: "Choose file"
            nameFilters: [ "Image files (*.jpg *.png)" ]

            onAccepted: {
                image.layer.enabled = false
                image.source = fileDialog.fileUrl
                image.layer.enabled = true
                path = fileDialog.fileUrl
                path = path.replace("file:///", "")
            }
        }

        RoundImageButton {
            id: plusButton
            source: "qrc:/Pictures/plus.png"
            anchors.right: image.right
            anchors.bottom: image.bottom
            width: image.width / 3
            height: image.height / 3
            antialiasing: true
            onClicked: { fileDialog.open() }
        }
    }
}
