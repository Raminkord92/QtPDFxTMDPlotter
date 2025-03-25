import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts
import QtQuick.Layouts
import QtQuick.Dialogs // Added for FileDialog
import QtPDFxTMDPlotter 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    property bool expandedAxisType: false
    property bool expandedAxisRange: false
    property bool expandedExport: false
    property var xAxisLinearRef: xAxisLinear
    property var xAxisLogRef: xAxisLog
    property var yAxisLinearRef: yAxisLinear
    property var yAxisLogRef: yAxisLog
    property int plotTabIndex: 0
    property var m_data
    property bool isXAxisLog: false
    property bool isYAxisLog: false
    signal busyIndicatorIsActivated(bool isActivated)

    Component.onDestruction: {
        PDFDataProvider.deleteTab(plotTabIndex)
    }

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

            BusyIndicator {
                id: loadingIndicator
                running: false
                anchors.centerIn: parent
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
                            Text {
                                text: "\uf107"
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
                                    isXAxisLog = false
                                    switchAxis()
                                }
                            }
                            RadioButton {
                                text: "Logarithmic"
                                ButtonGroup.group: xAxisGroup
                                onCheckedChanged: if (checked) {
                                    isXAxisLog = true
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
                                    isYAxisLog = false
                                    switchAxis()
                                }
                            }
                            RadioButton {
                                text: "Logarithmic"
                                ButtonGroup.group: yAxisGroup
                                onCheckedChanged: if (checked) {
                                    isYAxisLog = true
                                    switchAxis()
                                }
                            }

                            Label { text: "Axis titles" }
                            TextField { id: xAxisTitle; placeholderText: "x axis title"; text: "x" }
                            TextField { id: yAxisTitle; placeholderText: "y axis title"; text: "Y" }
                            Label { text: "Plot title" }
                            TextField { id: plotTitle; placeholderText: "plot title"; text: "PDF plot" }
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
                            Text {
                                text: "\uf107"
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
                        opacity: expandedAxisRange ? 1 : 0
                        GridLayout {
                            columns: 4
                            rowSpacing: 10
                            columnSpacing: 10
                            Layout.alignment: Qt.AlignHCenter

                            Label { text: "X Min:" }
                            TextField {
                                id: xMinField
                                placeholderText: "X Min"
                                validator: DoubleValidator {}
                                onEditingFinished: {}
                            }

                            Label { text: "X Max:" }
                            TextField {
                                id: xMaxField
                                placeholderText: "X Max"
                                validator: DoubleValidator {}
                                onEditingFinished: {
                                    var num = parseFloat(text)
                                    if (isNaN(num) || num < Number(xMinField.text)) {
                                        text = xMax
                                    } else {
                                        xMax = num
                                    }
                                }
                            }

                            Label { text: "Y Min:" }
                            TextField {
                                id: yMinField
                                placeholderText: "Y Min"
                                validator: DoubleValidator {}
                                onEditingFinished: {}
                            }

                            Label { text: "Y Max:" }
                            TextField {
                                id: yMaxField
                                placeholderText: "Y Max"
                                validator: DoubleValidator {}
                                onEditingFinished: {
                                    var num = parseFloat(text)
                                    if (isNaN(num) || num < Number(yMinField.text)) {
                                        text = yMax
                                    } else {
                                        yMax = num
                                    }
                                }
                            }
                        }
                    }
                }

                // Collapsible Section: Export
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        id: exportHeader
                        Layout.fillWidth: true
                        height: 30
                        color: Material.accentColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 10

                            Label {
                                text: "Export"
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: "\uf107"
                                font.family: fontAwesome.name
                                font.pixelSize: 16
                                rotation: expandedExport ? 180 : 0
                                Behavior on rotation {
                                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: expandedExport = !expandedExport
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        visible: expandedExport

                        RowLayout {
                            spacing: 10

                            Button {
                                visible: false
                                text: "Export to PDF"
                                onClicked: pdfDialog.open()
                            }
                            Button {
                                text: "Export to PNG"
                                onClicked: pngDialog.open()
                            }
                            Button {
                                text: "Export to JPG"
                                onClicked: jpgDialog.open()
                            }
                            Button {
                                text: "Export to CSV"
                                onClicked: csvDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    // File Dialogs for Export
    FileDialog {
        id: pdfDialog
        title: "Export to PDF"
        visible: false
        fileMode: FileDialog.SaveFile
        nameFilters: ["PDF files (*.pdf)"]
        defaultSuffix: "pdf"
        onAccepted: {
            chartView.grabToImage(function(result) {
                var selectedPath = "";
                if (Qt.platform.os === "windows") {
                    selectedPath = selectedFile.toString().replace("file:///", "")
                }
                else
                {
                    selectedPath = selectedFile.toString().replace("file://", "")
                }
                plotExporter.exportToPDF(result.image, selectedPath)
            })
        }
    }

    FileDialog {
        id: pngDialog
        title: "Export to PNG"
        fileMode: FileDialog.SaveFile
        nameFilters: ["PNG files (*.png)"]
        defaultSuffix: "png"
        onAccepted: {
            var selectedPath = "";
            if (Qt.platform.os === "windows") {
                selectedPath = selectedFile.toString().replace("file:///", "")
            }
            else
            {
                selectedPath = selectedFile.toString().replace("file://", "")
            }
            saveChart(selectedPath)
        }
    }

    FileDialog {
        id: jpgDialog
        title: "Export to JPG"
        fileMode: FileDialog.SaveFile
        nameFilters: ["JPG files (*.jpg)"]
        defaultSuffix: "jpg"
        onAccepted: {
            var selectedPath = "";
            if (Qt.platform.os === "windows") {
                selectedPath = selectedFile.toString().replace("file:///", "")
            }
            else
            {
                selectedPath = selectedFile.toString().replace("file://", "")
            }

            saveChart(selectedPath)
        }
    }

    FileDialog {
        id: csvDialog
        title: "Export to CSV"
        fileMode: FileDialog.SaveFile
        nameFilters: ["CSV files (*.csv)"]
        defaultSuffix: "csv"
        onAccepted: {
            var selectedPath = "";
            if (Qt.platform.os === "windows") {
                selectedPath = selectedFile.toString().replace("file:///", "")
            }
            else
            {
                selectedPath = selectedFile.toString().replace("file://", "")
            }
            exportToCSV(selectedPath)
        }
    }



    // Series list and data handling
    property var seriesList: []
    Connections {
        target: PDFDataProvider
        function onPdfDataChanged(tabIndex) {
            if (tabIndex === plotTabIndex) {
                loadingIndicator.running = true
                root.busyIndicatorIsActivated(true);
                PDFDataProvider.getPDFData(tabIndex) // Async call
            }
        }

        function onPdfDataReady(tabIndex, data) {
            if (tabIndex === plotTabIndex) {
                m_data = data
                updatePlot(m_data, isXAxisLog ? xAxisLog : xAxisLinear, isYAxisLog ? yAxisLog : yAxisLinear)
                loadingIndicator.running = false
                root.busyIndicatorIsActivated(false);
            }
        }
    }

    function updatePlot(infos, xAxisType, yAxisType) {
        for (var i = 0; i < seriesList.length; i++) {
            chartView.removeSeries(seriesList[i])
        }
        seriesList = []

        for (var j = 0; j < infos.length; j++) {
            var info = infos[j]
            var series = chartView.createSeries(
                ChartView.SeriesTypeLine,
                info.displayText || "PDF Data " + j,
                xAxisType,
                yAxisType
            )

            series.color = info.color
            switch (info.lineStyleIndex) {
                case PDFDataProvider.Solid: series.style = Qt.SolidLine; break
                case PDFDataProvider.Dashed: series.style = Qt.DashLine; break
                case PDFDataProvider.Dotted: series.style = Qt.DotLine; break
                case PDFDataProvider.DashDot: series.style = Qt.DashDotLine; break
                default: series.style = Qt.SolidLine
            }

            updateSeries(series, info)
            seriesList.push(series)
        }
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
                xMinField.text = formatNumber(xMin)
                xMaxField.text = formatNumber(xMax)
            } else {
                xMinField.text = formatNumber(Math.max(1e-7, xMin))
                xMaxField.text = formatNumber(xMax)
            }
            if (yAxisGroup.checkedButton.text === "Linear") {
                yMinField.text = formatNumber(yMin)
                yMaxField.text = formatNumber(yMax)
            } else {
                yMinField.text = formatNumber(Math.max(1e-7, yMin))
                yMaxField.text = formatNumber(yMax)
            }
        }
    }

    function formatNumber(value) {
        var num = Number(value)
        if (Math.abs(num) < 1e-4 || Math.abs(num) >= 1e6) {
            return num.toExponential(4)
        } else {
            return num.toFixed(4)
        }
    }

    function saveChart(filename) {
        chartView.grabToImage(function(result) {
            result.saveToFile(filename)
        }, Qt.size(1800, 1200))
    }

    function exportToCSV(fileName) {
        var maxPoints = 0
        for (var i = 0; i < m_data.length; i++) {
            var series = m_data[i]
            if (series.xVals.length > maxPoints) {
                maxPoints = series.xVals.length
            }
        }

        var csvContent = ""
        var header = ""
        for (var i = 0; i < m_data.length; i++) {
            if (i > 0) {
                header += ","
            }
            header += "displayText" + i + ",X" + i + ",Y" + i
        }
        csvContent += header + "\n"

        for (var j = 0; j < maxPoints; j++) {
            var row = ""
            for (var i = 0; i < m_data.length; i++) {
                if (i > 0) {
                    row += ","
                }
                var series = m_data[i]
                var seriesName = series.displayText || ("Series " + i)
                if (j < series.xVals.length) {
                    row += '"' + seriesName + '",' + series.xVals[j] + ',' + series.yVals[j]
                } else {
                    row += '"' + seriesName + '",,'
                }
            }
            csvContent += row + "\n"
        }
        fileWriter.writeToFile(fileName, csvContent)
    }

    function updateSeries(series, info) {
        series.clear()
        var xVals = info.xVals
        var yVals = info.yVals

        if (xVals.length !== yVals.length) {
            return
        }
        for (var i = 0; i < xVals.length; i++) {
            series.append(xVals[i], yVals[i])
        }
    }

    function switchAxis() {
        xAxisLinear.visible = !isXAxisLog
        yAxisLinear.visible = !isYAxisLog
        xAxisLog.visible = isXAxisLog
        yAxisLog.visible = isYAxisLog
        updatePlot(m_data, isXAxisLog ? xAxisLog : xAxisLinear, isYAxisLog ? yAxisLog : yAxisLinear)
    }
}
