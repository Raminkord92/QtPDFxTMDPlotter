import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts
import QtQuick.Layouts

Item {
    id: root
    width: parent.width
    height: parent.height
    property bool expandedAxisType: false
    property bool expandedAxisRange: false

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

            title: "Dynamic Plot"
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

            ValuesAxis { id: xAxisLinear; titleText: xAxisTitle.text; min: 0; max: 10; visible: true; gridVisible: true; labelsFont.pixelSize: 12 }
            LogValueAxis { id: xAxisLog; titleText: "X Axis (Log)"; labelFormat: "%g"; base: 10; min: 1; max: 10; visible: false; gridVisible: true; labelsFont.pixelSize: 12 }
            ValuesAxis { id: yAxisLinear; titleText: yAxisTitle.text; min: 0; max: 10; visible: true; gridVisible: true; labelsFont.pixelSize: 12 }
            LogValueAxis { id: yAxisLog; titleText: "Y Axis (Log)"; labelFormat: "%g"; base: 10; min: 1; max: 10; visible: false; gridVisible: true; labelsFont.pixelSize: 12 }

            LineSeries {
                id: lineSeries
                name: "PDF Values"
                axisX: xAxisLinear
                axisY: yAxisLinear
                color: Material.accent
                width: 2
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
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
                                                      switchXAxis("Linear")
                                                      xMinSpinBox.from = -100
                                                  }
                            }
                            RadioButton {
                                text: "Logarithmic"
                                ButtonGroup.group: xAxisGroup
                                onCheckedChanged: if (checked) {
                                                      switchXAxis("Logarithmic")
                                                      xMinSpinBox.from = 1
                                                      if (xMinSpinBox.value <= 0) xMinSpinBox.value = 1
                                                  }
                            }

                            Label { text: "Y Axis" }
                            ButtonGroup { id: yAxisGroup }
                            RadioButton {
                                text: "Linear"
                                checked: true
                                ButtonGroup.group: yAxisGroup
                                onCheckedChanged: if (checked) {
                                                      switchYAxis("Linear")
                                                      yMinSpinBox.from = -100
                                                  }
                            }
                            RadioButton {
                                text: "Logarithmic"
                                ButtonGroup.group: yAxisGroup
                                onCheckedChanged: if (checked) {
                                                      switchYAxis("Logarithmic")
                                                      yMinSpinBox.from = 1
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
                            columns: 2
                            rowSpacing: 10
                            columnSpacing: 10
                            Layout.alignment: Qt.AlignHCenter

                            Label { text: "X Min:" }
                            RowLayout {
                                Slider {
                                    id: xMinSlider
                                    from: xAxisGroup.checkedButton.text === "Logarithmic" ? 1 : -100
                                    to: 100
                                    value: xMinSpinBox.value
                                    onValueChanged: xMinSpinBox.value = value
                                }
                                SpinBox {
                                    id: xMinSpinBox
                                    from: xAxisGroup.checkedButton.text === "Logarithmic" ? 1 : -100
                                    to: 100
                                    value: 0
                                    onValueChanged: xMinSlider.value = value
                                }
                            }

                            Label { text: "X Max:" }
                            RowLayout {
                                Slider {
                                    id: xMaxSlider
                                    from: -100
                                    to: 100
                                    value: xMaxSpinBox.value
                                    onValueChanged: xMaxSpinBox.value = value
                                }
                                SpinBox {
                                    id: xMaxSpinBox
                                    from: -100
                                    to: 100
                                    value: 10
                                    onValueChanged: xMaxSlider.value = value
                                }
                            }

                            Label { text: "Y Min:" }
                            RowLayout {
                                Slider {
                                    id: yMinSlider
                                    from: yAxisGroup.checkedButton.text === "Logarithmic" ? 1 : -100
                                    to: 100
                                    value: yMinSpinBox.value
                                    onValueChanged: yMinSpinBox.value = value
                                }
                                SpinBox {
                                    id: yMinSpinBox
                                    from: yAxisGroup.checkedButton.text === "Logarithmic" ? 1 : -100
                                    to: 100
                                    value: 0
                                    onValueChanged: yMinSlider.value = value
                                }
                            }

                            Label { text: "Y Max:" }
                            RowLayout {
                                Slider {
                                    id: yMaxSlider
                                    from: -100
                                    to: 100
                                    value: yMaxSpinBox.value
                                    onValueChanged: yMaxSpinBox.value = value
                                }
                                SpinBox {
                                    id: yMaxSpinBox
                                    from: -100
                                    to: 100
                                    value: 10
                                    onValueChanged: yMaxSlider.value = value
                                }
                            }
                        }
                        // Control Buttons
                        RowLayout {
                            spacing: 20
                            Layout.alignment: Qt.AlignHCenter

                            Button {
                                text: "Apply Changes"
                                Material.background: Material.accent
                                onClicked: applyChanges()
                            }

                            Button {
                                text: "Reset"
                                Material.background: Material.Grey
                                onClicked: resetChart()
                            }
                        }
                    }
                }


            }
        }
    }

    // Helper Functions
    function switchXAxis(scaleType) {
        if (scaleType === "Linear") {
            lineSeries.axisX = xAxisLinear
            xAxisLinear.visible = true
            xAxisLog.visible = false
        } else if (scaleType === "Logarithmic") {
            lineSeries.axisX = xAxisLog
            xAxisLog.visible = true
            xAxisLinear.visible = false
        }
    }

    function switchYAxis(scaleType) {
        if (scaleType === "Linear") {
            lineSeries.axisY = yAxisLinear
            yAxisLinear.visible = true
            yAxisLog.visible = false
        } else if (scaleType === "Logarithmic") {
            lineSeries.axisY = yAxisLog
            yAxisLog.visible = true
            yAxisLinear.visible = false
        }
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
        xMinSpinBox.value = 0
        xMaxSpinBox.value = 10
        yMinSpinBox.value = 0
        yMaxSpinBox.value = 10
        applyChanges()
    }
}

