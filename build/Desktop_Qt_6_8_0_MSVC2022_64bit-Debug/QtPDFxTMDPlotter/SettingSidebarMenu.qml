import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    property alias text: label.text
    property alias iconSource: icon.source
    property bool selected: false
    signal clicked

    height: 40
    width: parent.width

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        opacity: mouseArea.containsMouse ? 0.1 : 1
        radius: 4

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            spacing: 12

            Image {
                id: icon
                sourceSize: Qt.size(20, 20)
                opacity: root.selected ? 1 : 0.7
            }

            Label {
                id: label
                Layout.fillWidth: true
                font.pixelSize: 14
                opacity: root.selected ? 1 : 0.8
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
