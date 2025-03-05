import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtPDFxTMDPlotter 1.0
import QtQuick.Dialogs

Dialog {
    id: cPDFDialog
    title: "PDF Plot Object"
    width: 450
    height: 340
    standardButtons: Dialog.Ok | Dialog.Cancel

    // Dialog state properties
    property bool isEditMode: false             // True if editing an existing object
    property string currentPDFSetName: ""       // Name of the currently selected PDF set
    property var leftSidRef                     // Reference to parent or container
    property PDFObjectInfo objectRow            // Data for the PDF object being edited/created
    property var swipeViewMainDlg               // Reference to swipe view in main dialog
    property var partonFlavors: []              // Array of parton flavors for the selected PDF set

    // User selection properties
    property string selectedPdfSet: ""          // Selected PDF set name
    property string selectedDisplayText: ""     // Display text for the PDF object
    property color selectedColor: "#000000"     // Color of the plot
    property int selectedLineStyleIndex: 0      // Index of the selected line style
    property int selectedPartonFlavorIndex: 0   // Index of the selected parton flavor
    property int selectedPlotTypeIndex: 0       // Index of the selected plot type
    property int selectedTabIndex: 0            // Current tab index
    property string pdfType: "cPDF"  // "cPDF" or "TMD"
    property string plotType: plotTypeId.currentText
    property double selectedXValue: 0.0        // Value for "x"
    property double selectedMuValue: 0.0       // Value for "μ"
    property double ktValue: 0.0       // Value for "kt"
    property double qMinValue: 0.0
    property double qMaxValue: 100.0
    property double xMinValue: 0.0
    property double xMaxValue: 1.0
    // Dragging properties
    property point dragStartPoint: Qt.point(0, 0)
    property bool isDragging: false
    onOpened: {
        initializeUI()
    }

    background: Rectangle {
        color: Material.dialogColor
        radius: 8
        MouseArea {
            anchors.fill: parent
            onPressed: {
                isDragging = true
                dragStartPoint = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {
                if (isDragging) {
                    cPDFDialog.x += mouse.x - dragStartPoint.x
                    cPDFDialog.y += mouse.y - dragStartPoint.y
                }
            }
            onReleased: {
                isDragging = false
            }
        }
    }

    PDFInfoModel {
        id: pdfModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        TabBar {
            id: tabBar
            width: parent.width
            TabButton { text: "PDF Settings" }
            TabButton { text: "Plot kinematics" }
            TabButton { text: "Plot Appearance" }
        }

        StackLayout {
            width: parent.width
            currentIndex: tabBar.currentIndex

            // PDF Settings Tab
            ColumnLayout {
                spacing: 10

                RowLayout {
                    ButtonGroup {
                        id: pdfTypeBtnGroup
                        onCheckedButtonChanged: {
                            if (checkedButton) console.log("Checked button text:", checkedButton.text)
                            // TODO: Implement filtering or remove if not needed
                        }
                    }
                    spacing: 10
                    RadioButton { text: "cPDF"; checked: true; ButtonGroup.group: pdfTypeBtnGroup }
                    RadioButton { text: "TMD"; ButtonGroup.group: pdfTypeBtnGroup }
                }

                GridLayout {
                    columns: 4
                    columnSpacing: 7
                    rowSpacing: 7

                    Label { text: "PDF set:" }
                    ComboBox {
                        id: cpdfSetCombo
                        model: pdfModel
                        textRole: "pdfSetName"
                        onCurrentTextChanged: {
                            selectedPdfSet = currentText
                            getPartonFlavors()
                            updateDisplayText()
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

                    Label { text: "Parton Flavor:" }
                    ComboBox {
                        id: partonFlavorsId
                        model: partonFlavors
                        onCurrentIndexChanged: {
                            selectedPartonFlavorIndex = currentIndex
                            updateDisplayText()
                        }
                    }
                }
            }

            // Plot Appearance Tab
            ColumnLayout {
                spacing: 10
                GridLayout {
                    columns: 4
                    columnSpacing: 7
                    rowSpacing: 7
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
                    // "x" Input Field
                    Label {
                        text: "x value:"
                        visible: (pdfType === "cPDF" && plotType === "μ") || (pdfType === "TMD" && plotType === "μ")
                    }
                    TextField {
                        id: xInput
                        visible: (pdfType === "cPDF" && plotType === "μ") || (pdfType === "TMD" && plotType === "μ")
                        placeholderText: "Enter x"
                        text: selectedXValue
                        validator: DoubleValidator { }
                        onEditingFinished: {
                            var num = parseFloat(text);
                            if (isNaN(num) || num < xMinValue || num > xMaxValue) {
                                text = selectedXValue;
                            } else {
                                selectedXValue = num;
                                // You can add code here to adjust xMaxField's validator if needed.
                            }
                        }
                    }

                    // "μ" Input Field
                    Label {
                        text: "μ value:"
                        visible: (pdfType === "cPDF" && plotType === "x") || (pdfType === "TMD" && plotType === "x")
                    }
                    TextField {
                        id: muInput
                        visible: (pdfType === "cPDF" && plotType === "x") || (pdfType === "TMD" && plotType === "x")
                        placeholderText: "Enter μ"
                        validator: DoubleValidator { }
                        text: selectedMuValue
                        onEditingFinished: {
                            var num = parseFloat(text);
                            if (isNaN(num) || num < qMinValue || num > qMaxValue) {
                                text = selectedMuValue;
                            } else {
                                selectedMuValue = num;
                                // You can add code here to adjust xMaxField's validator if needed.
                            }
                        }
                    }

                    // "kt" Input Field
                    Label {
                        text: "kt:"
                        visible: pdfType === "TMD"
                    }
                    TextField {
                        id: ktInput
                        visible: pdfType === "TMD"
                        placeholderText: "Enter kt"
                        validator: DoubleValidator { }
                        onTextChanged: ktValue = parseFloat(text) || 0.0
                    }
                    Label
                    {
                        text: "xₘᵢₙ"
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 0) || (pdfType === "TMD" && plotTypeId.currentIndex === 0)

                    }

                    // xMin TextField with DoubleValidator
                    TextField {
                        id: xMinField
                        placeholderText: "xₘᵢₙ"
                        text: xMinValue
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 0) || (pdfType === "TMD" && plotTypeId.currentIndex === 0)
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
                    Label
                    {
                        text: "xₘₐₓ"
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 0) || (pdfType === "TMD" && plotTypeId.currentIndex === 0)
                    }

                    TextField {
                        id: xMaxField
                        placeholderText: "xₘₐₓ"
                        text: xMaxValue
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 0) || (pdfType === "TMD" && plotTypeId.currentIndex === 0)
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
                    Label
                    {
                        text: "μₘᵢₙ"
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 1) || (pdfType === "TMD" && plotTypeId.currentIndex === 1)

                    }
                    // qMin TextField with DoubleValidator
                    TextField {
                        id: qMinField
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 1) || (pdfType === "TMD" && plotTypeId.currentIndex === 1)
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
                    Label
                    {
                        text: "μₘₐₓ"
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 1) || (pdfType === "TMD" && plotTypeId.currentIndex === 1)

                    }
                    // qMax TextField with DoubleValidator
                    TextField {
                        id: qMaxField
                        placeholderText: "μₘₐₓ"
                        visible: (pdfType === "cPDF" && plotTypeId.currentIndex === 1) || (pdfType === "TMD" && plotTypeId.currentIndex === 1)
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

            // Advanced Options Tab
            ColumnLayout {
                spacing: 10

                GridLayout {
                    columns: 2
                    columnSpacing: 15
                    rowSpacing: 8

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
                }
            }
        }
    }

    onAccepted: {
        updateDisplayText()
        if (isEditMode) {
            updateExistingObject()
        } else {
            createNewObject()
        }
    }

    // Initialize the dialog UI based on edit or create mode
    function initializeUI() {
        console.log("Dialog opened, isEditMode:", isEditMode)
        pdfModel.fillPDFInfoModel()
        console.log("pdfModel count after fill:", pdfModel.pdfCount())

        if (isEditMode && objectRow) {
            selectedPdfSet = objectRow.pdfSet
            selectedDisplayText = objectRow.displayText
            selectedColor = objectRow.color
            selectedLineStyleIndex = objectRow.lineStyleIndex
            selectedPartonFlavorIndex = objectRow.partonFlavorIndex
            partonFlavors = objectRow.partonFlavors || []
            selectedPlotTypeIndex = objectRow.plotTypeIndex
            selectedTabIndex = objectRow.currentTabIndex
            selectedXValue = objectRow.currentXVal;
            selectedMuValue = objectRow.currentMuVal;
            colorPickerId.currentColor = selectedColor
            lineStyleId.currentIndex = selectedLineStyleIndex
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
            getPartonFlavors()
            partonFlavorsId.currentIndex = selectedPartonFlavorIndex < partonFlavors.length ? selectedPartonFlavorIndex : 0
            console.log("qMinField " + qMinField);
            console.log("qMaxField " + qMaxField);
            console.log("xMinField " + xMinField);
            console.log("xMaxField " + xMaxField);
            qMinField.text = objectRow.muMin
            qMaxField.text = objectRow.muMax
            xMinField.text = objectRow.xMin
            xMaxField.text = objectRow.xMax
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
            partonFlavorsId.currentIndex = 0
            plotTypeId.currentIndex = PDFDataProvider.Mu2
        }
        currentPDFSetName = cpdfSetCombo.currentText
        updateDisplayText()
        if (!isEditMode)
        {
            getQMinValue();
            getQMaxValue();
            getXMinValue();
            getXMaxValue();
            selectedXValue = getRandomNumber(xMinValue, xMaxValue)
            selectedMuValue = getRandomNumber(qMinValue, qMaxValue)

        }
    }

    // Update an existing PDF object with user selections
    function updateExistingObject() {
        if (objectRow) {
            objectRow.pdfSet = selectedPdfSet
            objectRow.displayText = selectedDisplayText
            objectRow.color = selectedColor
            objectRow.lineStyleIndex = selectedLineStyleIndex
            objectRow.partonFlavorIndex = selectedPartonFlavorIndex
            objectRow.partonFlavors = partonFlavors
            objectRow.plotTypeIndex = selectedPlotTypeIndex
            objectRow.currentTabIndex = selectedTabIndex
            objectRow.currentMuVal = selectedMuValue;
            objectRow.currentXVal = selectedXValue;
            objectRow.xMin = Number(xMinField.text);
            objectRow.xMax = Number(xMaxField.text);
            objectRow.muMin = Number(qMinField.text);
            objectRow.muMax = Number(qMaxField.text);
            console.log("objectRow.muMin " + objectRow.muMin + " objectRow.muMax " + objectRow.muMax)
            PDFDataProvider.notifyDataChanged(selectedTabIndex)
            // PDFDataProvider.setPDFData(selectedTabIndex, objectRow)

        }

    }

    Dialog {
        id: warningDialog
        title: "Warning"
        standardButtons: Dialog.Ok

        Label {
            text: "The selected plot type does not match the tab’s plot type."
        }

        // Optional: Customize the background
        background: Rectangle {
            color: Material.dialogColor
            radius: 8
        }
    }
    function createNewObject() {
        if (!leftSidRef) {
            console.error("leftSidRef is undefined")
            return
        }
        var currentTabPlotType = PDFDataProvider.getPlotTypeOfTab(selectedTabIndex);
        console.log("currentTabPlotType" + currentTabPlotType + " selectedPlotTypeIndex" + selectedPlotTypeIndex)
        if (currentTabPlotType !== -1 && currentTabPlotType !== selectedPlotTypeIndex)
        {
            warningDialog.open();
            return;
        }

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
            info.currentXVal = selectedXValue
            info.currentMuVal = selectedMuValue;
            info.xMin = Number(xMinField.text);
            info.xMax = Number(xMaxField.text);
            info.muMin = Number(qMinField.text);
            info.muMax = Number(qMaxField.text);
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
    }

    // Set the object row data externally
    function setObjectRow(row) {
        objectRow = row
    }

    // Update parton flavors based on the selected PDF set
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
            partonFlavors = []
            console.warn("No flavors for index:", cpdfSetCombo.currentIndex)
        }
        partonFlavorsId.model = partonFlavors
        partonFlavorsId.currentIndex = 0 // Reset to first item
    }

    // Update the display text based on current selections
    function updateDisplayText() {
        //x
        console.log("plotTypeId " + plotTypeId.currentIndex)
        if (plotTypeId.currentIndex === 0)
        {
        selectedDisplayText = `${cpdfSetCombo.currentText}-(${partonFlavorsId.currentText})\nplot type:  ${plotTypeId.currentText}, μ=${selectedMuValue}`
        }
        else if (plotTypeId.currentIndex === 1)
        {
        selectedDisplayText = `${cpdfSetCombo.currentText}-(${partonFlavorsId.currentText})\nplot type:  ${plotTypeId.currentText},  x=${selectedXValue}`
        }


    }
    // Generate a random material color as a color object
    function getRandomMaterialColor() {
        const materialColors = [
            Qt.rgba(1.0, 0.149, 0.2, 1),   // Red 500
            Qt.rgba(1.0, 0.251, 0.506, 1), // Pink 500
            Qt.rgba(1.0, 0.341, 0.133, 1), // Deep Orange 500
            Qt.rgba(1.0, 0.596, 0, 1),     // Orange 500
            Qt.rgba(1.0, 0.757, 0.027, 1), // Amber 500
            Qt.rgba(1.0, 0.843, 0, 1),     // Yellow 500
            Qt.rgba(0.545, 0.765, 0.29, 1),// Light Green 500
            Qt.rgba(0.298, 0.686, 0.314, 1), // Green 500
            Qt.rgba(0.129, 0.588, 0.953, 1), // Blue 500
            Qt.rgba(0.012, 0.663, 0.957, 1), // Light Blue 500
            Qt.rgba(0.404, 0.227, 0.718, 1), // Deep Purple 500
            Qt.rgba(0.612, 0.153, 0.69, 1)   // Purple 500
        ]
        return materialColors[Math.floor(Math.random() * materialColors.length)]
    }
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
    function getRandomNumber(min, max) {
            return Number((Math.random() * (max - min) + min).toFixed(6));
        }
}
