import QtQuick 2.9

Item {
    id: root

    property int size
    property alias source: image.source

    width:  size
    height: size

    signal clicked

    Image {
        id: image
        anchors.fill: parent
        transform: Scale {
            id: imageScale
            origin.x: image.width / 2
            origin.y: image.height / 2
            xScale: 1
        }

        RectangleMouseArea{
           id: rectangleMouseArea
           anchors.fill: image
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
