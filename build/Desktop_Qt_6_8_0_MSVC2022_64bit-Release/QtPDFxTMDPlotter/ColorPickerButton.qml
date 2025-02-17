import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts

Button {
    id: root
    // Use layout attached properties now that we have imported QtQuick.Layouts
    Layout.fillWidth: true
    Layout.fillHeight: true
    text: "Select Color"
    hoverEnabled: true         // Enable hover detection

    // Initialize with Material.accent. (If Material.accent isn’t defined, you can use a literal like "#3F51B5".)
    property color currentColor: Material.accent

    background: Rectangle {
        anchors.fill: parent
        color: root.currentColor
        radius: 4
        border.color: Material.foreground
        // Change opacity on hover: more transparent when hovered.
        opacity: root.hovered ? 0.7 : 1.0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    contentItem: Text {
        text: root.text
        color: Material.foreground
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    onClicked: {
        colorDialog.selectedColor = root.currentColor
        colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        title: "Select New Color"
        onAccepted: {
            root.currentColor = colorDialog.selectedColor
            console.log("New color selected:", colorDialog.selectedColor)
        }
    }
}
