import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    spacing: 10
    width: parent.width
    height: parent.height
    
    property var downloadManager
    property string pdfSetName: ""
    property string extractPath: ""
    property int repositoryType: 1 // Default to LHAPDF
    property string customRepoUrl: ""
    
    signal setupComplete()
    signal navigateBack()

    Component.onCompleted: {
        downloadManager.onProgressChanged.connect(function(progress) {
            downloadProgress.value = progress;
        });
        
        downloadManager.onDownloadFinished.connect(function(success, errorMessage) {
            statusText.text = success ? 
                "Download and extraction completed: " + errorMessage : 
                "Error: " + errorMessage;
            finishButton.enabled = success;
            setupComplete();
        });
        
        downloadManager.onIsDownloadingChanged.connect(function() {
            downloadButton.enabled = !downloadManager.isDownloading;
        });
    }

    Text {
        text: "Step 3: Downloading and Extracting PDF Set"
        font.pointSize: 16
        font.bold: true
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
            downloadManager.startDownload(
                pdfSetName,
                repositoryType,
                customRepoUrl,
                extractPath
            )
        }
    }
    
    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Button {
            text: "Back"
            onClicked: navigateBack()
        }
        Button {
            id: finishButton
            text: "Finish"
            enabled: false
        }
    }
} 
