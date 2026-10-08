import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property int sessionIndex: (sessionModel.lastIndex ?? 0)

    color: "#0a0a0c"

    // scanlines subtis (CRT opcional — sempre discretas)
    Repeater {
        model: Math.floor(root.height / 4)
        Rectangle {
            y: index * 4
            width: root.width
            height: 1
            color: "#ffffff"
            opacity: 0.015
        }
    }

    // vinheta vermelha profunda (sem QtGraphicalEffects — só QML puro)
    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 1.4
        height: parent.height * 1.4
        radius: width / 2
        color: "#c1121f"
        opacity: 0.05
    }

    Column {
        anchors.centerIn: parent
        spacing: 24
        width: 360

        Text {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            text: "GLITCH OS"
            color: "#c1121f"
            font.family: "JetBrains Mono"
            font.pixelSize: 34
            font.bold: true
            font.letterSpacing: 8

            // glitch subtil: deslocação aleatória rara
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PauseAnimation { duration: 4200 }
                NumberAnimation { to: 0.55; duration: 40 }
                NumberAnimation { to: 1.0; duration: 40 }
                PauseAnimation { duration: 110 }
                NumberAnimation { to: 0.8; duration: 30 }
                NumberAnimation { to: 1.0; duration: 30 }
                PauseAnimation { duration: 7000 }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SYSTEM ONLINE"
            color: "#505058"
            font.family: "JetBrains Mono"
            font.pixelSize: 11
            font.letterSpacing: 4
        }

        TextField {
            id: userField
            width: parent.width
            placeholderText: "USER"
            text: userModel.lastUser ?? ""
            color: "#c8c8d0"
            placeholderTextColor: "#505058"
            font.family: "JetBrains Mono"
            background: Rectangle {
                color: "#0c0c0f"
                border.color: userField.activeFocus ? "#c1121f" : "#1c1c22"
                border.width: 1
                radius: 2
            }
            onAccepted: passField.forceActiveFocus()
        }

        TextField {
            id: passField
            width: parent.width
            placeholderText: "PASSWORD"
            echoMode: TextInput.Password
            color: "#c8c8d0"
            placeholderTextColor: "#505058"
            font.family: "JetBrains Mono"
            background: Rectangle {
                color: "#0c0c0f"
                border.color: passField.activeFocus ? "#c1121f" : "#1c1c22"
                border.width: 1
                radius: 2
            }
            onAccepted: loginButton.clicked()
        }

        Button {
            id: loginButton
            width: parent.width
            height: 42
            text: errorMessage.visible ? "RETRY" : "LOGIN"
            font.family: "JetBrains Mono"
            font.letterSpacing: 4
            contentItem: Text {
                text: loginButton.text
                color: "#f0f0f5"
                font: loginButton.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: loginButton.pressed ? "#8f0f18" : (loginButton.hovered ? "#a01019" : "#c1121f")
                radius: 2
            }
            onClicked: {
                sddm.login(userField.text, passField.text, sessionIndex)
            }
        }

        Text {
            id: errorMessage
            anchors.horizontalCenter: parent.horizontalCenter
            visible: text !== ""
            text: ""
            color: "#dc3c46"
            font.family: "JetBrains Mono"
            font.pixelSize: 11
            Connections {
                target: sddm
                function onLoginFailed() {
                    errorMessage.text = "ACCESS DENIED"
                    passField.text = ""
                    passField.forceActiveFocus()
                }
            }
        }
    }

    // relógio, canto superior direito
    Text {
        anchors { top: parent.top; right: parent.right; margins: 20 }
        text: Qt.formatTime(new Date(), "hh:mm")
        color: "#505058"
        font.family: "JetBrains Mono"
        font.pixelSize: 14
        Timer {
            interval: 30000
            running: true
            repeat: true
            onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    // power, canto inferior direito
    Row {
        anchors { bottom: parent.bottom; right: parent.right; margins: 16 }
        spacing: 16
        Repeater {
            model: [
                { label: "SLEEP", action: function() { sddm.suspend() } },
                { label: "REBOOT", action: function() { sddm.reboot() } },
                { label: "SHUTDOWN", action: function() { sddm.powerOff() } }
            ]
            Text {
                text: modelData.label
                color: powerMa.containsMouse ? "#c1121f" : "#3a3a42"
                font.family: "JetBrains Mono"
                font.pixelSize: 10
                font.letterSpacing: 2
                MouseArea {
                    id: powerMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.action()
                }
            }
        }
    }
}
