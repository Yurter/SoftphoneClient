import QtQuick 2.9
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import "\QmlComponents\\QmlPrimitiveComponents"
import QmlSpClient 1.0

BlueWindow {
    id: root
    width:  480
    height: 500
    movable: true

    readonly property string errorLoginAlreadyTaken:    "Этот логин уже используется другим пользователем"
    readonly property string errorLoginInvalid:         "Логин должен содержать не менее трех символов"
    readonly property string errorPasswordInvalid:      "Пароль должен содержать не менее трех символов"
    readonly property string errorPasswordMatch:        "Пароли не совпадают"

    property alias login: loginEdit.text
    property alias passwordOne: passwordOneEdit.text
    property alias passwordTwo: passwordTwoEdit.text

    property QmlSpClient client

    Image {
        id: logo
        source: "qrc:/Pictures/logo.PNG"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
    }

    LabelEdit {
        id: loginEdit
        width: 400
        height: 60
        labelText: "ЛОГИН"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 10
        onEditingFinished: {
            var valid = loginIsValid(str);
            loginEdit.setContentСorrectness(valid);
            error = valid ? "" : errorLoginInvalid;
        }
    }

    LabelEdit {
        id: passwordOneEdit
        width: 400
        height: 60
        labelText: "ПАРОЛЬ"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: loginEdit.bottom
        anchors.topMargin: 30
        onEditingFinished: {
            var valid = passwordIsValid(str);
            passwordOneEdit.setContentСorrectness(valid);
            error = valid ? "" : errorPasswordInvalid;
        }
        passwordMode: true
    }

    LabelEdit {
        id: passwordTwoEdit
        width: 400
        height: 60
        labelText: "ПОВТОРИТЕ ПАРОЛЬ"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: passwordOneEdit.bottom
        anchors.topMargin: 30
        onTextChangedQML: {
            var valid = passwordIsValid(str);
            var passwordMatch = passwordOneEdit.text == passwordTwoEdit.text;
            passwordTwoEdit.setContentСorrectness(valid && passwordMatch);
            error = passwordMatch ? "" : errorPasswordMatch;
        }
        passwordMode: true
    }

    Button {
        id: buttonContinue
        text: "Продолжить"
        width: 400
        height: 40
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        enabled: allRight()
        Rectangle {
            anchors.fill: parent
            color: "#40000000"
            visible: !allRight()
            radius: backgr.radius
        }
        background: Rectangle {
            id: backgr
            color: mouseArea.pressed ? "#5f9bff" : ( mouseArea.containsMouse ? "#72A7FD" : "#82B1FF" )
            border.color: "#5E96EA"
            border.width: 1
            radius: 4
        }
        font {
            pointSize: 12
            family: "Ubuntu"
        }
        contentItem: Text {
            text: buttonContinue.text
            font: buttonContinue.font
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                focus = true
                if (allRight()) {
                    root.close();
                    var component = Qt.createComponent("registerTwoWindow.qml");
                    var window    = component.createObject(root, {"login": login, "password": passwordOne, "client": client});
                    window.show();
                }
            }
        }
    }

    Text {
        id: exit
        text: "Назад"
        anchors.horizontalCenter: buttonContinue.horizontalCenter
        anchors.top: buttonContinue.bottom
        anchors.topMargin: 5
        font.underline: mouseAreaBack.containsMouse ? true : false
        font.pixelSize: 13
        color: "white"

        MouseArea {
           id: mouseAreaBack
           anchors.fill: parent
           hoverEnabled: true
           onClicked: {
               root.close();
               var component = Qt.createComponent("loginWindow.qml");
               var window    = component.createObject(root);
               window.show();
           }
        }
    }

    function loginIsValid(str) {
        return str.length > 2;
    }

    function passwordIsValid(str) {
        return str.length > 2;
    }

    function allRight() {
        var result = loginEdit.contentIsCorrect
                        && passwordOneEdit.contentIsCorrect
                        && passwordTwoEdit.contentIsCorrect
                        && loginEdit.text.length > 0
                        && passwordOneEdit.text.length > 0
                        && passwordTwoEdit.text.length > 0
                        && passwordOneEdit.text == passwordTwoEdit.text;
        return result;
    }
}
