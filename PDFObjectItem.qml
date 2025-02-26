import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtPDFxTMDPlotter 1.0

Rectangle {
    id: root
    width: Math.max(30, textMetrics.width + 10)
    height: Math.max(30, textMetrics.height + 10)
    radius: 15
    color: pdfObjectInfo ? pdfObjectInfo.color : "lightgreen"
    anchors.centerIn: parent

    property PDFObjectInfo pdfObjectInfo

    Text {
        id: textElement
        anchors.centerIn: parent
        text: pdfObjectInfo ? pdfObjectInfo.displayText : ""
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
        drag.target: dragMode === "move" ? root : undefined
        drag.maximumX: root.parent ? root.parent.width - root.width : 0
        drag.maximumY: root.parent ? root.parent.height - root.height : 0
        drag.minimumX: 0
        drag.minimumY: 0

        property string dragMode: "move"
        property point pressPos: Qt.point(0, 0)
        property rect initialRect: Qt.rect(0, 0, 0, 0)

        onPressed: (mouse) => {
            var edgeThreshold = 10;
            var x = mouse.x;
            var y = mouse.y;
            var w = root.width;
            var h = root.height;

            var isLeft = x < edgeThreshold;
            var isRight = x > w - edgeThreshold;
            var isTop = y < edgeThreshold;
            var isBottom = y > h - edgeThreshold;

            var isTopLeft = isLeft && isTop;
            var isTopRight = isRight && isTop;
            var isBottomLeft = isLeft && isBottom;
            var isBottomRight = isRight && isBottom;

            if (isTopLeft) dragMode = "resize-top-left";
            else if (isTopRight) dragMode = "resize-top-right";
            else if (isBottomLeft) dragMode = "resize-bottom-left";
            else if (isBottomRight) dragMode = "resize-bottom-right";
            else if (isLeft) dragMode = "resize-left";
            else if (isRight) dragMode = "resize-right";
            else if (isTop) dragMode = "resize-top";
            else if (isBottom) dragMode = "resize-bottom";
            else dragMode = "move";

            pressPos = Qt.point(mouse.x, mouse.y);
            initialRect = Qt.rect(root.x, root.y, root.width, root.height);
        }

        onPositionChanged: (mouse) => {
            if (!pressed || dragMode === "move") return;

            var deltaX = mouse.x - pressPos.x;
            var deltaY = mouse.y - pressPos.y;

            switch(dragMode) {
                case "resize-right": {
                    var maxWidth = root.parent ? root.parent.width - root.x : Number.MAX_VALUE;
                    root.width = Math.min(Math.max(30, initialRect.width + deltaX), maxWidth);
                    break;
                }
                case "resize-bottom": {
                    var maxHeight = root.parent ? root.parent.height - root.y : Number.MAX_VALUE;
                    root.height = Math.min(Math.max(30, initialRect.height + deltaY), maxHeight);
                    break;
                }
                case "resize-left": {
                    var newWidth = initialRect.width - deltaX;
                    if (newWidth >= 30) {
                        var newX = Math.max(0, initialRect.x + deltaX);
                        root.x = newX;
                        root.width = newWidth;
                    }
                    break;
                }
                case "resize-top": {
                    var newHeight = initialRect.height - deltaY;
                    if (newHeight >= 30) {
                        var newY = Math.max(0, initialRect.y + deltaY);
                        root.y = newY;
                        root.height = newHeight;
                    }
                    break;
                }
                case "resize-top-left": {
                    var newWidth = initialRect.width - deltaX;
                    var newHeight = initialRect.height - deltaY;
                    if (newWidth >= 30 && newHeight >= 30) {
                        var newX = Math.max(0, initialRect.x + deltaX);
                        var newY = Math.max(0, initialRect.y + deltaY);
                        root.x = newX;
                        root.y = newY;
                        root.width = newWidth;
                        root.height = newHeight;
                    }
                    break;
                }
                case "resize-top-right": {
                    var newWidth = initialRect.width + deltaX;
                    var newHeight = initialRect.height - deltaY;
                    var maxWidth = root.parent ? root.parent.width - root.x : Number.MAX_VALUE;
                    if (newHeight >= 30) {
                        var newY = Math.max(0, initialRect.y + deltaY);
                        root.y = newY;
                        root.height = newHeight;
                        root.width = Math.min(Math.max(30, newWidth), maxWidth);
                    }
                    break;
                }
                case "resize-bottom-left": {
                    var newWidth = initialRect.width - deltaX;
                    var newHeight = initialRect.height + deltaY;
                    var maxHeight = root.parent ? root.parent.height - root.y : Number.MAX_VALUE;
                    if (newWidth >= 30) {
                        var newX = Math.max(0, initialRect.x + deltaX);
                        root.x = newX;
                        root.width = newWidth;
                        root.height = Math.min(Math.max(30, newHeight), maxHeight);
                    }
                    break;
                }
                case "resize-bottom-right": {
                    var newWidth = initialRect.width + deltaX;
                    var newHeight = initialRect.height + deltaY;
                    var maxWidth = root.parent ? root.parent.width - root.x : Number.MAX_VALUE;
                    var maxHeight = root.parent ? root.parent.height - root.y : Number.MAX_VALUE;
                    root.width = Math.min(Math.max(30, newWidth), maxWidth);
                    root.height = Math.min(Math.max(30, newHeight), maxHeight);
                    break;
                }
            }
        }

        onReleased: {
            dragMode = "move";
        }

        onDoubleClicked: {
            if (pdfObjectInfo) {
                dialogComponent.createObject(root, {
                    "objectRow": pdfObjectInfo,
                    "isEditMode": true,
                    "swipeViewMainDlg": root.parent,
                    "leftSidRef": root.parent
                }).open();
            }
        }

        onMouseXChanged: updateCursor()
        onMouseYChanged: updateCursor()

        function updateCursor() {
            if (pressed) return;

            var edgeThreshold = 10;
            var x = mouseX;
            var y = mouseY;
            var w = root.width;
            var h = root.height;

            var isLeft = x < edgeThreshold;
            var isRight = x > w - edgeThreshold;
            var isTop = y < edgeThreshold;
            var isBottom = y > h - edgeThreshold;

            var isTopLeft = isLeft && isTop;
            var isTopRight = isRight && isTop;
            var isBottomLeft = isLeft && isBottom;
            var isBottomRight = isRight && isBottom;

            if (isTopLeft || isBottomRight) cursorShape = Qt.SizeFDiagCursor;
            else if (isTopRight || isBottomLeft) cursorShape = Qt.SizeBDiagCursor;
            else if (isLeft || isRight) cursorShape = Qt.SizeHorCursor;
            else if (isTop || isBottom) cursorShape = Qt.SizeVerCursor;
            else cursorShape = Qt.ArrowCursor;
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

    Component {
        id: dialogComponent
        PDFDialog {
            currentPDFSetName: pdfObjectInfo ? pdfObjectInfo.pdfSet : ""
            partonFlavors: pdfObjectInfo ? pdfObjectInfo.partonFlavors : []
            objectRow : this
        }
    }

    onParentChanged: {
        if (parent && parent.width > 0 && parent.height > 0) {
            x = Math.min(Math.max(0, x), parent.width - width);
            y = Math.min(Math.max(0, y), parent.height - height);
        }
    }

    Component.onCompleted: {
        if (pdfObjectInfo) {
            console.log("Current tab index:", pdfObjectInfo.currentTabIndex);
        }
        if (parent) {
            parent.widthChanged.connect(function() {
                x = Math.min(Math.max(0, x), parent.width - width);
            });
            parent.heightChanged.connect(function() {
                y = Math.min(Math.max(0, y), parent.height - height);
            });
            root.anchors.centerIn = undefined
        }
    }
}
