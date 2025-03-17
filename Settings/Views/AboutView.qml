 import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import "../../GeneralComponents"

ColumnLayout {
    spacing: 20
    width: parent.width
    height: parent.height
    Label {
        text: "About QtPDFxTMDPlotter"
        font.bold: true
        font.pixelSize: 18
        Layout.alignment: Qt.AlignHCenter
    }

    Label {
        text: "Version 1.0.0"  // Replace with your actual version
        Layout.alignment: Qt.AlignHCenter
    }

    Rectangle {
        height: 1
        color: "lightgray"
        Layout.fillWidth: true
        Layout.margins: 10
    }

    LinkedLabel {
        text: "I did this project during weekends as a side project with love ❤️. This application allows you to create plots of cPDFs and TMDs using PDFxTMDLib.\n For any issues, feel free to contact me via email or through my GitHub repo. Also, <a href='https://raminkord92.github.io'>raminkord92.github.io</a> is my personal blog if you want to know more about me."

    }

    LinkedLabel {
        text: "<b>GitHub:</b> <a href='https://github.com/Raminkord92/QtPDFxTMDPlotter'>github.com/Raminkord92/QtPDFxTMDPlotter</a>"
    }

    LinkedLabel {
        text: "<b>Contact:</b> <a href='mailto:raminkord92@gmail.com'>raminkord92@gmail.com</a>"
    }

    Item {
        Layout.fillHeight: true
    }
}
