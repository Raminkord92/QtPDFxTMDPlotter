import QtQuick 2.15
import QtQuick.Controls 2.15
import SortFilterProxyModel

ComboBox {
    id: combo
    // Properties to configure the component
    property alias originalModel: filteredModel.sourceModel
    property string filterRoleName: "text"  // Role to filter and display
    property string valueRoleName: ""       // Optional unique value role

    // Set the ComboBox model and roles
    model: originalModel
    textRole: filterRoleName
    valueRole: valueRoleName

    // Custom popup with search functionality
    popup: Popup {
        y: combo.height          // Position below the ComboBox
        width: combo.width       // Match ComboBox width
        height: 200              // Fixed height (adjust as needed)
        contentItem: Column {
            TextField {
                id: searchField
                placeholderText: "Search..."
                width: parent.width
            }
            ListView {
                width: parent.width
                height: parent.height - searchField.height
                clip: true  // Improve performance for large lists
                model: SortFilterProxyModel {
                    id: filteredModel
                    sourceModel: originalModel
                    filterRoleName: combo.filterRoleName
                    filterPattern: "*" + searchField.text + "*"  // Contains match
                    filterCaseSensitivity: Qt.CaseInsensitive
                }
                delegate: ItemDelegate {
                    text: model[combo.textRole]
                    width: parent.width
                    onClicked: {
                        if (combo.valueRoleName) {
                            // Use unique value role if provided
                            combo.currentIndex = combo.indexOfValue(model[combo.valueRoleName])
                        } else {
                            // Fallback to text if no value role (assumes unique text)
                            combo.currentIndex = combo.find(model[combo.textRole])
                        }
                        combo.popup.close()
                    }
                }
            }
        }
    }
}
