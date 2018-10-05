import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    property alias placeholderText: textField.placeholderText
    property bool contentIsCorrect: true

    signal editingFinished(var str)
    signal textChanged(var str)
    signal enterPressed(var str)

    TextField {
        id: textField
        anchors.fill: parent
        style: TextFieldStyle {
            textColor: "#030C3A"
            background: Rectangle {
                radius: 4
                border.color: contentIsCorrect ? "#2785AA" : "red"
                border.width: 2
            }
            font {
                pointSize: 16
            }
        }
        Keys.onReturnPressed: {
            root.enterPressed(textField.text)
        }
        onTextChanged: root.textChanged(text)
        onEditingFinished: root.editingFinished(text)
    }

    function clear() {
        textField.text = ""
    }
}
