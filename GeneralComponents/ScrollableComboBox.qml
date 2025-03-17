import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ComboBox {
    id: scrollableComboBox

    // Customizable properties
    property int maxPopupHeight: 100
    property bool showScrollIndicator: true
    property bool scrollBarAlwaysVisible: true

    // Material theme properties
    property int materialElevation: 6

    // Material background for the ComboBox itself
    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        border.color: scrollableComboBox.pressed ? scrollableComboBox.Material.accentColor : scrollableComboBox.Material.dividerColor
        border.width: scrollableComboBox.visualFocus ? 2 : 1
        radius: 4
        color: scrollableComboBox.Material.background
    }

    // Customize popup to add scrollbar with Material styling
    popup: Popup {
        y: scrollableComboBox.height
        width: scrollableComboBox.width
        implicitHeight: Math.min(contentItem.implicitHeight, scrollableComboBox.maxPopupHeight)
        padding: 1

        // Material styling for popup
        Material.elevation: scrollableComboBox.materialElevation

        background: Rectangle {
            color: scrollableComboBox.Material.dialogColor
            radius: 4

            // Add shadow effect for Material design
            layer.enabled: scrollableComboBox.materialElevation > 0
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: scrollableComboBox.popup.visible ? scrollableComboBox.delegateModel : null
            currentIndex: scrollableComboBox.highlightedIndex

            // Material style for the delegates
            delegate: ItemDelegate {
                id: itemDelegate
                width: parent.width
                highlighted: ListView.isCurrentItem

                // Inherit Material properties and styling
                Material.foreground: highlighted ? Material.accentColor : Material.foreground

                // Highlight with the accent color for Material design
                background: Rectangle {
                    visible: itemDelegate.highlighted
                    color: scrollableComboBox.Material.listHighlightColor
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {
                active: scrollableComboBox.showScrollIndicator
                visible: scrollableComboBox.showScrollIndicator

                // Material styling for the scroll indicator
                contentItem: Rectangle {
                    implicitWidth: 4
                    implicitHeight: 100
                    color: scrollableComboBox.Material.scrollBarColor
                    opacity: parent.active ? 0.7 : 0.3
                    radius: width / 2
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: scrollableComboBox.scrollBarAlwaysVisible ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                interactive: true

                // Material styling for the scrollbar
                contentItem: Rectangle {
                    implicitWidth: 6
                    implicitHeight: 100
                    radius: width / 2
                    color: parent.pressed ? scrollableComboBox.Material.accentColor :
                           scrollableComboBox.Material.scrollBarColor
                    opacity: parent.policy === ScrollBar.AlwaysOn || parent.active ? 0.7 : 0.3
                }
            }
        }
    }
}
