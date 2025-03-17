import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    id: topSection
    Layout.fillWidth: true
    Layout.preferredHeight: 60
    color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.05)
    radius: 8
    border.color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.1)
    border.width: 1
    property var leftSidRef : null
    property int currentTabUniqueId: 0

    property PDFDialog pdfDialog: PDFDialog {
        id: pdfDialog
        leftSidRef : topSection.leftSidRef
        currentTabUniqueId_: currentTabUniqueId
    }

    Row {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        // Plus Button
        RoundButton {
            id: plusButton
            text: "+"
            font.pixelSize: 20
            width: 40
            height: 40
            Material.background: Material.primary
            
            onClicked: pdfDialog.open()
        }
    }
    Component.onCompleted: {
    }
}
