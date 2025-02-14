import QtQuick
import QtQuick.Controls.Material
import QtPDFxTMDPlotter

Rectangle {
    id: draggableRect
    width: Math.max(30, textMetrics.width + 10)
    height: Math.max(30, textMetrics.height + 10)
    radius: 15
    color: "lightgreen"
    anchors.centerIn: parent
    property string pdfSet : ''
    property var properties
    PDFDialog
    {
        id: pdfDialog
        qMinValue: properties.muMin
        qMaxValue: properties.muMax
        xMinValue: properties.xMin
        xMaxValue: properties.xMax
        currentPDFSetName: pdfSet
        isEditMode: true
    }

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
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
        drag.target: dragMode === "move" ? parent : undefined
        drag.maximumX: draggableRect.parent ? draggableRect.parent.width - draggableRect.width : 0
        drag.maximumY: draggableRect.parent ? draggableRect.parent.height - draggableRect.height : 0
        drag.minimumX: 0
        drag.minimumY: 0

        property string dragMode: "move"
        property point pressPos: Qt.point(0,0)
        property rect initialRect: Qt.rect(0,0,0,0)

        onPressed: (mouse) => {
            var edgeThreshold = 10;
            var x = mouse.x;
            var y = mouse.y;
            var w = draggableRect.width;
            var h = draggableRect.height;

            var isLeft = x < edgeThreshold;
            var isRight = x > w - edgeThreshold;
            var isTop = y < edgeThreshold;
            var isBottom = y > h - edgeThreshold;

            var isTopLeft = isLeft && isTop;
            var isTopRight = isRight && isTop;
            var isBottomLeft = isLeft && isBottom;
            var isBottomRight = isRight && isBottom;

            if (isTopLeft) {
                dragMode = "resize-top-left";
            } else if (isTopRight) {
                dragMode = "resize-top-right";
            } else if (isBottomLeft) {
                dragMode = "resize-bottom-left";
            } else if (isBottomRight) {
                dragMode = "resize-bottom-right";
            } else if (isLeft) {
                dragMode = "resize-left";
            } else if (isRight) {
                dragMode = "resize-right";
            } else if (isTop) {
                dragMode = "resize-top";
            } else if (isBottom) {
                dragMode = "resize-bottom";
            } else {
                dragMode = "move";
            }

            pressPos = Qt.point(mouse.x, mouse.y);
            initialRect = Qt.rect(draggableRect.x, draggableRect.y, draggableRect.width, draggableRect.height);
        }

        onPositionChanged: (mouse) => {
            if (!pressed || dragMode === "move") return;

            var deltaX = mouse.x - pressPos.x;
            var deltaY = mouse.y - pressPos.y;

            switch(dragMode) {
                case "resize-right": {
                    var maxWidth = draggableRect.parent ? draggableRect.parent.width - draggableRect.x : Number.MAX_VALUE;
                    draggableRect.width = Math.min(Math.max(30, initialRect.width + deltaX), maxWidth);
                    break;
                }
                case "resize-bottom": {
                    var maxHeight = draggableRect.parent ? draggableRect.parent.height - draggableRect.y : Number.MAX_VALUE;
                    draggableRect.height = Math.min(Math.max(30, initialRect.height + deltaY), maxHeight);
                    break;
                }
                case "resize-left": {
                    var newWidth = initialRect.width - deltaX;
                    if (newWidth >= 30) {
                        var newX = Math.max(0, initialRect.x + deltaX);
                        draggableRect.x = newX;
                        draggableRect.width = newWidth;
                    }
                    break;
                }
                case "resize-top": {
                    var newHeight = initialRect.height - deltaY;
                    if (newHeight >= 30) {
                        var newY = Math.max(0, initialRect.y + deltaY);
                        draggableRect.y = newY;
                        draggableRect.height = newHeight;
                    }
                    break;
                }
                case "resize-top-left": {
                    var newWidth = initialRect.width - deltaX;
                    var newHeight = initialRect.height - deltaY;
                    if (newWidth >= 30 && newHeight >= 30) {
                        var newX = Math.max(0, initialRect.x + deltaX);
                        var newY = Math.max(0, initialRect.y + deltaY);
                        draggableRect.x = newX;
                        draggableRect.y = newY;
                        draggableRect.width = newWidth;
                        draggableRect.height = newHeight;
                    }
                    break;
                }
                case "resize-top-right": {
                    var newWidth = initialRect.width + deltaX;
                    var newHeight = initialRect.height - deltaY;
                    var maxWidth = draggableRect.parent ? draggableRect.parent.width - draggableRect.x : Number.MAX_VALUE;
                    if (newHeight >= 30) {
                        var newY = Math.max(0, initialRect.y + deltaY);
                        draggableRect.y = newY;
                        draggableRect.height = newHeight;
                        draggableRect.width = Math.min(Math.max(30, newWidth), maxWidth);
                    }
                    break;
                }
                case "resize-bottom-left": {
                    var newWidth = initialRect.width - deltaX;
                    var newHeight = initialRect.height + deltaY;
                    var maxHeight = draggableRect.parent ? draggableRect.parent.height - draggableRect.y : Number.MAX_VALUE;
                    if (newWidth >= 30) {
                        var newX = Math.max(0, initialRect.x + deltaX);
                        draggableRect.x = newX;
                        draggableRect.width = newWidth;
                        draggableRect.height = Math.min(Math.max(30, newHeight), maxHeight);
                    }
                    break;
                }
                case "resize-bottom-right": {
                    var newWidth = initialRect.width + deltaX;
                    var newHeight = initialRect.height + deltaY;
                    var maxWidth = draggableRect.parent ? draggableRect.parent.width - draggableRect.x : Number.MAX_VALUE;
                    var maxHeight = draggableRect.parent ? draggableRect.parent.height - draggableRect.y : Number.MAX_VALUE;
                    draggableRect.width = Math.min(Math.max(30, newWidth), maxWidth);
                    draggableRect.height = Math.min(Math.max(30, newHeight), maxHeight);
                    break;
                }
            }
        }

        onReleased: {
            dragMode = "move"; // Reset drag mode when releasing mouse
        }

        onDoubleClicked: {
            pdfDialog.setObjectRow(draggableRect);  // Set objectRow to the current PDFObject instance.
            pdfDialog.isEditMode = true;
            pdfDialog.open();
        }

        onMouseXChanged: updateCursor()
        onMouseYChanged: updateCursor()

        function updateCursor() {
            if (pressed) return;

            var edgeThreshold = 10;
            var x = mouseX;
            var y = mouseY;
            var w = draggableRect.width;
            var h = draggableRect.height;

            var isLeft = x < edgeThreshold;
            var isRight = x > w - edgeThreshold;
            var isTop = y < edgeThreshold;
            var isBottom = y > h - edgeThreshold;

            var isTopLeft = isLeft && isTop;
            var isTopRight = isRight && isTop;
            var isBottomLeft = isLeft && isBottom;
            var isBottomRight = isRight && isBottom;

            if (isTopLeft || isBottomRight) {
                cursorShape = Qt.SizeFDiagCursor;
            } else if (isTopRight || isBottomLeft) {
                cursorShape = Qt.SizeBDiagCursor;
            } else if (isLeft || isRight) {
                cursorShape = Qt.SizeHorCursor;
            } else if (isTop || isBottom) {
                cursorShape = Qt.SizeVerCursor;
            } else {
                cursorShape = Qt.ArrowCursor;
            }
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
