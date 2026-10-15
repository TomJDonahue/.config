import QtQuick

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: bg

    readonly property color bg: "#1c1c1c"
    readonly property color fg: "#af5f5f"
    readonly property color accent: "#af5f5f"//"#87afaf"
    readonly property color dim: "#767676"
    readonly property color err: "#d75f5f"
    readonly property string mono: "monospace"

    Image {
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle { anchors.fill: parent; color: root.bg; opacity: 0.55 }

    // hidden model holder for session selection
    ListView { visible: false; id: sessions; model: sessionModel; currentIndex: sessionModel.lastIndex }

    property int sessionIdx: sessionModel.lastIndex
    function sessionName(i) {
        return sessionModel.data(sessionModel.index(i, 0), 0x0100 + 4) || "session"
    }

    Text {
        id: clock
        anchors { top: parent.top; right: parent.right; margins: 40 }
        color: root.fg
        font { family: root.mono; pixelSize: 28 }
        text: Qt.formatDateTime(new Date(), "HH:mm  ddd d MMM")
        Timer { interval: 1000; running: true; repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm  ddd d MMM") }
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 420; height: 300
        color: root.bg
        opacity: 0.92
        border { color: root.accent; width: 2 }

        Column {
            anchors.centerIn: parent
            spacing: 16
            width: parent.width - 60

            Text { text: "login"; color: root.accent
                   font { family: root.mono; pixelSize: 22; bold: true } }

            Rectangle {
                width: parent.width; height: 40; color: "transparent"
                border { color: userField.activeFocus ? root.accent : root.dim; width: 1 }
                TextInput {
                    horizontalAlignment: TextInput.AlignHCenter
                    id: userField
                    anchors { fill: parent; margins: 10 }
                    color: root.fg; selectionColor: root.accent
                    font { family: root.mono; pixelSize: 16 }
                    text: userModel.lastUser
                    KeyNavigation.tab: passField
                    onAccepted: passField.forceActiveFocus()
                }
            }

            Rectangle {
                width: parent.width; height: 40; color: "transparent"
                border { color: passField.activeFocus ? root.accent : root.dim; width: 1 }
                TextInput {
                    horizontalAlignment: TextInput.AlignHCenter
                    id: passField
                    anchors { fill: parent; margins: 10 }
                    color: root.fg; selectionColor: root.accent
                    echoMode: TextInput.Password
                    passwordCharacter: "•"
                    font { family: root.mono; pixelSize: 16 }
                    focus: true
                    onAccepted: sddm.login(userField.text, passField.text, root.sessionIdx)
                }
            }

            Text {
                id: errorText
                color: root.err; text: ""
                font { family: root.mono; pixelSize: 14 }
            }

            Text {
                color: root.dim
                font { family: root.mono; pixelSize: 14 }
                text: "session: " + root.sessionName(root.sessionIdx) + "  (click to cycle)"
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.sessionIdx = (root.sessionIdx + 1) % sessionModel.count
                }
            }
        }
    }

    Row {
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; margins: 40 }
        spacing: 40
        Text { text: "reboot"; color: root.fg; font { family: root.mono; pixelSize: 16 }
               MouseArea { anchors.fill: parent; onClicked: sddm.reboot() } }
        Text { text: "power off"; color: root.fg; font { family: root.mono; pixelSize: 16 }
               MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() } }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorText.text = "login failed"
            passField.text = ""
            passField.forceActiveFocus()
        }
    }
}
