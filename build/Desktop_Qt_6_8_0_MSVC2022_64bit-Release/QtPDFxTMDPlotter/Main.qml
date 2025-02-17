import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
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

    property color buttonHoverColor: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.1)

    FontLoader {
        id: fontAwesome
        source: "qrc:/fonts/fonts/otfs/Font Awesome 6 Free-Solid-900.otf"
    }

    // Model to drive tabs/pages
    ListModel {
        id: tabModel
        ListElement { title: "Page 1" }
    }

    SettingDialog {
        id: settingDialog
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Header row with TabBar and buttons
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            TabBar {
                id: tabBarConfig
                currentIndex: swipeView.currentIndex
                Layout.fillWidth: true

                Repeater {
                    model: tabModel
                    delegate: TabButton {
                        // Enable hover tracking
                        hoverEnabled: true
                        width: 100
                        padding: 8
                        text: model.title

                        contentItem: Text {
                            text: model.title
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            color: Material.foreground
                        }

                        // Use the built-in "hovered" property (now available because hoverEnabled is true)
                        ToolTip.visible: hovered && (textMetrics.width > width)
                        ToolTip.text: model.title
                        TextMetrics { id: textMetrics; text: model.title }

                        background: Rectangle {
                            color: hovered ? buttonHoverColor : "transparent"
                            radius: 4
                        }

                        // Remove Tab Button
                        RowLayout {
                            anchors.right: parent.right
                            spacing: 2
                            ToolButton {
                                text: "\uf00d"
                                font.family: fontAwesome.name
                                font.pixelSize: 12
                                onClicked: removeTab(index)
                                background: Rectangle {
                                    color: hovered ? Qt.darker(buttonHoverColor, 1.2) : "transparent"
                                    radius: 4
                                }
                            }
                        }

                        // Right-click area for editing tab title
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            hoverEnabled: true
                            onClicked: function(mouse) {
                                if (mouse.button === Qt.RightButton)
                                    contextMenu.popup()
                            }
                        }

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

                        // Edit Dialog for renaming the tab
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

                        // When the TabButton is clicked, update the SwipeView's current index
                        onClicked: {
                            swipeView.currentIndex = index;
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
                hoverEnabled: true
                onClicked: addNewTab()
                background: Rectangle {
                    color: parent.hovered ? buttonHoverColor : "transparent"
                    radius: 4
                }
            }

            // Vertical Separator
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
                hoverEnabled: true
                onClicked: settingDialog.open()
                background: Rectangle {
                    color: parent.hovered ? buttonHoverColor : "transparent"
                    radius: 4
                }
            }
        }

        // Pages container using SwipeView
        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            // Dynamically create pages from the model.
            // Each Loader instantiates the pageContent component.
            Repeater {
                model: tabModel
                delegate: Loader {
                    active: true
                    sourceComponent: pageContent
                }
            }
        }
    }

    // Page Content Component: each page has its own SplitView with a leftSide container.
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

                // Left Side container
                Rectangle {
                    id: leftSide
                    SplitView.minimumWidth: 100
                    SplitView.preferredWidth: parent.width * 0.4
                    color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.05)
                    radius: 8
                    border {
                        color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.1)
                        width: 1
                    }
                    TopSection { leftSidRef: leftSide }
                }

                // Plot Area container
                PlotArea {
                    SplitView.minimumWidth: 100
                    SplitView.fillWidth: true
                }
            }
        }
    }

    // Functions to manage tabs
    function addNewTab() {
        tabModel.append({"title": "Page " + (tabModel.count + 1)})
        swipeView.currentIndex = tabModel.count - 1
    }

    function removeTab(index) {
        tabModel.remove(index)
        if (swipeView.currentIndex >= tabModel.count)
            swipeView.currentIndex = tabModel.count - 1
    }

    Component.onCompleted: console.log("Application initialized")
}
