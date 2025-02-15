import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtPDFxTMDPlotter 1.0

Dialog {
    id: cPDFDialog
    title: "PDF Plot Object"
    width: 300
    height: 400

    // Properties
    property double qMinValue: 0.0
    property double qMaxValue: 100.0
    property double xMinValue: 0.0
    property double xMaxValue: 1.0
    property bool isEditMode: false
    property string currentPDFSetName: ''
    standardButtons: Dialog.Ok | Dialog.Cancel
    property var leftSidRef
    property Item objectRow

    // Make the dialog movable
    property point dragStartPoint: Qt.point(0, 0)
    property bool isDragging: false

    onOpened: {
        pdfModel.fillPDFInfoModel();
        if (!isEditMode) {
            console.log("salam Component.onCompleted")
            cpdfSetCombo.currentIndex = 0;
            getQMinValue();
            getQMaxValue();
            getXMinValue();
            getXMaxValue();
            xMinField.text = xMinValue;
            xMaxField.text = xMaxValue;
            qMinField.text = qMinValue;
            qMaxField.text = qMaxValue;
            currentPDFSetName = cpdfSetCombo.currentText
        }
    }

    background: Rectangle {
        color: Material.dialogColor
        radius: 8

        // Enable dragging for the dialog
        MouseArea {
            anchors.fill: parent
            onPressed: {
                cPDFDialog.isDragging = true;
                cPDFDialog.dragStartPoint = Qt.point(mouse.x, mouse.y);
            }
            onPositionChanged: {
                if (cPDFDialog.isDragging) {
                    cPDFDialog.x += mouse.x - cPDFDialog.dragStartPoint.x;
                    cPDFDialog.y += mouse.y - cPDFDialog.dragStartPoint.y;
                }
            }
            onReleased: {
                cPDFDialog.isDragging = false;
            }
        }
    }

    PDFInfoModel {
        id: pdfModel
    }

    Column {
        spacing: 10
        width: parent.width

        RowLayout {
            ButtonGroup {
                id: pdfTypeBtnGroup
                onCheckedButtonChanged: {
                    if (checkedButton)
                        console.log("Checked button text is", checkedButton.text);
                }
            }
            spacing: 10
            RadioButton {
                text: "cPDF"
                checked: true
                ButtonGroup.group: pdfTypeBtnGroup
            }
            RadioButton {
                text: "TMD"
                ButtonGroup.group: pdfTypeBtnGroup
            }
        }

        ComboBox {
            id: cpdfSetCombo
            width: parent.width
            currentIndex: 0
            model: pdfModel
            textRole: "pdfSetName"
            onCurrentIndexChanged: {
                getQMinValue();
                getQMaxValue();
                getXMinValue();
                getXMaxValue();
                xMinField.text = xMinValue;
                xMaxField.text = xMaxValue;
                qMinField.text = qMinValue;
                qMaxField.text = qMaxValue;
            }
        }

        GridLayout {
            columns: 2
            columnSpacing: 15
            rowSpacing: 8

            // xMin TextField with DoubleValidator
            TextField {
                id: xMinField
                placeholderText: "xₘᵢₙ"
                text: xMinValue
                validator: DoubleValidator { }
                onEditingFinished: {
                    var num = parseFloat(text);
                    if (isNaN(num) || num < xMinValue || num > Number(xMaxField.text)) {
                        text = xMinValue;
                    } else {
                        xMinValue = num;
                    }
                }
            }

            // xMax TextField with DoubleValidator
            TextField {
                id: xMaxField
                placeholderText: "xₘₐₓ"
                text: xMaxValue
                validator: DoubleValidator { }
                onEditingFinished: {
                    var num = parseFloat(text);
                    if (isNaN(num) || num > xMaxValue || num < Number(xMinField.text)) {
                        text = xMaxValue;
                    } else {
                        xMaxValue = num;
                    }
                }
            }

            // qMin TextField with DoubleValidator
            TextField {
                id: qMinField
                placeholderText: "μₘᵢₙ"
                text: qMinValue
                validator: DoubleValidator { bottom: 0 }
                onEditingFinished: {
                    var num = parseFloat(text);
                    if (isNaN(num) || num < qMinValue || num > Number(qMaxField.text)) {
                        text = qMinValue;
                    } else {
                        qMinValue = num;
                    }
                }
            }

            // qMax TextField with DoubleValidator
            TextField {
                id: qMaxField
                placeholderText: "μₘₐₓ"
                text: qMaxValue
                validator: DoubleValidator { }
                onEditingFinished: {
                    var num = parseFloat(text);
                    if (isNaN(num) || num < Number(qMinField.text) || num > qMaxValue) {
                        text = qMaxValue;
                    } else {
                        qMaxValue = num;
                    }
                }
            }
        }
    }

    onAccepted: {
        if (isEditMode && objectRow) {
            objectRow.pdfSet = cpdfSetCombo.currentText;
            objectRow.properties = {
                xMin: Number(xMinField.text),
                xMax: Number(xMaxField.text),
                muMin: Number(qMinField.text),
                muMax: Number(qMaxField.text)
            };
        } else if (!isEditMode && objectRow) {
            var cpdf = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls.Material
                PDFObject {
                    pdfSet: "${cpdfSetCombo.currentText}"
                    properties: ({
                        xMin: ${xMinField.text},
                        xMax: ${xMaxField.text},
                        muMin: ${qMinField.text},
                        muMax: ${qMaxField.text}
                    })
                }
            `, leftSidRef);
        } else {
            console.error("objectRow is undefined");
        }
    }

    function setObjectRow(row) {
        objectRow = row;
    }

    Component.onCompleted: {}

    function getQMinValue() {
        if (cpdfSetCombo.currentIndex < 0) return;
        var QMin = pdfModel.get(cpdfSetCombo.currentIndex).QMin;
        qMinValue = Number(QMin);
    }

    function getQMaxValue() {
        if (cpdfSetCombo.currentIndex < 0) return;
        var QMax = pdfModel.get(cpdfSetCombo.currentIndex).QMax;
        qMaxValue = Number(QMax);
    }

    function getXMinValue() {
        if (cpdfSetCombo.currentIndex < 0) return;
        var XMin = pdfModel.get(cpdfSetCombo.currentIndex).XMin;
        xMinValue = Number(XMin);
    }

    function getXMaxValue() {
        if (cpdfSetCombo.currentIndex < 0) return;
        var XMax = pdfModel.get(cpdfSetCombo.currentIndex).XMax;
        xMaxValue = Number(XMax);
    }
}
