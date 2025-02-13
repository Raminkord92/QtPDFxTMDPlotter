import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    property alias title: heading.text
    spacing: 16

    Label {
        id: heading
        font.bold: true
        font.pixelSize: 16
        bottomPadding: 4
        color: Material.primaryTextColor
    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Material.dividerColor
        opacity: 0.2
    }

    ColumnLayout {
        spacing: 16
        Layout.leftMargin: 8
        Layout.fillWidth: true

        children: parent.children.length > 2 ? parent.children.slice(2) : []
    }
}
