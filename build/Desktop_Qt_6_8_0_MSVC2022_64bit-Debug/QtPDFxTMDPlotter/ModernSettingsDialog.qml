import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Dialog {
    id: root
    title: qsTr("Settings")
    modal: true
    dim: true
    standardButtons: Dialog.Close
    focus: true

    width: 960
    height: 640
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    property var menuItems: [
        {text: qsTr("PDF"), icon: "qrc:/icons/pdf.svg", component: pdfPage},
        // Add more items like:
        // {text: "Appearance", icon: "qrc:/icons/palette.svg", component: appearancePage}
    ]

    Material.theme: Material.System
    Material.primary: Material.BlueGrey
    Material.accent: Material.Blue

    header: ToolBar {
        height: 48
        Material.background: Material.background
        Material.elevation: 2

        Label {
            text: root.title
            anchors.centerIn: parent
            font.pixelSize: 18
            font.weight: Font.Medium
            color: Material.primaryTextColor
        }
    }

    contentItem: Rectangle {
        color: Material.background

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // Left Navigation Panel
            ColumnLayout {
                Layout.preferredWidth: 240
                Layout.fillHeight: true
                spacing: 0

                // Search Bar
                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.margins: 12
                    placeholderText: qsTr("Search settings...")
                    leftPadding: 36
                    rightPadding: 12
                    font.pixelSize: 14
                    Material.accent: Material.primaryColor

                    background: Rectangle {
                        radius: 8
                        color: Material.primaryColor.window
                        border.width: 0.5
                        border.color: Qt.darker(Material.background, 1.1)
                    }

                    Image {
                        source: "qrc:/icons/search.svg"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        sourceSize: Qt.size(16, 16)
                        opacity: 0.6
                    }
                }

                // Navigation List
                ListView {
                    id: navList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.menuItems
                    currentIndex: 0
                    interactive: contentHeight > height
                    highlight: Rectangle {
                        color: Material.primaryColor
                        opacity: 0.1
                        radius: 4
                    }
                    highlightMoveDuration: 150

                    delegate: SidebarButton {
                        width: navList.width
                        text: modelData.text
                        iconSource: modelData.icon
                        selected: navList.currentIndex === index
                        onClicked: {
                            navList.currentIndex = index
                            contentStack.replace(modelData.component)
                        }
                    }

                    ScrollIndicator.vertical: ScrollIndicator {
                        width: 6
                        active: navList.interactive
                    }
                }
            }

            // Right Content Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Material.backgroundColor

                StackView {
                    id: contentStack
                    anchors.fill: parent
                    initialItem: pdfPage
                    replaceEnter: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 120
                        }
                    }
                    replaceExit: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 120
                        }
                    }
                }
            }
        }
    }

    Component { id: pdfPage; PDFSetSettings {} }

    // Reusable Components
    Component {
        id: sidebarButtonComponent
        SidebarButton {}
    }

    Component {
        id: settingsGroupComponent
        SettingsGroup {}
    }

    // Handle Escape key
    Keys.onEscapePressed: close()
}
