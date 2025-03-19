import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtPDFxTMDPlotter 1.0
import "../../GeneralComponents"

ColumnLayout {
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    spacing: 10
    width: parent.width
    height: parent.height;

    property alias newPdfName: newPdfName.text
    property var pdfModel
    
    signal startDownloadWizard()

    function resetFields() {
        newPdfName.text = ""
        pdfSetDownloadStatusText.text = ""
        pdfModel.fillPDFInfoModel();
    }

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
            onCurrentIndexChanged: {
                if (currentIndex >= 0) {
                    pdfModel.fillPDFInfoModel()
                }
            }
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
                                        (pdfModel.get(pdfComboBox.currentIndex).PDFSetType === "cPDF" ? false : true) : false
                        }
                        Label {
                            text: {
                                if (pdfComboBox.currentIndex < 0) return ""
                                const KtMin = pdfModel.get(pdfComboBox.currentIndex).KtMin
                                const KtMax = pdfModel.get(pdfComboBox.currentIndex).KtMax
                                return `${KtMin} - ${KtMax}`
                            }
                            visible: pdfComboBox.currentIndex >= 0 ?
                                        (pdfModel.get(pdfComboBox.currentIndex).PDFSetType === "cPDF" ? false : true) : false
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
        LinkedLabel
        {
            id: lblPDFSetDesc
            font.pixelSize: 12
            text: "Enter cPDF set name from <a href='https://www.lhapdf.org/pdfsets.html'>https://www.lhapdf.org/pdfsets.html</a>, and TMD set name from <a href='https://tmdlib.hepforge.org/TMDsets.txt'>https://tmdlib.hepforge.org/TMDsets.txt</a>"
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
            startDownloadWizard()
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
