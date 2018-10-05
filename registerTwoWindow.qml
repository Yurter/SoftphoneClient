import QtQuick 2.9
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QmlSpClient 1.0
import QmlSpUser 1.0
import "\QmlComponents"
import "\QmlComponents\\QmlPrimitiveComponents"

BlueWindow {
    id: root
    width:  480
    height: 585
    movable: true

    property string login: ""
    property string password: ""
    property string name: ""
    property string email: ""
    property string avatarPath: ""

    property QmlSpClient client

    Image {
        id: logo
        source: "qrc:/Pictures/logo.PNG"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
    }

    LabelEdit {
        id: nameEdit
        width: 400
        height: 60
        labelText: "ИМЯ"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 10
        onEditingFinished: {
            nameEdit.setContentСorrectness(nameIsValid(str));
        }
    }

    LabelEdit {
        id: emailEdit
        width: 400
        height: 60
        labelText: "ЭЛЕКТРОННАЯ ПОЧТА"
        placeholderText: "Укажу позже"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: nameEdit.bottom
        anchors.topMargin: 30
        onEditingFinished: {
            emailEdit.setContentСorrectness(emailIsValid(str));
        }
    }

    Item {
        Text {
            id: avatarLabel
            text: "АВАТАР"
            color: "white"
            font.family: "Ubuntu"
            font.pixelSize: 13
            anchors.top: parent.top
            anchors.left: parent.left
        }

        ImagePicker {
            id: imagePicker
            anchors.top: avatarLabel.bottom
            anchors.topMargin: 10
        }

        height: avatarLabel.height + 128
        width: 128
        anchors.left: emailEdit.left
        anchors.top: emailEdit.bottom
        anchors.topMargin: 30
    }

    QmlSpUser {
        id: newUser
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
                newUser.name = nameEdit.text;
                newUser.email = emailEdit.text;
                newUser.avatarUrl = imagePicker.path;
                client.signUp(newUser, login, password);
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
               var component = Qt.createComponent("registerOneWindow.qml");
               var window    = component.createObject(root, {"login": login, "passwordOne": password, "passwordTwo": password});
               window.show();
           }
        }
    }

    Connections {
        target: client
        onSuccessSignUp: {
            client.debugLog("[onSuccessSignUp]")
            client.signIn(login, password);
        }
        onFailSignUpBadLogin: {
            client.debugLog("[onFailSignUpBadLogin]");
        }
        onFailSignUpBadPassword: {
            client.debugLog("[onFailSignUpBadPassword]");
        }
        onSuccessSignIn: {
            client.debugLog("[onSuccessSignIn]");
            root.close();
            var component = Qt.createComponent("mainWindow.qml");
            var window    = component.createObject(root, {"client": client});
            window.show();
        }
        onFailSignIn: {
            client.debugLog("[onFailSignIn]");
        }
    }

    function nameIsValid(str) {
        return !((str.length > 0) && (str.length < 3));
    }

    function emailIsValid(str) {
        return !((str.length > 0) && (str.length < 3));
    }

    function allRight() {
        var result = (nameEdit.text.length > 2);
        return result;
    }
}
