import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    spacing: 10
    width: parent.width
    height: parent.height
    property int selectedRepoType: -1;
    property alias customRepoUrl: customRepoField.text
    
    signal navigateBack()
    signal navigateNext()

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
            onClicked: navigateBack()
        }
        Button {
            text: "Next"
            enabled: !customRepoOption.checked || customRepoField.text.length > 0
            onClicked:
            {
                if (repoLHAPDF.checked)
                    selectedRepoType = 1;
                else if (repoTMDLib.checked)
                    selectedRepoType = 2;
                else if (customRepoOption.checked)
                    selectedRepoType = 3;

                navigateNext()
            }
        }
    }
}
