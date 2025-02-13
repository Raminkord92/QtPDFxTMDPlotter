import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtPDFxTMDPlotter 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 600
    minimumWidth: 600
    minimumHeight: 400
    title: "PDF & TMD Plotter"

    // Theme configuration
    Material.theme: Material.System
    Material.primary: Material.BlueGrey
    Material.accent: Material.Blue
    Material.background: Material.color(Material.Grey, Material.Shade50)

    // Shared properties
    property color buttonHoverColor: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.1)
    property int currentTabIndex: 0

    FontLoader {
        id: fontAwesome
        source: "qrc:/fonts/fonts/otfs/Font Awesome 6 Free-Solid-900.otf"
    }

    ListModel {
        id: tabModel
        ListElement { title: "Page 1" }
    }
    SettingDialog
    {
        id: settingDialog
    }


    // Main UI
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            // Tab Bar
            TabBar {
                id: tabBarConfig
                currentIndex: root.currentTabIndex
                Layout.fillWidth: true

                Repeater {
                    model: tabModel
                    delegate: TabButton {
                        width: 100
                        padding: 8

                        contentItem: Text {
                            text: model.title
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            color: Material.foreground
                        }

                        ToolTip.visible: hovered && (textMetrics.width > width)
                        ToolTip.text: model.title
                        TextMetrics { id: textMetrics; text: model.title }

                        background: Rectangle {
                            color: parent.hovered ? buttonHoverColor : "transparent"
                            radius: 4
                        }

                        RowLayout {
                            anchors.right: parent.right
                            spacing: 2

                            ToolButton {
                                text: "\uf00d"
                                font.family: fontAwesome.name
                                font.pixelSize: 12
                                onClicked: removeTab(index)

                                background: Rectangle {
                                    color: parent.hovered ? Qt.darker(buttonHoverColor, 1.2) : "transparent"
                                    radius: 4
                                }
                            }
                        }

                        // Right-click MouseArea
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            onClicked: {
                                if (mouse.button === Qt.RightButton) {
                                    contextMenu.popup()
                                }
                            }
                        }

                        // Context Menu
                        Menu {
                            id: contextMenu
                            topPadding: 4
                            bottomPadding: 4

                            Material.theme: Material.System
                            Material.primary: Material.BlueGrey
                            Material.accent: Material.Blue

                            delegate: MenuItem {
                                Material.theme: Material.System
                                Material.foreground: enabled ? Material.primaryTextColor : Material.hintTextColor
                                implicitWidth: 50
                                implicitHeight: 13
                                height: 13
                                font.pixelSize: 12
                                padding: 8
                            }

                            MenuItem {
                                text: "Edit Title"
                                font.pixelSize: 12
                                onTriggered: editDialog.open()
                            }
                        }

                        // Edit Dialog
                        Dialog {
                            id: editDialog
                            anchors.centerIn: Overlay.overlay
                            title: "Edit Tab Title"
                            width: 300
                            modal: true
                            Material.theme: Material.System
                            Material.primary: Material.BlueGrey
                            Material.accent: Material.Blue

                            standardButtons: Dialog.Cancel | Dialog.Ok

                            onAccepted: {
                                tabModel.setProperty(index, "title", titleInput.text)
                            }

                            TextField {
                                id: titleInput
                                width: parent.width
                                text: model.title
                                focus: true
                                color: Material.foreground
                                selectedTextColor: Material.accent
                                placeholderText: "Enter new title..."
                                Material.accent: Material.Blue
                                Material.foreground: Material.primaryTextColor
                                font.pixelSize: 14
                            }
                        }
                    }
                }
            }

            // Add Tab Button
            Button {
                text: "\uf067"
                font.family: fontAwesome.name
                font.pixelSize: 14
                padding: 8
                onClicked: addNewTab()

                background: Rectangle {
                    color: parent.hovered ? buttonHoverColor : "transparent"
                    radius: 4
                }
            }

            // Separator
            Rectangle {
                implicitWidth: 1
                height: parent.height * 0.6
                color: Material.dividerColor
                opacity: 0.5
                Layout.alignment: Qt.AlignVCenter
            }

            // Config Button
            Button {
                text: "\uf013"
                font.family: fontAwesome.name
                font.pixelSize: 14
                padding: 8
                onClicked: settingDialog.open()

                background: Rectangle {
                    color: parent.hovered ? buttonHoverColor : "transparent"
                    radius: 4
                }
            }
        }

        // Page Content
        Item {
            id: pagesContainer
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: tabModel
                Loader {
                    anchors.fill: parent
                    visible: index === root.currentTabIndex
                    sourceComponent: pageContent
                }
            }
        }
    }

    // Page Component
    Component {
        id: pageContent
        Rectangle {
            anchors.fill: parent
            color: Material.background

            SplitView {
                anchors.fill: parent
                handle: Rectangle {
                    implicitWidth: 4
                    color: Material.accentColor
                    opacity: 0.5
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.SizeHorCursor
                    }
                }

                Rectangle {
                    id: leftSide
                    SplitView.minimumWidth: 100
                    SplitView.preferredWidth: parent.width * 0.4
                    color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.05)
                    radius: 8
                    border { color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.1); width: 1 }

                    TopSection { leftSidRef: leftSide }
                }

                PlotArea {
                    SplitView.minimumWidth: 100
                    SplitView.fillWidth: true
                }
            }
        }
    }

    // Functions
    function addNewTab() {
        tabModel.append({"title": `Page ${tabModel.count + 1}`})
        root.currentTabIndex = tabModel.count - 1
    }

    function removeTab(index) {
        tabModel.remove(index)
        if (index === root.currentTabIndex) {
            root.currentTabIndex = Math.max(0, index - 1)
        } else if (index < root.currentTabIndex) {
            root.currentTabIndex--
        }
    }

    Component.onCompleted: console.log("Application initialized")
}
