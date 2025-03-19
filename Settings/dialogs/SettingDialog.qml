import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import QtPDFxTMDPlotter 1.0
import "../Views"
import "../wizard"

Dialog {
    id: configDialog
    title: "Settings"
    modal: true
    width: parent.width
    height: parent.height
    background: Rectangle {
        color: Material.color(Material.Grey, Material.Shade50)
    }

    Material.theme: Material.Light
    Material.accent: Material.Blue
    Material.primary: Material.BlueGrey

    // Models and managers exposed for child components
    property alias pdfModel: pdfModel
    property alias downloadManager: downloadManager
    
    PDFInfoModel {
        id: pdfModel
    }

    DownloadManager {
        id: downloadManager
    }

    onOpened: {
        pdfModel.fillPDFInfoModel();
    }

    RowLayout {
        anchors.fill: parent
        spacing: 20

        ColumnLayout {
            Layout.maximumWidth: 200
            Layout.minimumWidth: 100
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
        ColumnLayout
        {
            Layout.maximumWidth: 800
            StackLayout {
                id: wizardStack
                currentIndex: 0
                // Page 0: PDF set overview
                PDFInfoView {
                    id: pdfInfoView
                    onStartDownloadWizard: wizardStack.currentIndex = 1
                    pdfModel: configDialog.pdfModel
                }

                // Wizard pages
                PathSelectionPage {
                    id: pathSelectionId
                    downloadManager: configDialog.downloadManager
                    onNavigateBack: wizardStack.currentIndex = 0
                    onNavigateNext:
                    {
                        wizardStack.currentIndex = 2
                        console.log("[RMAIN] pathSelectionId.selectedPath" + pathSelectionId.selectedPath)
                    }
                }

                RepositorySelectionPage {
                    id: repoSelectionId
                    onNavigateBack: wizardStack.currentIndex = 1
                    onNavigateNext: wizardStack.currentIndex = 3
                }

                DownloadProcessPage {
                    downloadManager: configDialog.downloadManager
                    pdfSetName: pdfInfoView.newPdfName
                    extractPath: pathSelectionId.selectedPath;
                    repositoryType: repoSelectionId.selectedRepoType
                    customRepoUrl: repoSelectionId.customRepoUrl
                    onSetupComplete: {
                        pdfInfoView.resetFields()
                        wizardStack.currentIndex = 0
                    }
                    onNavigateBack: wizardStack.currentIndex = 2
                }

                // About page
                AboutView {}
            }
        }




    }
} 
