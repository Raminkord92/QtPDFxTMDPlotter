import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Dialog {
    property Item objectRow
    id: cPDFDialog
    title: "Add cPDF Object"
    width: 300
    height: 400
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel
    property var leftSidRef : null

    background: Rectangle {
        color: Material.dialogColor
        radius: 8
    }

    Column {
        spacing: 10
        width: parent.width

        ComboBox {
            id: cpdfSetCombo
            width: parent.width
            model: ["MMHT2014", "CT18", "NNPDF3.1"]
            currentIndex: 0
        }

        TextField {
            id: cpdfXField
            width: parent.width
            placeholderText: "x value"
            text: "0.0"
            validator: DoubleValidator { bottom: 0; top: 1 }
        }

        TextField {
            id: cpdfMuField
            width: parent.width
            placeholderText: "mu value"
            text: "0.5"
            validator: DoubleValidator { bottom: 0 }
        }
    }

    onAccepted: {
        if (objectRow) {
            var cpdf = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls.Material
                CPDFObject {
                    pdfSet: "${cpdfSetCombo.currentText}"
                    properties: ({
                        x: ${cpdfXField.text},
                        mu: ${cpdfMuField.text}
                    })
                }
            `, leftSidRef)
        } else {
            console.error("objectRow is undefined");
        }
    }

    function setObjectRow(row) {
        objectRow = row;
    }
    Component.onCompleted: {
        console.log("cPDFDialog leftsideref ", leftSidRef)
    }
}
