import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Label {
            text: "PDF Settings"
            font.bold: true
            font.pixelSize: 16
        }

        CheckBox {
            text: "Auto-save PDF changes"
            checked: true
        }

        RowLayout {
            Label { text: "Default PDF Viewer:" }
            ComboBox {
                model: ["Internal Viewer", "System Default", "Custom Application"]
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Label { text: "Zoom Level:" }
            Slider {
                value: 1.0
                from: 0.5
                to: 2.0
                stepSize: 0.1
                Layout.fillWidth: true
            }
        }
    }
}
