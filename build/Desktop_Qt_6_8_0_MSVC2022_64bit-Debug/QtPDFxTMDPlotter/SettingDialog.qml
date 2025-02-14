import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtPDFxTMDPlotter

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

    // C++ model registered with QML.
    PDFInfoModel {
        id: pdfModel
    }

    onOpened: {
        pdfModel.fillPDFInfoModel();
        // Optional: set a default selection
        pdfComboBox.currentIndex = 0;
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        // Sidebar navigation.
        ColumnLayout {
            Layout.maximumWidth: 200
            Layout.fillHeight: true
            spacing: 5

            Button {
                text: "PDFset"
                onClicked: wizardStack.currentIndex = 0
                Material.elevation: wizardStack.currentIndex === 0 ? 4 : 0
                Layout.fillWidth: parent

            }
            Button {
                text: "General"
                onClicked: wizardStack.currentIndex = 4
                Material.elevation: wizardStack.currentIndex === 4 ? 4 : 0
                Layout.fillWidth: parent

            }

            Button {
                text: "Close"
                Layout.fillWidth: parent
                Material.elevation: wizardStack.currentIndex === 4 ? 4 : 0
                onClicked: configDialog.close()
            }
        }

        // Main content area (wizard).
        ScrollView {
            width: parent.width;
            clip: true
            background: Rectangle {
                color: Material.background
            }

            StackLayout {
                id: wizardStack
                width: parent.width
                anchors.centerIn: parent
                currentIndex: 0  // Start on the PDFset page

                // Page 0: PDFset Overview & New PDFset Entry.
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

                    // Use ColumnLayout without anchors.fill.
                    ColumnLayout {
                        spacing: 10
                        Layout.fillWidth: true


                        ComboBox {
                            id: pdfComboBox
                            model: pdfModel
                            textRole: "pdfSetName"  // Use the combined display string
                            Layout.fillWidth: true

                            // Enhanced delegate with full information
                            delegate: ItemDelegate {
                                padding: 10

                                contentItem: Column {
                                    spacing: 4
                                    Text {
                                        text: model.pdfSetName
                                        font.bold: true
                                        color: Material.primary
                                    }
                                }

                                background: Rectangle {
                                    color: highlighted ? Material.listHighlightColor : "transparent"
                                }
                            }
                        }

                        // Detailed information panel
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

                                // Icon column
                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 80
                                    Layout.alignment: Qt.AlignTop
                                    color: Material.primary
                                    radius: 8

                                    Text {
                                        text: "PDF"
                                        anchors.centerIn: parent
                                        color: "white"
                                        font.bold: true
                                        font.pixelSize: 18
                                    }
                                }

                                // Information column
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
                                                if(pdfComboBox.currentIndex < 0) return ""
                                                const QMin = pdfModel.get(pdfComboBox.currentIndex).QMin
                                                const QMax = pdfModel.get(pdfComboBox.currentIndex).QMax
                                                return `${QMin} GeV - ${QMax} GeV`
                                            }
                                        }
                                        Label { text: "x Range:"; font.bold: true }
                                        Label {
                                            text: {
                                                if(pdfComboBox.currentIndex < 0) return ""
                                                const XMin = pdfModel.get(pdfComboBox.currentIndex).XMin
                                                const XMax = pdfModel.get(pdfComboBox.currentIndex).XMax
                                                return `${XMin} - ${XMax}`
                                            }
                                        }
                                        Label { text: "Flavors:"; font.bold: true }
                                        Label {
                                            Layout.maximumWidth: 400
                                            text: {
                                                if(pdfComboBox.currentIndex < 0) return ""
                                                return pdfModel.get(pdfComboBox.currentIndex).Flavors
                                            }
                                            wrapMode: Text.WordWrap
                                        }
                                        Label { text: "Format:"; font.bold: true }
                                        Label {
                                            text: {
                                                if(pdfComboBox.currentIndex < 0) return ""
                                                return pdfModel.get(pdfComboBox.currentIndex).Format
                                            }
                                        }

                                        Label { text: "QCD Order:"; font.bold: true }
                                        Label {
                                            text: {
                                                if(pdfComboBox.currentIndex < 0) return ""
                                                return pdfModel.get(pdfComboBox.currentIndex).OrderQCD
                                            }
                                        }
                                        Label { text: "Type:"; font.bold: true }
                                        Label { text: pdfComboBox.currentIndex >= 0 ?
                                                    (pdfModel.get(pdfComboBox.currentIndex).pdfSetName.includes("TMD") ? "TMD PDF" : "Standard PDF") : "" }

                                    }
                                }
                            }
                        }
                    }

                    // TextField {
                    //     id: newPdfName
                    //     placeholderText: "Enter new PDFset name"
                    //     Layout.fillWidth: true
                    // }
                    // Button {
                    //     text: "Start Download Wizard"
                    //     enabled: newPdfName.text.length > 0
                    //     onClicked: wizardStack.currentIndex = 1
                    // }
                }

                // // Page 1: Step 1 - Download Location.
                // ColumnLayout {
                //     spacing: 10
                //     Layout.fillWidth: true
                //     Layout.fillHeight: true

                //     Text {
                //         text: "Step 1: Choose Download Location"
                //         font.pointSize: 16
                //         font.bold: true
                //     }
                //     TextField {
                //         id: downloadLocationField
                //         placeholderText: "Enter download location (e.g. /home/user/downloads)"
                //         Layout.fillWidth: true
                //     }
                //     RowLayout {
                //         Layout.fillWidth: true
                //         spacing: 10
                //         Button {
                //             text: "Back"
                //             onClicked: wizardStack.currentIndex = 0
                //         }
                //         Button {
                //             text: "Next"
                //             enabled: downloadLocationField.text.length > 0
                //             onClicked: wizardStack.currentIndex = 2
                //         }
                //     }
                // }

                // // Page 2: Step 2 - Repository Selection.
                // ColumnLayout {
                //     spacing: 10
                //     Layout.fillWidth: true
                //     Layout.fillHeight: true

                //     Text {
                //         text: "Step 2: Select Download Repository"
                //         font.pointSize: 16
                //         font.bold: true
                //     }
                //     RadioButton {
                //         id: repoOption1
                //         text: "Repository 1"
                //         checked: true
                //     }
                //     RadioButton {
                //         id: repoOption2
                //         text: "Repository 2"
                //     }
                //     RadioButton {
                //         id: customRepoOption
                //         text: "Custom Repository"
                //     }
                //     TextField {
                //         id: customRepoField
                //         placeholderText: "Enter custom repository URL"
                //         visible: customRepoOption.checked
                //         Layout.fillWidth: true
                //     }
                //     RowLayout {
                //         Layout.fillWidth: true
                //         spacing: 10
                //         Button {
                //             text: "Back"
                //             onClicked: wizardStack.currentIndex = 1
                //         }
                //         Button {
                //             text: "Next"
                //             onClicked: wizardStack.currentIndex = 3
                //         }
                //     }
                // }

                // // Page 3: Step 3 - Download Process.
                // ColumnLayout {
                //     spacing: 10
                //     Layout.fillWidth: true
                //     Layout.fillHeight: true

                //     Text {
                //         text: "Step 3: Downloading PDFset"
                //         font.pointSize: 16
                //         font.bold: true
                //     }
                //     ProgressBar {
                //         id: downloadProgress
                //         value: 0.0
                //         Layout.fillWidth: true
                //     }
                //     Button {
                //         text: "Simulate Download"
                //         onClicked: {
                //             downloadProgress.value = 0.0;
                //             downloadTimer.start();
                //         }
                //     }
                //     Timer {
                //         id: downloadTimer
                //         interval: 100
                //         repeat: true
                //         running: false
                //         onTriggered: {
                //             if (downloadProgress.value < 1.0) {
                //                 downloadProgress.value += 0.05;
                //             } else {
                //                 downloadTimer.stop();
                //             }
                //         }
                //     }
                //     RowLayout {
                //         Layout.fillWidth: true
                //         spacing: 10
                //         Button {
                //             text: "Back"
                //             onClicked: wizardStack.currentIndex = 2
                //         }
                //         Button {
                //             text: "Finish"
                //             enabled: downloadProgress.value >= 1.0
                //             onClicked: {
                //                 newPdfName.text = "";
                //                 downloadLocationField.text = "";
                //                 downloadProgress.value = 0.0;
                //                 wizardStack.currentIndex = 0;
                //             }
                //         }
                //     }
                // }

                // Page 4: General Settings (Placeholder).
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        text: "General Settings"
                        font.pointSize: 16
                        font.bold: true
                    }
                    Label {
                        text: "Other options related to PDFxTMD library can go here..."
                    }
                    Button {
                        text: "Back"
                        onClicked: wizardStack.currentIndex = 0
                    }
                }
            }
        }
    }

}
