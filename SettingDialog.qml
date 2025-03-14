import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import QtPDFxTMDPlotter 1.0

Dialog {
    id: configDialog
    title: "Settings"
    modal: true
    width: parent.width
    height: parent.height
    background: Rectangle {
        color: Material.color(Material.Grey, Material.Shade50)
    }

    Material.theme: Material.System
    Material.accent: Material.Blue
    Material.primary: Material.BlueGrey

    PDFInfoModel {
        id: pdfModel
    }

    DownloadManager {
        id: downloadManager
        onProgressChanged: downloadProgress.value = progress
        onDownloadFinished: function(success, errorMessage) {
            statusText.text = success ? "Download and extraction completed: " + errorMessage : "Error: " + errorMessage
            finishButton.enabled = success
            pdfModel.fillPDFInfoModel();
            wizardStack.currentIndex = 0;
            pdfSetDownloadStatusText = "";
        }
        onIsDownloadingChanged: {
            downloadButton.enabled = !isDownloading
        }
    }

    onOpened: {
        pdfModel.fillPDFInfoModel();
        pdfComboBox.currentIndex = 0;
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        ColumnLayout {
            Layout.maximumWidth: 200
            Layout.fillHeight: true
            spacing: 5

            Button {
                text: "PDF set"
                onClicked: wizardStack.currentIndex = 0
                Layout.fillWidth: true
            }

            Button {
                text: "About"
                onClicked: wizardStack.currentIndex = 4
                Layout.fillWidth: true
            }
            Button {
                text: "Close"
                Layout.fillWidth: true
                onClicked: configDialog.close()
            }

        }

        ScrollView {
            width: parent.width
            clip: true
            background: Rectangle {
                color: Material.background
            }

            StackLayout {
                id: wizardStack
                width: parent.width
                anchors.centerIn: parent
                currentIndex: 0

                // Page 0: PDFset Overview & New PDFset Entry (unchanged)
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        text: "Available PDFsets"
                        font.pointSize: 18
                        font.bold: true
                        color: Material.theme === Material.Dark ? Material.color(Material.White) : Material.color(Material.Blue)
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        ScrollableComboBox {
                            id: pdfComboBox
                            model: pdfModel
                            textRole: "pdfSetName"
                            Layout.fillWidth: true
                        }

                        GroupBox {
                            visible: pdfComboBox.currentIndex >= 0
                            Layout.fillWidth: true
                            Layout.minimumWidth: 400
                            title: "Selected PDF Set Details"
                            Material.elevation: 2

                            GridLayout {
                                columns: 2
                                columnSpacing: 20
                                rowSpacing: 10
                                anchors.fill: parent

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 80
                                    Layout.alignment: Qt.AlignTop
                                    color: Material.primary
                                    radius: 8
                                    Text {
                                        text: pdfSetType.text
                                        anchors.centerIn: parent
                                        color: "white"
                                        font.bold: true
                                        font.pixelSize: 18
                                    }
                                }

                                ColumnLayout {
                                    spacing: 8
                                    Layout.fillWidth: true

                                    Label {
                                        text: pdfComboBox.currentText
                                        font.bold: true
                                        font.pixelSize: 16
                                        elide: Text.ElideRight
                                    }

                                    GridLayout {
                                        columns: 2
                                        columnSpacing: 15
                                        rowSpacing: 8
                                        Label { text: "μ Range:"; font.bold: true }
                                        Label {
                                            text: {
                                                if (pdfComboBox.currentIndex < 0) return ""
                                                const QMin = pdfModel.get(pdfComboBox.currentIndex).QMin
                                                const QMax = pdfModel.get(pdfComboBox.currentIndex).QMax
                                                return `${QMin} GeV - ${QMax} GeV`
                                            }
                                        }
                                        Label { text: "x Range:"; font.bold: true }
                                        Label {
                                            text: {
                                                if (pdfComboBox.currentIndex < 0) return ""
                                                const XMin = pdfModel.get(pdfComboBox.currentIndex).XMin
                                                const XMax = pdfModel.get(pdfComboBox.currentIndex).XMax
                                                return `${XMin} - ${XMax}`
                                            }
                                        }
                                        Label {
                                            text: "kₜ Range:";
                                            font.bold: true;
                                            visible: pdfComboBox.currentIndex >= 0 ?
                                                         (pdfModel.get(pdfComboBox.currentIndex).PDFSetType === 0 ? false : true) : false
                                        }
                                        Label {
                                            text: {
                                                if (pdfComboBox.currentIndex < 0) return ""
                                                const KtMin = pdfModel.get(pdfComboBox.currentIndex).KtMin
                                                const KtMax = pdfModel.get(pdfComboBox.currentIndex).KtMax
                                                return `${KtMin} - ${KtMax}`
                                            }
                                            visible: pdfComboBox.currentIndex >= 0 ?
                                                         (pdfModel.get(pdfComboBox.currentIndex).PDFSetType === 0 ? false : true) : false
                                        }
                                        Label { text: "Flavors:"; font.bold: true }
                                        Label {
                                            Layout.maximumWidth: 400
                                            text: pdfComboBox.currentIndex < 0 ? "" : pdfModel.get(pdfComboBox.currentIndex).Flavors
                                            wrapMode: Text.WordWrap
                                        }
                                        Label { text: "Format:"; font.bold: true }
                                        Label {
                                            text: pdfComboBox.currentIndex < 0 ? "" : pdfModel.get(pdfComboBox.currentIndex).Format
                                        }
                                        Label { text: "QCD Order:"; font.bold: true }
                                        Label {
                                            text: pdfComboBox.currentIndex < 0 ? "" : pdfModel.get(pdfComboBox.currentIndex).OrderQCD
                                        }
                                        Label { text: "Type:"; font.bold: true }
                                        Label {
                                            id: pdfSetType
                                            text:{
                                                if (pdfComboBox.currentIndex >= 0 )
                                                {
                                                    console.log("pdfModel.get(pdfComboBox.currentIndex).PDFSetType" + pdfModel.get(pdfComboBox.currentIndex).PDFSetType)
                                                    if (pdfModel.get(pdfComboBox.currentIndex).PDFSetType === "cPDF" )
                                                    {
                                                        return "cPDF";
                                                    }
                                                    return "TMD";
                                                }

                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: newPdfName
                        placeholderText: "Enter new PDF set name"
                        Layout.fillWidth: true
                    }
                    ColumnLayout {
                        Layout.fillWidth: true

                        Text {
                            id: lblPDFSetDesc
                            Layout.fillWidth: true
                            text: "Enter cPDF set name from <a href='https://www.lhapdf.org/pdfsets.html'>https://www.lhapdf.org/pdfsets.html</a>, and TMD set name from <a href='https://tmdlib.hepforge.org/TMDsets.txt'>https://tmdlib.hepforge.org/TMDsets.txt</a>"
                            wrapMode: Text.WordWrap
                            textFormat: Text.RichText
                            onLinkActivated: function(link) {
                                Qt.openUrlExternally(link)
                            }

                            linkColor: Material.color(Material.Blue)

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.NoButton
                                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                            }
                        }
                    }

                    Button {
                        text: "Start Download Wizard"
                        enabled: newPdfName.text.length > 0
                        onClicked: {
                            if (pdfModel.pdfSetAlreadyExists(newPdfName.text))
                            {
                                pdfSetDownloadStatusText.text = "This pdf set already exists";
                                return;
                            }
                            pdfSetDownloadStatusText.text = "";
                            wizardStack.currentIndex = 1
                        }
                    }
                    Text {
                        id: pdfSetDownloadStatusText
                        text: ""
                        color: Material.accent
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }

                // Page 1: Step 1 - Path Selection (UI-friendly)
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true

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
                            console.log("selectedFolder" + selectedFolder)
                            if (downloadManager.addPath(selectedFolder.toString().replace("file:///", ""))) {
                                pathComboBox.currentIndex = downloadManager.availablePaths.length - 1
                                pathStatusText.text = "Added and selected: " + pathComboBox.currentText
                            } else {
                                pathStatusText.text = "Error: Could not add path or path already exists"
                            }
                        }
                        onRejected: {
                            // pathStatusText.text = "Path selection cancelled"
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
                            onClicked: wizardStack.currentIndex = 0
                        }
                        Button {
                            text: "Next"
                            onClicked: {
                                extractLocationField.text = pathComboBox.currentText
                                wizardStack.currentIndex = 2
                            }
                        }
                    }
                }

                // Page 2: Step 2 - Repository Selection
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        text: "Step 2: Select Download Repository"
                        font.pointSize: 16
                        font.bold: true
                    }
                    RadioButton {
                        id: repoLHAPDF
                        text: "LHAPDF Repo"
                        checked: true
                    }
                    RadioButton {
                        id: repoTMDLib
                        text: "TMD Repo"
                    }
                    RadioButton {
                        id: customRepoOption
                        text: "Custom Repository"
                    }
                    TextField {
                        id: customRepoField
                        placeholderText: "Enter custom repository URL"
                        visible: customRepoOption.checked
                        Layout.fillWidth: true
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Button {
                            text: "Back"
                            onClicked: wizardStack.currentIndex = 1
                        }
                        Button {
                            text: "Next"
                            enabled: !customRepoOption.checked || customRepoField.text.length > 0
                            onClicked: wizardStack.currentIndex = 3
                        }
                    }
                }

                // Page 3: Step 3 - Download and Extract Process
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        text: "Step 3: Downloading and Extracting PDF Set"
                        font.pointSize: 16
                        font.bold: true
                    }
                    TextField {
                        id: extractLocationField
                        visible: false // Hidden, stores selected path
                    }
                    ProgressBar {
                        id: downloadProgress
                        value: 0.0
                        Layout.fillWidth: true
                    }
                    Text {
                        id: statusText
                        text: ""
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    Button {
                        id: downloadButton
                        text: "Start Download"
                        enabled: true
                        onClicked: {
                            downloadProgress.value = 0.0
                            statusText.text = "Starting download..."
                            const repoType = repoLHAPDF.checked ? 1 : (repoTMDLib.checked ? 2 : 3)
                            downloadManager.startDownload(
                                newPdfName.text,
                                repoType,
                                customRepoOption.checked ? customRepoField.text : "",
                                extractLocationField.text
                            )
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Button {
                            text: "Back"
                            onClicked: wizardStack.currentIndex = 2
                        }
                        Button {
                            id: finishButton
                            text: "Finish"
                            enabled: false
                            onClicked: {
                                newPdfName.text = ""
                                extractLocationField.text = ""
                                customRepoField.text = ""
                                downloadProgress.value = 0.0
                                statusText.text = ""
                                wizardStack.currentIndex = 0
                            }
                        }
                    }
                }

                // Page 4: About Section
                ColumnLayout {
                    spacing: 20
                    width: parent.width

                    Label {
                        text: "About QtPDFxTMDPlotter"
                        font.bold: true
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        text: "Version 1.0.0"  // Replace with your actual version
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        height: 1
                        color: "lightgray"
                        Layout.fillWidth: true
                        Layout.margins: 10
                    }

                    Label {
                        text: "This application allows you to create plots of PDF and TMD functions."
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        text: "<b>GitHub:</b> <a href='https://github.com/yourusername/QtPDFxTMDPlotter'>github.com/yourusername/QtPDFxTMDPlotter</a>"
                        onLinkActivated: Qt.openUrlExternally(link)
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        text: "<b>Contact:</b> <a href='mailto:your.email@example.com'>your.email@example.com</a>"
                        onLinkActivated: Qt.openUrlExternally(link)
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
