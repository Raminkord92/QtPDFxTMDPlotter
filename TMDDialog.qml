import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Dialog {
    property Item objectRow

    title: "Add TMD Object"
    width: 300
    height: 400
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    background: Rectangle {
        color: Material.dialogColor
        radius: 8
    }

    Column {
        spacing: 10
        width: parent.width

        ComboBox {
            id: tmdSetCombo
            width: parent.width
            model: ["MMHT2014", "CT18", "NNPDF3.1"]
            currentIndex: 0
        }

        TextField {
            id: tmdXField
            width: parent.width
            placeholderText: "x value"
            text: "0.0"
            validator: DoubleValidator { bottom: 0; top: 1 }
        }

        TextField {
            id: tmdKtField
            width: parent.width
            placeholderText: "kt value"
            text: "1000.0"
            validator: DoubleValidator { bottom: 0 }
        }

        TextField {
            id: tmdMuField
            width: parent.width
            placeholderText: "mu value"
            text: "0.5"
            validator: DoubleValidator { bottom: 0 }
        }
    }

    onAccepted: {
        if (objectRow) {
            var tmd = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls.Material
                TMDObject {
                    pdfSet: "${tmdSetCombo.currentText}"
                    properties: ({
                        x: ${tmdXField.text},
                        kt: ${tmdKtField.text},
                        mu: ${tmdMuField.text}
                    })
                }
            `, objectRow)
        } else {
            console.error("objectRow is undefined");
        }
    }
}
