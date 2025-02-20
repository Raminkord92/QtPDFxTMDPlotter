import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtPDFxTMDPlotter 1.0

Dialog {
    id: cPDFDialog
    title: "PDF Plot Object"
    width: 500
    height: 400
    property bool isEditMode: false
    property string currentPDFSetName: ''
    standardButtons: Dialog.Ok | Dialog.Cancel
    property var leftSidRef
    property Item objectRow
    property var partonFlavors;
    property string selectedPartonFlavor: ''
    // Make the dialog movable
    property point dragStartPoint: Qt.point(0, 0)
    property bool isDragging: false
    property alias selectedColor: colorPickerId.currentColor
    property alias lineStyleIndex: lineStyleId.currentIndex
    property alias currentPartonFlavorIndex: patonFlavorsId.currentIndex
    property alias currentPlotTypeIndex: plotTypeId.currentIndex
    property var swipeViewMainDlg;
    onOpened: {
        pdfModel.fillPDFInfoModel();

        if (isEditMode)
        {
            selectedColor = objectRow.color;
            lineStyleIndex = objectRow.lineStyleIndex;
            currentPartonFlavorIndex: objectRow.partonFlavorIndex;
            var index = -1;
            var rowCount_ = pdfModel.pdfCount()
            for (var i = 0; i < rowCount_; i++) {
                if (pdfModel.get(i).pdfSetName === objectRow.pdfSet) {
                    index = i;
                    break;
                }
            }
            if (index !== -1) {
                cpdfSetCombo.currentIndex = index; // Set the currentIndex instead of currentText
            } else {
                console.warn("PDF set not found in the model:", objectRow.pdfSet);
            }

        }else {
            getPartonFlavors();
            console.log("salam Component.onCompleted")
            cpdfSetCombo.currentIndex = 0;
        }
        currentPDFSetName = cpdfSetCombo.currentText

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



        GridLayout {
            columns: 4
            columnSpacing: 15
            rowSpacing: 8
            Label {
                text: "PDF set:"
            }

            ComboBox {
                id: cpdfSetCombo
                width: parent.width
                currentIndex: 0
                model: pdfModel
                textRole: "pdfSetName"
                onCurrentIndexChanged: {
                }
            }
            Label {
                text: "Parton Flavor:"
            }
            ComboBox {
                id: patonFlavorsId
                model: partonFlavors
            }
            Label {
                text: "Plot color:"
            }
            ColorPickerButton {
                id: colorPickerId
            }
            Label {
                text: "Plot line style:"
            }
            ComboBox {
                id: lineStyleId
                width: 200
                model: [ "Solid", "Dashed", "Dotted", "Dash Dot" ]
            }
            Label {
                text: "Plot type:"
            }
            ComboBox {
                id: plotTypeId
                width: 200
                model: [ "x","μ"]// "kₜ",
            }
        }
    }

    onAccepted: {
        if (isEditMode && objectRow) {
            objectRow.pdfSet = cpdfSetCombo.currentText;
            objectRow.displayText = cpdfSetCombo.currentText +"-" + patonFlavorsId.currentText + "\nplot type: " + plotTypeId.currentText;
            objectRow.color = selectedColor;
            objectRow.lineStyleIndex = lineStyleId.currentIndex;
            objectRow.partonFlavorIndex = currentPartonFlavorIndex;
            objectRow.partonFlavors_ = partonFlavors;
            objectRow.currentTabIndex = swipeViewMainDlg.currentIndex;
            objectRow.plotTypeIndex = currentPlotTypeIndex;

        } else if (!isEditMode && objectRow) {
            var cpdf = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls.Material
                PDFObject {
                    pdfSet: "${cpdfSetCombo.currentText}"
                    displayText: "${cpdfSetCombo.currentText}-(${patonFlavorsId.currentText})\nplot type: ${plotTypeId.currentText}"
                    color: "${selectedColor}"
                    lineStyleIndex: ${lineStyleId.currentIndex}
                    partonFlavorIndex: ${currentPartonFlavorIndex}
                    partonFlavors_: ${JSON.stringify(partonFlavors)}
                    currentTabIndex: ${swipeViewMainDlg.currentIndex}
                    plotTypeIndex: ${currentPlotTypeIndex}
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

    function getPartonFlavors(){
        if (cpdfSetCombo.currentIndex < 0) return;
        var flavors = pdfModel.get(cpdfSetCombo.currentIndex).Flavors;
        partonFlavors = flavors.split(", ")
        console.log("flavors are " + partonFlavors)
    }
}
