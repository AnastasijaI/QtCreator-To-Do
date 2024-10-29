import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

RowLayout {
    id: root

    anchors.right: parent.right
    anchors.rightMargin: 15
    y: updatePosition()

    signal addTask(string title, string description)

    function updateY() {
        if (taskListView.count > 0) {
            root.y = 15 + taskListView.count * 48 + numberOfDes * 30
        }
        else
        {
            root.y = 15
        }
    }

    function updatePosition() {
        if(taskListView.count !== 0)
        {
            return 15 + taskListView.count * 48 + numberOfDes * 30
        }
        else
        {
            return 15
        }
    }

    Button {
        id: addTaskButton
        text: "Add Task"
        font.pixelSize: 16
        background: Rectangle {
            color: "#3498db"
            radius: 5
        }
        padding: 10

        onClicked: {

            dialog.visible = true

        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        transitions: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }

    Dialog {
        id: dialog
        title: qsTr("Add Task")
        standardButtons: Dialog.NoButton

        ColumnLayout {
            TextField {
                id: titleInput
                placeholderText: qsTr("Enter task title")
                Layout.fillWidth: true
                onTextChanged: okButton.enabled = titleInput.text.trim() !== ""
            }

            TextField {
                id: descriptionInput
                placeholderText: qsTr("Enter task description")
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight

                Button {
                    text: "Cancel"
                    onClicked: dialog.reject()
                }

                Button {
                    id: okButton
                    text: "Ok"
                    enabled: false
                    onClicked: {
                        dialog.accept()
                        titleInput.text = ""
                        descriptionInput.text = ""
                        updateY()
                    }
                }
            }
        }

        onAccepted: {
            var descText = descriptionInput.text.trim()
            if (descText === "") {
                descText = "..no description"
            }
            addTask(titleInput.text, descText)
            titleInput.text = ""
            descriptionInput.text = ""
            updateY()
        }
    }
}
