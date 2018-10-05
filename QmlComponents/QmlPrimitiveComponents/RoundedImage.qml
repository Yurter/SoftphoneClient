import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root
    property alias source: image.source
    property alias radius: mask.radius
    property alias sourceSize: image.sourceSize

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
        anchors.fill: image
        visible: false
    }
}
