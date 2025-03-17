import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "../../GeneralComponents"

ColumnLayout {
    spacing: 10
    width: parent.width
    height: parent.height

    property var downloadManager
    property alias selectedPath: pathComboBox.currentText
    
    signal navigateBack()
    signal navigateNext()

    Text {
        text: "Step 1: Select Extraction Path"
        font.pointSize: 16
        font.bold: true
    }

    Text {
        text: "Choose an existing path or add a new one:"
        font.bold: true
    }

    ScrollableComboBox {
        id: pathComboBox
        model: downloadManager.availablePaths
        Layout.fillWidth: true
        currentIndex: 0
    }
    
    Button {
        text: "Add New Path"
        Layout.fillWidth: true
        onClicked: folderDialog.open()
    }

    FolderDialog {
        id: folderDialog
        title: "Select Extraction Directory"
        onAccepted: {
            if (downloadManager.addPath(selectedFolder.toString().replace("file:///", ""))) {
                pathComboBox.currentIndex = downloadManager.availablePaths.length - 1
                pathStatusText.text = "Added and selected: " + pathComboBox.currentText
            } else {
                pathStatusText.text = "Error: Could not add path or path already exists"
            }
        }
    }

    Text {
        id: pathStatusText
        text: ""
        color: Material.accent
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Button {
            text: "Back"
            onClicked: navigateBack()
        }
        Button {
            text: "Next"
            onClicked:
            {
                console.log("[RAMIN] next...")
                navigateNext()
            }
        }
    }
} 
