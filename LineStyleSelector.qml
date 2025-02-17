import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: lineStyleSelector
    // Expose the currently selected line style (e.g. "Solid", "Dashed", etc.)
    property string selectedStyle: ""
    signal styleChanged(string newStyle)

    // Adjust the overall size based on the row’s content.
    width: contentRow.implicitWidth
    height: contentRow.implicitHeight

    Row {
        id: contentRow
        spacing: 5

        // The available line style options.
        Repeater {
            model: ["Solid", "Dashed", "Dotted", "Dash Dot"]
            delegate: Item {
                id: optionItem
                width: 30; height: 30
                property bool isSelected: (lineStyleSelector.selectedStyle === modelData)

                // A rounded rectangle that gives visual feedback.
                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    // When selected, use Material accent; otherwise, a light border.
                    color: isSelected ? Material.accent : "transparent"
                    border.color: isSelected ? Material.primary : "#CCCCCC"
                    border.width: 2

                    // A Canvas to render a preview line with the appropriate dash pattern.
                    Canvas {
                        id: lineCanvas
                        anchors.centerIn: parent
                        width: parent.width * 0.8
                        height: 10
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            ctx.strokeStyle = "black";
                            ctx.lineWidth = 2;
                            // Set the dash pattern based on the option.
                            if (modelData === "Solid")
                                ctx.setLineDash([]);
                            else if (modelData === "Dashed")
                                ctx.setLineDash([6, 4]);
                            else if (modelData === "Dotted")
                                ctx.setLineDash([2, 2]);
                            else if (modelData === "Dash Dot")
                                ctx.setLineDash([6, 3, 2, 3]);
                            ctx.beginPath();
                            ctx.moveTo(0, height / 2);
                            ctx.lineTo(width, height / 2);
                            ctx.stroke();
                        }
                        Component.onCompleted: requestPaint()
                    }
                }

                // A MouseArea makes the whole option clickable.
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        lineStyleSelector.selectedStyle = modelData;
                        lineStyleSelector.styleChanged(modelData);
                    }
                }
            }
        }
    }
}
