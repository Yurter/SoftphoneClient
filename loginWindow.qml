import QtQuick 2.9
import QtQml 2.2
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import "\QmlComponents"
import "\QmlComponents\\QmlPrimitiveComponents"
import QmlSpClient 1.0
import QmlSpUser 1.0
import QmlSpMessage 1.0
import QmlSpConversation 1.0

BlueWindow {
    id: root
    width:   480
    height:  420
    movable: true

    readonly property string errorFailSignIn: "Не удается войти"
    readonly property string   serverAddress: "46.173.213.161"
    readonly property int         serverPort: 1067

    QmlSpClient {
        id: client
        onSuccessSignIn: {
            if (root.active) {
                root.close();
                var component = Qt.createComponent("mainWindow.qml");
                var window    = component.createObject(root, {"client": client});
                window.show();
            }
        }
        onFailSignIn: {
            password.error = errorFailSignIn;
        }
        Component.onCompleted: {
            client.setServerAddress(serverAddress);
            client.setServerPort(serverPort);
            client.start();
        }
    }

    Image {
        id: logo
        source: "qrc:/Pictures/logo.PNG"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
    }

    LabelEdit {
        id: login
        width: 400
        height: 60
        labelText: "ЛОГИН"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 20
    }

    LabelEdit {
        id: password
        width: 400
        height: 60
        labelText: "ПАРОЛЬ"
        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: login.bottom
        anchors.topMargin: 20
        passwordMode: true
    }

    Text {
        id: forgetPassword
        text: "Забыли пароль?"
        anchors.left: password.left
        anchors.leftMargin: 1
        anchors.top: password.bottom
        anchors.topMargin: 5
        font.underline: mouseAreaFP.containsMouse ? true : false
        font.pixelSize: 13
        color: "white"

        MouseArea {
           id: mouseAreaFP
           anchors.fill: parent
           hoverEnabled: true
           onClicked: Qt.quit()
       }
    }

    Button {
        id: buttonLogin
        text: "Войти"
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
            text: buttonLogin.text
            font: buttonLogin.font
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
                password.error = "";
                client.signIn(login.text, password.text);
            }
        }
    }

    Text {
        id: register
        text: "Зарегистрироваться"
        anchors.left: buttonLogin.left
        anchors.leftMargin: 1
        anchors.top: buttonLogin.bottom
        anchors.topMargin: 5
        font.underline: mouseAreaREG.containsMouse ? true : false
        font.pixelSize: 13
        color: "white"

        MouseArea {
           id: mouseAreaREG
           anchors.fill: parent
           hoverEnabled: true
           onClicked: {
               root.close();
               var component = Qt.createComponent("registerOneWindow.qml");
               var window    = component.createObject(root, {"client": client});
               window.show();
           }
        }
    }

    Text {
        id: exit
        text: "Выйти"
        anchors.right: buttonLogin.right
        anchors.rightMargin: 1
        anchors.top: buttonLogin.bottom
        anchors.topMargin: 5
        font.underline: mouseAreaEXIT.containsMouse ? true : false
        font.pixelSize: 13
        color: "white"

        MouseArea {
           id: mouseAreaEXIT
           anchors.fill: parent
           hoverEnabled: true
           onClicked: root.close()
        }
    }

    function allRight() {
        var result = (login.text.length > 2) && (password.text.length > 2);
        return result;
    }
}

