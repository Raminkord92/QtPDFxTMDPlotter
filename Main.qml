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
    title: "PDF & TMD Plotter"
    Material.theme: Material.Dark
    // Material.accent: Material.Blue
    // Material.primary: Material.BlueGrey

    // This property tracks the current tab index.
    property int currentTabIndex: 0

    // A model to store each tab’s title (one element per tab).
    ListModel {
        id: tabModel
        ListElement { title: "Page 1" }
    }

    // The page component – this reproduces your original layout.
    Component {
        id: pageContent
        Rectangle {
            anchors.fill: parent
            color: Material.background
            Row {
                anchors.fill: parent
                spacing: 10

                // Left side with your TopSection and draggable items.
                Rectangle {
                    id: leftSide
                    width: parent.width / 2
                    height: parent.height
                    color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.05)
                    radius: 8
                    border.color: Qt.rgba(Material.foreground.r, Material.foreground.g, Material.foreground.b, 0.1)
                    border.width: 1
                    TopSection {
                        id: topSection
                        leftSidRef: leftSide
                    }
                }

                // Right side with your PlotArea.
                PlotArea {
                    width: parent.width / 2
                    height: parent.height
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // This RowLayout contains the TabBar and an "Add Tab" button.
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            TabBar {
                id: tabBar
                currentIndex: root.currentTabIndex

                // Create one TabButton per tab in the model.
                Repeater {
                    model: tabModel
                    delegate: TabButton {
                        id: tabButton
                        width:100
                        spacing: 5
                        padding: 5
                        property var prentRoot : root;
                        // When renameField is visible, hide the TabButton’s text.
                        text: renameField.visible ? "" : model.title
                        property string prevText: ""
                        // When a tab is clicked normally, update the currentTabIndex.
                        onClicked: {
                            root.currentTabIndex = index;
                        }
                        ColumnLayout
                        {
                            anchors.fill: parent
                            spacing: 5
                        // Add a TextField for renaming the tab title.
                            TextField {
                                id: renameField
                                visible: false
                                width: parent.width
                                Layout.maximumWidth: 60
                                Layout.alignment: Qt.AlignLeft
                                text: model.title
                                focus: true
                                selectByMouse: true
                                // Custom background to remove focus highlight
                                background: Rectangle {
                                    color: "transparent" // No background color
                                    border.color: "transparent" // No border
                                    radius: 0 // Optional: Remove rounded corners if any
                                }
                                onAccepted: {
                                    // Update the tab title in the model.
                                    tabModel.setProperty(index, "title", text);
                                    visible = false; // Hide the TextField after renaming.
                                }

                                Keys.onEscapePressed: {
                                    visible = false; // Cancel renaming if Escape is pressed.
                                    model.title = tabButton.prevText;
                                }
                            }
                            ToolButton {
                                id: closeButton
                                text: "x"
                                Layout.maximumWidth: 30

                                font.pixelSize: 10
                                padding: 2
                                visible: !renameField.visible
                                Layout.alignment: Qt.AlignRight // Align the close button to the right
                                onClicked: {
                                    var indexToRemove = index;
                                    tabModel.remove(indexToRemove);

                                    // Update the current tab index if necessary.
                                    if (indexToRemove === tabButton.prentRoot.currentTabIndex) {
                                        tabButton.prentRoot.currentTabIndex = Math.max(0, indexToRemove - 1);
                                        console.log("current tab index ", tabButton.prentRoot.currentTabIndex)
                                    } else if (indexToRemove < tabButton.prentRoot.currentTabIndex) {
                                        tabButton.prentRoot.currentTabIndex--;
                                    }

                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            onClicked: {
                                renameField.Layout.maximumWidth = 100
                                tabButton.prevText = model.title
                                // No need to clear model.title now; let the TextField handle the editing.
                                renameField.text = model.title
                                // Show the TextField for renaming when right-clicked.
                                renameField.visible = true;
                                renameField.forceActiveFocus();
                            }
                        }
                    }
                }
            }

            // Button to add a new tab.
            Button {
                text: "+"
                onClicked: {
                    var newIndex = tabModel.count + 1;
                    tabModel.append({"title": "Page " + newIndex});
                    // Set the new tab as current.
                    root.currentTabIndex = tabModel.count - 1;
                }
            }
        }

        // The container that holds the page instances.
        // A Repeater creates one Loader per tab; only the current tab’s Loader is visible.
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

    // Optionally, if you need to use a reference to the leftSide from the initial page:
    Component.onCompleted: {
        console.log("main loaded")
        // Note: 'leftSide' is defined within the pageContent component.
        // If needed, you can expose it via signals or context properties.
        // GlobalContext.leftSideRef = leftSide
    }
}
