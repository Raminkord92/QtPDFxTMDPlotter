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
    property Item objectRow: null

    property CPDFDialog tmdDialog: CPDFDialog {
        id: tmdDialog // Assign an ID to the TMDDialog instance
        objectRow: objectRow
        leftSidRef : topSection.leftSidRef
    }

    property CPDFDialog cPDFDialog: CPDFDialog {
        id: cPDFDialog // Assign an ID to the TMDDialog instance
        objectRow: objectRow
        leftSidRef : topSection.leftSidRef
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
            
            onClicked: addObjectPopup.open()

            Popup {
                id: addObjectPopup
                y: plusButton.height + 5
                width: 150
                padding: 10
                background: Rectangle {
                    color: Material.dialogColor
                    radius: 8
                }
                
                Column {
                    spacing: 8
                    width: parent.width
                    
                    Button {
                        text: "Add TMD"
                        width: parent.width
                        Material.background: Material.primary
                        onClicked: {
                            tmdDialog.open() // Use the ID to access tmdDialog
                            addObjectPopup.close()
                        }
                    }
                    
                    Button {
                        text: "Add cPDF"
                        width: parent.width
                        Material.background: Material.primary
                        onClicked: {
                            cPDFDialog.open()
                            addObjectPopup.close()
                        }
                    }
                }
            }
        }

        // Row for draggable objects
        Row {
            id: objectRow
            height: parent.height
            spacing: 10
        }
    }
    Component.onCompleted: {
        console.log("main loaded")
    }
}
