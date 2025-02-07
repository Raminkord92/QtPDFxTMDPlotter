import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: root
    width: 30
    height: 30
    radius: 15
    color: "lightblue"
    
    property string pdfSet
    property var properties
    
    Text {
        anchors.centerIn: parent
        text: "TMD"
        font.pixelSize: 10
    }
    
    MouseArea {
        anchors.fill: parent
        drag.target: parent
        
        // onReleased: {
        //     if (dropArea.containsDrag) {
        //         parent.parent = itemsFlow
        //     }
        //     parent.x = parent.x
        //     parent.y = parent.y
        // }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -4
        radius: 17
        color: "transparent"
        border.color: Material.accent
        border.width: 2
        // opacity: parent.parent === itemsFlow ? 1 : 0
    }
}
