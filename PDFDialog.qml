import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtPDFxTMDPlotter 1.0

Dialog {
    id: cPDFDialog
    title: "PDF Plot Object"
    width: 500
    height: 400
    standardButtons: Dialog.Ok | Dialog.Cancel

    property bool isEditMode: false
    property string currentPDFSetName: ""
    property var leftSidRef
    property PDFObjectInfo objectRow
    property var partonFlavors: [] // Initialized as empty array
    property var swipeViewMainDlg

    property point dragStartPoint: Qt.point(0, 0)
    property bool isDragging: false

    // Properties to store user selections
    property string selectedPdfSet: ""
    property string selectedDisplayText: ""
    property color selectedColor: "#000000" // Default color
    property int selectedLineStyleIndex: 0
    property int selectedPartonFlavorIndex: 0
    property int selectedPlotTypeIndex: 0
    property int selectedTabIndex: 0

    onOpened: {
        console.log("Dialog opened, isEditMode:", isEditMode);
        pdfModel.fillPDFInfoModel();
        console.log("pdfModel count after fill:", pdfModel.pdfCount());

        if (isEditMode && objectRow) {
            selectedPdfSet = objectRow.pdfSet
            selectedDisplayText = objectRow.displayText
            selectedColor = objectRow.color
            selectedLineStyleIndex = objectRow.lineStyleIndex
            selectedPartonFlavorIndex = objectRow.partonFlavorIndex
            partonFlavors = objectRow.partonFlavors || []
            selectedPlotTypeIndex = objectRow.plotTypeIndex
            selectedTabIndex = objectRow.currentTabIndex

            colorPickerId.currentColor = selectedColor
            lineStyleId.currentIndex = selectedLineStyleIndex
            patonFlavorsId.currentIndex = selectedPartonFlavorIndex
            plotTypeId.currentIndex = selectedPlotTypeIndex

            var index = -1
            var rowCount = pdfModel.pdfCount()
            for (var i = 0; i < rowCount; i++) {
                if (pdfModel.get(i).pdfSetName === selectedPdfSet) {
                    index = i
                    break
                }
            }
            cpdfSetCombo.currentIndex = index !== -1 ? index : 0
        } else {
            selectedPdfSet = pdfModel.get(0).pdfSetName || ""
            selectedColor = getRandomMaterialColor()
            selectedLineStyleIndex = PDFDataProvider.Solid
            selectedPartonFlavorIndex = 0
            selectedPlotTypeIndex = PDFDataProvider.Mu2
            selectedTabIndex = swipeViewMainDlg ? swipeViewMainDlg.currentIndex : 0

            cpdfSetCombo.currentIndex = 0
            getPartonFlavors()
            colorPickerId.currentColor = selectedColor
            lineStyleId.currentIndex = 0
            patonFlavorsId.currentIndex = 0
            plotTypeId.currentIndex = PDFDataProvider.Mu2
        }
        currentPDFSetName = cpdfSetCombo.currentText
        updateDisplayText()
    }

    background: Rectangle {
        color: Material.dialogColor
        radius: 8
        MouseArea {
            anchors.fill: parent
            onPressed: {
                cPDFDialog.isDragging = true
                cPDFDialog.dragStartPoint = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {
                if (cPDFDialog.isDragging) {
                    cPDFDialog.x += mouse.x - cPDFDialog.dragStartPoint.x
                    cPDFDialog.y += mouse.y - cPDFDialog.dragStartPoint.y
                }
            }
            onReleased: {
                cPDFDialog.isDragging = false
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
                    if (checkedButton) console.log("Checked button text is", checkedButton.text)
                }
            }
            spacing: 10
            RadioButton { text: "cPDF"; checked: true; ButtonGroup.group: pdfTypeBtnGroup }
            RadioButton { text: "TMD"; ButtonGroup.group: pdfTypeBtnGroup }
        }

        GridLayout {
            columns: 4
            columnSpacing: 15
            rowSpacing: 8

            Label { text: "PDF set:" }
            ComboBox {
                id: cpdfSetCombo
                Layout.fillWidth: true
                model: pdfModel
                textRole: "pdfSetName"
                onCurrentTextChanged: {
                    selectedPdfSet = currentText
                    getPartonFlavors()
                    updateDisplayText()
                }
            }

            Label { text: "Parton Flavor:" }
            ComboBox {
                id: patonFlavorsId
                model: partonFlavors
                onModelChanged: {
                    console.log("patonFlavorsId model updated:", model)
                }
                onCurrentIndexChanged: {
                    selectedPartonFlavorIndex = currentIndex
                    updateDisplayText()
                }
            }

            Label { text: "Plot color:" }
            ColorPickerButton {
                id: colorPickerId
                onCurrentColorChanged: {
                    selectedColor = currentColor
                }
            }

            Label { text: "Plot line style:" }
            ComboBox {
                id: lineStyleId
                width: 200
                model: ["Solid", "Dashed", "Dotted", "Dash Dot"]
                onCurrentIndexChanged: {
                    selectedLineStyleIndex = currentIndex
                }
            }

            Label { text: "Plot type:" }
            ComboBox {
                id: plotTypeId
                width: 200
                model: ["x", "μ"]
                onCurrentIndexChanged: {
                    selectedPlotTypeIndex = currentIndex
                    updateDisplayText()
                }
            }
        }
    }

    onAccepted: {
        updateDisplayText()

        if (isEditMode && objectRow) {
            // Update existing PDFObjectInfo
            objectRow.pdfSet = selectedPdfSet
            objectRow.displayText = selectedDisplayText
            objectRow.color = selectedColor
            objectRow.lineStyleIndex = selectedLineStyleIndex
            objectRow.partonFlavorIndex = selectedPartonFlavorIndex
            objectRow.partonFlavors = partonFlavors
            objectRow.plotTypeIndex = selectedPlotTypeIndex
            objectRow.currentTabIndex = selectedTabIndex
            PDFDataProvider.notifyDataChanged(selectedTabIndex)
        } else if (!isEditMode && leftSidRef) {
            // Create new PDFObjectInfo in C++
            var info = PDFDataProvider.createPDFObjectInfo()
            if (info) {
                info.pdfSet = selectedPdfSet
                info.displayText = selectedDisplayText
                info.color = selectedColor
                info.lineStyleIndex = selectedLineStyleIndex
                info.partonFlavorIndex = selectedPartonFlavorIndex
                info.partonFlavors = partonFlavors
                info.plotTypeIndex = selectedPlotTypeIndex
                info.currentTabIndex = selectedTabIndex

                PDFDataProvider.setPDFData(selectedTabIndex, info)

                var component = Qt.createComponent("qrc:/PDFObjectItem.qml")
                if (component.status === Component.Ready) {
                    var newObject = component.createObject(leftSidRef, {
                        "pdfObjectInfo": info,
                        "x": 0,
                        "y": 0
                    })
                    if (!newObject) {
                        console.error("Failed to create PDFObjectItem")
                    }
                } else {
                    console.error("Component error:", component.errorString())
                }
            } else {
                console.error("Failed to create PDFObjectInfo")
            }
        } else {
            console.error("Invalid state: objectRow or leftSidRef undefined")
        }
    }

    function setObjectRow(row) {
        objectRow = row
    }

    function getPartonFlavors() {
        if (cpdfSetCombo.currentIndex < 0) {
            console.warn("Invalid cpdfSetCombo index:", cpdfSetCombo.currentIndex)
            partonFlavors = []
            return
        }
        var flavors = pdfModel.get(cpdfSetCombo.currentIndex).Flavors
        if (flavors) {
            partonFlavors = flavors.split(", ")
            console.log("Parton flavors updated:", partonFlavors)
        } else {
            console.warn("No flavors available for index:", cpdfSetCombo.currentIndex)
            partonFlavors = []
        }
        patonFlavorsId.model = null // Reset model
        patonFlavorsId.model = partonFlavors // Reassign to trigger update
    }

    function updateDisplayText() {
        selectedDisplayText = `${cpdfSetCombo.currentText}-(${patonFlavorsId.currentText})\nplot type: ${plotTypeId.currentText}`
    }

    function getRandomMaterialColor() {
        const materialColors = [
            [255, 38, 51],   // Red 500
            [255, 64, 129],  // Pink 500
            [255, 87, 34],   // Deep Orange 500
            [255, 152, 0],   // Orange 500
            [255, 193, 7],   // Amber 500
            [255, 215, 0],   // Yellow 500
            [139, 195, 74],  // Light Green 500
            [76, 175, 80],   // Green 500
            [33, 150, 243],  // Blue 500
            [3, 169, 244],   // Light Blue 500
            [103, 58, 183],  // Deep Purple 500
            [156, 39, 176]   // Purple 500
        ]
        const randomIndex = Math.floor(Math.random() * materialColors.length)
        const [r, g, b] = materialColors[randomIndex]
        return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`
    }
}
