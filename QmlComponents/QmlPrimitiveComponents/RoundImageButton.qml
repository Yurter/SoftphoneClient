import QtQuick 2.9

Item {
    property alias source: roundImage.source

    id: root

    signal clicked

    RoundImage {
        id: roundImage
        anchors.fill: parent
        transform: Scale {
            id: imageScale
            origin.x: roundImage.width / 2
            origin.y: roundImage.height / 2
            xScale: 1
        }

        RoundMouseArea {
           id: roundMouseArea
           anchors.fill: roundImage
           onClicked: {
               root.clicked()
           }
           onPressed: {
               imageScale.xScale = 0.8
               imageScale.yScale = 0.8
           }
           onReleased: {
               imageScale.xScale = 1.0
               imageScale.yScale = 1.0
           }
           onMouseDisappeared: {
               imageScale.xScale = 1.0
               imageScale.yScale = 1.0
           }
        }
    }
}
