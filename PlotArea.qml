import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts
import QtQuick.Layouts
import QtPDFxTMDPlotter 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    property bool expandedAxisType: false
    property bool expandedAxisRange: false
    property var xAxisLinearRef: xAxisLinear
    property var xAxisLogRef: xAxisLog
    property var yAxisLinearRef: yAxisLinear
    property var yAxisLogRef: yAxisLog
    property var swipeViewMain: null
    property var m_data
    property bool isXAxisLog: false;
    property bool isYAxisLog: false;
    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical
        Layout.fillHeight: true
        Layout.minimumHeight: 400

        handle: Rectangle {
            implicitHeight: 4
            color: Material.DeepOrange
            opacity: 0.5
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
            }
        }

        ChartView {
            id: chartView
            Layout.preferredHeight: root.height * 0.75
            antialiasing: true
            SplitView.fillHeight: true

            title: plotTitle.text
            titleFont.bold: true
            titleFont.pixelSize: 16
            backgroundColor: Material.backgroundColor
            legend.visible: true
            legend.alignment: Qt.AlignBottom
            margins {
                top: 10
                bottom: 10
                left: 10
                right: 10
            }

            ValuesAxis {
                id: xAxisLinear
                titleText: xAxisTitle.text
                min: Number(xMinField.text)
                max: Number(xMaxField.text)
                gridVisible: true
                labelsFont.pixelSize: 12
            }
            LogValueAxis {
                id: xAxisLog
                titleText: xAxisTitle.text
                labelFormat: "%g"
                base: 10
                min: Number(xMinField.text)
                max: Number(xMaxField.text)
                gridVisible: true
                labelsFont.pixelSize: 12
            }
            ValuesAxis {
                id: yAxisLinear
                titleText: yAxisTitle.text
                min: Number(yMinField.text)
                max: Number(yMaxField.text)
                gridVisible: true
                labelsFont.pixelSize: 12
            }
            LogValueAxis {
                id: yAxisLog
                titleText: yAxisTitle.text
                labelFormat: "%g"
                base: 10
                min: Number(yMinField.text)
                max: Number(yMaxField.text)
                gridVisible: true
                labelsFont.pixelSize: 12
            }
        }

        ScrollView {
            id: optionsFlickable
            Layout.preferredHeight: root.height * 0.25
            contentWidth: parent.width
            contentHeight: optionsColumn.implicitHeight
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            ColumnLayout {
                id: optionsColumn
                width: parent.width
                spacing: 10
                Layout.alignment: Qt.AlignHCenter
                // Collapsible Section: Axis Types
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Layout.alignment: Qt.AlignHCenter


                    Rectangle {
                        id: axisTypesHeader
                        Layout.fillWidth: true
                        height: 30
                        color: Material.accentColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 10

                            Label {
                                text: "Axis Types"
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            // FontAwesome arrow icon. Adjust the Unicode character as needed.
                            Text {
                                text: "\uf107"   // Unicode for a downward arrow in FontAwesome
                                font.family: fontAwesome.name
                                font.pixelSize: 16
                                rotation: expandedAxisType ? 180 : 0
                                Behavior on rotation {
                                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: expandedAxisType = !expandedAxisType
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        visible: expandedAxisType
                        Layout.alignment: Qt.AlignHCenter

                        GridLayout {
                            columns: 3
                            columnSpacing: 15
                            rowSpacing: 8

                            Label { text: "X Axis" }
                            ButtonGroup { id: xAxisGroup }
                            RadioButton {
                                text: "Linear"
                                checked: true
                                ButtonGroup.group: xAxisGroup
                                onCheckedChanged: if (checked) {
                                                      isXAxisLog = false;
                                                      switchAxis()
                                                  }
                            }
                            RadioButton {
                                text: "Logarithmic"
                                ButtonGroup.group: xAxisGroup
                                onCheckedChanged: if (checked) {
                                                      isXAxisLog = true;
                                                      switchAxis()
                                                  }
                            }

                            Label { text: "Y Axis" }
                            ButtonGroup { id: yAxisGroup }
                            RadioButton {
                                text: "Linear"
                                checked: true
                                ButtonGroup.group: yAxisGroup
                                onCheckedChanged: if (checked) {
                                                      isYAxisLog = false;
                                                      switchAxis()
                                                  }
                            }
                            RadioButton {
                                text: "Logarithmic"
                                ButtonGroup.group: yAxisGroup
                                onCheckedChanged: if (checked) {
                                                      isYAxisLog = true;
                                                      switchAxis()
                                                      if (yMinSpinBox.value <= 0) yMinSpinBox.value = 1
                                                  }
                            }

                            Label
                            {
                                text: "Axis titles"
                            }
                            TextField
                            {
                                id: xAxisTitle
                                placeholderText: "x axis title"
                                text: "x"
                            }
                            TextField
                            {
                                id: yAxisTitle
                                placeholderText: "y axis title"
                                text: "Y"
                            }
                            Label
                            {
                                text: "Plot title"
                            }
                            TextField
                            {
                                id: plotTitle
                                placeholderText: "plot title"
                                text: "PDF plot"

                            }
                        }
                    }
                }

                // Collapsible Section: Axis Ranges
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        id: axisRangesHeader
                        Layout.fillWidth: true
                        height: 30
                        color: Material.accentColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 10

                            Label {
                                text: "Axis Ranges"
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            // FontAwesome arrow icon. Adjust the Unicode character as needed.
                            Text {
                                text: "\uf107"   // Unicode for a downward arrow in FontAwesome
                                font.family: fontAwesome.name
                                font.pixelSize: 16
                                rotation: expandedAxisRange ? 180 : 0
                                Behavior on rotation {
                                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: expandedAxisRange = !expandedAxisRange
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        visible: expandedAxisRange
                        Layout.alignment: Qt.AlignHCenter
                        // Add a Behavior for smooth opacity transition
                        opacity: expandedAxisRange ? 1 : 0
                        GridLayout {
                            columns: 4
                            rowSpacing: 10
                            columnSpacing: 10
                            Layout.alignment: Qt.AlignHCenter

                            Label { text: "X Min:" }
                            TextField
                            {
                                id: xMinField
                                placeholderText: "X Min"
                                validator: DoubleValidator { }
                                onEditingFinished: {

                                }
                            }

                            Label { text: "X Max:" }
                            TextField
                            {
                                id: xMaxField
                                placeholderText: "X Max"
                                validator: DoubleValidator { }
                                onEditingFinished: {

                                }
                            }

                            Label { text: "Y Min:" }
                            TextField
                            {
                                id: yMinField
                                placeholderText: "Y Min"
                                validator: DoubleValidator { }
                                onEditingFinished: {

                                }
                            }

                            Label { text: "Y Max:" }
                            TextField
                            {
                                id: yMaxField
                                placeholderText: "Y Max"
                                validator: DoubleValidator { }
                            }
                        }
                    }
                }
            }
        }
    }

    // List to keep track of created series
       property var seriesList: []

       // Connect to PDFDataProvider
       Connections {
           target: PDFDataProvider
           function onPdfDataChanged(tabIndex) {
               console.log("received signal")

               if (tabIndex === swipeViewMain.currentIndex) {
                   m_data = PDFDataProvider.getPDFData(tabIndex)
                   updatePlot(m_data, xAxisLinear, yAxisLinear)
               }
           }
       }


       // Function to update the plot with a vector of PDFObjectInfo
       function updatePlot(infos, xAxisType, yAxisType) {
           // Clear existing series
           for (var i = 0; i < seriesList.length; i++) {
               chartView.removeSeries(seriesList[i])
           }
           seriesList = []

           // Create new series for each PDFObjectInfo
           for (var j = 0; j < infos.length; j++) {
               var info = infos[j]
               var series = chartView.createSeries(
                   ChartView.SeriesTypeLine,           // Series type
                   info.displayText || "PDF Data " + j, // Name
                   xAxisType,                        // X-axis (default)
                   yAxisType                         // Y-axis (default)
               )

               // Set series properties
               series.color = info.color
               switch (info.lineStyleIndex) {
                   case PDFDataProvider.Solid: series.style = Qt.SolidLine; break
                   case PDFDataProvider.Dashed: series.style = Qt.DashLine; break
                   case PDFDataProvider.Dotted: series.style = Qt.DotLine; break
                   case PDFDataProvider.DashDot: series.style = Qt.DashDotLine; break
                   default: series.style = Qt.SolidLine
               }

               // Update series data
               updateSeries(series, info)
               seriesList.push(series)
           }

           // Adjust axis ranges
           var xMin = Infinity, xMax = -Infinity, yMin = Infinity, yMax = -Infinity
           for (var k = 0; k < infos.length; k++) {
               var xVals = infos[k].xVals
               var yVals = infos[k].yVals
               if (xVals.length > 0) {
                   xMin = Math.min(xMin, Math.min(...xVals))
                   xMax = Math.max(xMax, Math.max(...xVals))
                   yMin = Math.min(yMin, Math.min(...yVals))
                   yMax = Math.max(yMax, Math.max(...yVals))
               }
           }

           if (xMin !== Infinity) {
               if (xAxisGroup.checkedButton.text === "Linear") {
                   xMinField.text = xMin
                   xMaxField.text = xMax
                   // xAxisLinear.min = xMin
                   // xAxisLinear.max = xMax
               } else {
                   xMinField.text = Math.max(1, xMin)
                   xMaxField.text = xMax
                   // xAxisLog.min = Math.max(1, xMin)
                   // xAxisLog.max = xMax
               }
               if (yAxisGroup.checkedButton.text === "Linear") {
                   yMinField.text = yMin
                   yMaxField.text = yMax
                   // yAxisLinear.min = yMin
                   // yAxisLinear.max = yMax
               } else {
                   yMinField.text = Math.max(1, yMin)
                   yMaxField.text = yMax
                   // yAxisLog.min = Math.max(1, yMin)
                   // yAxisLog.max = yMax
               }
           }
       }

       // Function to update an individual series
       function updateSeries(series, info) {
           series.clear()
           var xVals = info.xVals
           var yVals = info.yVals

           if (xVals.length !== yVals.length) {
               console.log("Error: xVals and yVals have different lengths for " + info.displayText)
               return
           }

           for (var i = 0; i < xVals.length; i++) {
               series.append(xVals[i], yVals[i])
           }
       }

    // Helper Functions
    function switchAxis(scaleType) {
        xAxisLinear.visible = !isXAxisLog
        yAxisLinear.visible = !isYAxisLog
        xAxisLog.visible = isXAxisLog
        yAxisLog.visible = isYAxisLog
        updatePlot(m_data, isXAxisLog ? xAxisLog : xAxisLinear, isYAxisLog ? yAxisLog : yAxisLinear)
    }


    function applyChanges() {
        if (xMinSpinBox.value < xMaxSpinBox.value && yMinSpinBox.value < yMaxSpinBox.value) {
            xAxisLinear.min = xMinSpinBox.value
            xAxisLinear.max = xMaxSpinBox.value
            yAxisLinear.min = yMinSpinBox.value
            yAxisLinear.max = yMaxSpinBox.value
            xAxisLog.min = Math.max(1, xMinSpinBox.value)
            xAxisLog.max = xMaxSpinBox.value
            yAxisLog.min = Math.max(1, yMinSpinBox.value)
            yAxisLog.max = yMaxSpinBox.value
        } else {
            console.log("Invalid range: minimum must be less than maximum.")
        }
    }

    function resetChart() {
        xMinSpinBox.value = 1
        xMaxSpinBox.value = 1000
        yMinSpinBox.value = 1
        yMaxSpinBox.value = 1000
        applyChanges()
    }
}

