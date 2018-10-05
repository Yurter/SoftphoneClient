import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property int size
    property alias source: image.source

    width:  size
    height: size

    Image {
        id: image
        anchors.fill: parent
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: width / 2
        visible: false
    }
}
