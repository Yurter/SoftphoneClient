import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root

    property alias text: edit.text
    property alias labelText: label.text
    property alias placeholderText: edit.placeholderText
    property bool  contentIsCorrect: true
    property alias error: errorText.text

    property bool passwordMode: false
    property bool shiftIsPressed: false

    Keys.onPressed: {
        if(event.key === Qt.Key_Shift  ) {
            shiftIsPressed = true;
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Shift)
            shiftIsPressed = false;
    }

    signal editingFinished(var str)
    signal textChangedQML(var str)
    signal enterPressed(var str)

    Text {
        id: label
        color: "white"
        font.family: "Ubuntu"
        font.pixelSize: 13
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 1
        Component.onCompleted: {
            if (text.length === 0) {
                label.height = 0;
            }
        }
    }

    TextField {
        id: edit
        anchors.top: label.bottom
        anchors.topMargin: label.height === 0 ? 0 : 6
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
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
        onTextChanged: {
            root.textChangedQML(text)

            if (echoMode == TextInput.Password) {
                var letter = text[text.length - 1];
                if (isUpperLock(shiftIsPressed, letter))
                    error = "CUPS LOCK"
                else
                    if (text == "") error = ""
            }
        }
        Keys.onReturnPressed: {
            root.enterPressed(edit.text)
        }
        onEditingFinished: root.editingFinished(text)
        echoMode: passwordMode ? TextInput.Password : TextInput.Normal
    }

    Rectangle {
        anchors.fill: errorText
        anchors.leftMargin: -4
        anchors.rightMargin: -4
        anchors.bottomMargin: -2
        color: "red"
        radius: 4
        visible: errorText.visible
    }

    Text {
        id: errorText
        text: ""
        color: "white"
        font.pixelSize: 12
        font.family: "Ubuntu"
        horizontalAlignment: Text.AlignRight
        anchors.top: edit.bottom
        anchors.right: edit.right
        anchors.rightMargin: 6
        anchors.topMargin: 2
        visible: text.length > 0
    }

    function setContentСorrectness(value) {
        contentIsCorrect = value
    }

    function clear() {
        edit.text = ""
    }

    function isalpha(letter) {
        var alpha = String("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
        var i;
        for(i in alpha )
            if(letter === alpha[i])
                return true;
        return false;
    }

    function isLowerCaseChar(letter) {
        var lowcases = String("abcdefghijklmnopqrstuvwxyz");
        for(var i in lowcases) {
            if(letter === lowcases[i]){
                return true;
            }
        }
        return false;
    }

    function isUpperLock(shift, letter) {
        if (!isalpha(letter)) return false;
        if (shift) {
            if (isLowerCaseChar(letter))
                return true;
            else
                return false;
        } else {
            if (isLowerCaseChar(letter))
                return false;
            else
                return true;
        }
    }
}
