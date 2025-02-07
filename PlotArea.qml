import QtQuick 2.15
import QtCharts 2.15

ChartView {
    id: chartView
    title: "Dynamic Plot"
    antialiasing: true

    property var plotModel: ({
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 10
    })

    ValueAxis {
        id: axisX
        min: plotModel.minX
        max: plotModel.maxX
        titleText: "x"
    }

    ValueAxis {
        id: axisY
        min: plotModel.minY
        max: plotModel.maxY
        titleText: "PDF Value"
    }

    LineSeries {
        id: lineSeries
        name: "PDF Values"
        axisX: axisX
        axisY: axisY

        // Update plot when model changes
        Connections {
            target: dragDropModel
            function onRowsInserted() {
                updatePlot()
            }
            function onRowsRemoved() {
                updatePlot()
            }
        }
    }

    // Function to update the plot
    function updatePlot() {
        lineSeries.clear()
        for (var i = 0; i < dragDropModel.rowCount(); ++i) {
            var item = dragDropModel.get(i)
            if (item && item.properties) {
                lineSeries.append(item.properties.x, item.properties.y || 0)
            }
        }
    }

    Component.onCompleted: {
        updatePlot()
    }
}
