import QtQuick 2.4
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import MeuiKit 1.0 as Meui
import Cyber.FileManager 1.0

Item {
    id: control

    property string url: ""
    signal placeClicked(string path)
    signal pathChanged(string path)

    onUrlChanged: {
        _pathList.path = control.url
    }

    BaseModel {
        id: _pathModel
        list: _pathList
    }

    PathList {
        id: _pathList
    }

    Rectangle {
        anchors.fill: parent
        radius: Meui.Theme.smallRadius
        color: Meui.Theme.backgroundColor
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: _pathModel
        orientation: Qt.Horizontal
        layoutDirection: Qt.LeftToRight
        clip: true

        spacing: Meui.Units.smallSpacing

        onCountChanged: {
            currentIndex = listView.count - 1
            listView.positionViewAtEnd()
        }

        delegate: MouseArea {
            height: listView.height
            width: label.width + Meui.Units.largeSpacing * 2

            onClicked: control.placeClicked(model.path)

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                color: Meui.Theme.highlightColor
                radius: Meui.Theme.smallRadius
                visible: index === listView.count - 1

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 2
                    samples: 2
                    horizontalOffset: 0
                    verticalOffset: 0
                    color: Qt.rgba(0, 0, 0, 0.1)
                }
            }

            Label {
                id: label
                text: model.label
                color: index === listView.count - 1 ? Meui.Theme.highlightedTextColor : Meui.Theme.textColor
                anchors.centerIn: parent
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1

            onClicked: {
                if (!addressEdit.visible) {
                    openEditor()
                }
            }
        }
    }

    TextField {
        id: addressEdit
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        visible: false
        selectByMouse: true
        inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase

        text: control.url

        onAccepted: {
            control.pathChanged(text)
            closeEditor()
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape)
                focus = false
        }

        onActiveFocusChanged: {
            if (!activeFocus) {
                closeEditor()
            }
        }
    }

    function closeEditor() {
        addressEdit.visible = false
        listView.visible = true
    }

    function openEditor() {
        addressEdit.visible = true
        addressEdit.forceActiveFocus()
        addressEdit.selectAll()
        listView.visible = false
    }
}
