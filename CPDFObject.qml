import QtQuick
import QtQuick.Controls.Material
import QtPDFxTMDPlotter

Rectangle {
    id: draggableRect
    width: Math.max(30, textMetrics.width + 10)
    height: Math.max(30, textMetrics.height + 10)
    radius: 15
    color: "lightgreen"
    // parent: GlobalContext.leftSideRef
    anchors.centerIn: parent

    property string pdfSet
    property var properties
    // property var plotModel: ({
    //     minX: 0,
    //     maxX: 10,
    //     minY: 0,
    //     maxY: 10
    // })

    Text {
        id: textElement
        anchors.centerIn: parent
        text: parent.pdfSet
        font.pixelSize: 10
    }

    TextMetrics {
        id: textMetrics
        text: textElement.text
        font: textElement.font
    }

    MouseArea {
        anchors.fill: parent
        drag.target: parent

        // Ensure the rectangle stays within bounds during dragging
        drag.maximumX: draggableRect.parent.width - draggableRect.width
        drag.minimumX: 0
        drag.maximumY: draggableRect.parent.height - draggableRect.height
        drag.minimumY: 0

        onDoubleClicked: {
            console.log("CPDFObject Info:");
            console.log("pdfSet: " + parent.pdfSet);
            console.log("x: " + parent.properties.x);
            console.log("mu: " + parent.properties.mu);
            // You can also show a dialog here if needed
            // console.log("xMin ", parent.plotModel.maxX);
            plotModel.testCallObject();
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -4
        radius: 17
        color: "transparent"
        border.color: Material.accent
        border.width: 2
    }

    onParentChanged: {
        if (parent && parent.width > 0 && parent.height > 0) {
            x = Math.min(Math.max(0, x), parent.width - width)
            y = Math.min(Math.max(0, y), parent.height - height)
        }
    }

    Component.onCompleted: {
        if (parent) {
            parent.widthChanged.connect(() => {
                                            x = Math.min(Math.max(0, x), parent.width - width)
                                        })
            parent.heightChanged.connect(() => {
                                             y = Math.min(Math.max(0, y), parent.height - height)
                                         })
            draggableRect.anchors.centerIn = undefined

        }
    }
}
