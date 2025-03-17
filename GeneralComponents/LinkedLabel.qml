import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Label {
    text: "a description"
    Layout.fillWidth: true
    onLinkActivated: Qt.openUrlExternally(link)
    wrapMode: Text.WordWrap
    textFormat: Text.RichText
    linkColor: Material.color(Material.Blue)
    font.pixelSize: 14
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
