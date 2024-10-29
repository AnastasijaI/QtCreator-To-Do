import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import TaskManager 1.0

Window {
    id: root
    visible: true
    width: 480
    height: 600

    title: qsTr("To-Do List")

    onWidthChanged: taskManager.refreshModel();
    property int numberOfDes: 0
    onNumberOfDesChanged: {
        textEntry.updateY()
    }

    Background {
        id: background
    }

    TaskManager {
        id: taskManager
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            width: parent.width
            height: 70

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Text {
                    text: "Your To-Do List"
                    color: "orange"
                    font.pixelSize: 24
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Button {
                    text: "Sort by Title"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onPressed: {
                        taskManager.sortTasksByTitle();
                    }
                }
            }
        }
        DelegateModel {
            id: visualModel

            model: taskManager.taskModel
            delegate: dragDelegate
        }
        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: taskListView
                //model: taskManager.taskModel
                model: visualModel
                clip: true
                focus: true

                highlight: ListHighlight {}

                add: Transition {
                    NumberAnimation { properties: "x"; from: -taskListView.width; duration: 250; easing.type: Easing.InCirc }
                    NumberAnimation { properties: "y"; from: taskListView.height; duration: 250; easing.type: Easing.InCirc }
                }

                remove: Transition {
                    NumberAnimation { properties: "x"; to: taskListView.width; duration: 300; easing.type: Easing.InBounce }
                }
            }

            TextEntry {
                id: textEntry
                onAddTask: taskManager.addTask(title, description)
            }
        }
        Component {
            id: dragDelegate

            MouseArea {
                id: dragArea
                Component.onCompleted: {

                }
                onParentChanged: {
                     if(parent){
                         anchors.left = parent.left
                         anchors.right = parent.right
                     }
                }

                property bool held: false

                // anchors { left: parent.left; right: parent.right }

                height: content.height

                drag.target: held ? content : undefined
                drag.axis: Drag.YAxis

                onPressAndHold: held = true
                onReleased: held = false


                Rectangle {
                    id: content
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    width: taskListView.width
                    height: del.descriptionClicked? column.implicitHeight + 30 : column.implicitHeight

                    border.width: 1
                    border.color: "orange"

                    color: dragArea.held ? "lightsteelblue" : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    radius: 2

                    Drag.active: dragArea.held
                    Drag.source: dragArea
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    states: State {
                        when: dragArea.held

                        ParentChange { target: content; parent: root }
                        AnchorChanges {
                            target: content
                            anchors { horizontalCenter: undefined; verticalCenter: undefined }
                        }
                    }

                    ColumnLayout {
                        id: column
                        // anchors { fill: parent; margins: 2 }
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.left: parent.left

                        CustomListDelegate{
                            id:del
                            title: model.title
                            width: parent.width
                            description: model.description
                            completed: model.completed

                            onToggleCompletion: (completed) => taskManager.toggleTaskCompletion(index, completed)
                            onEditTask: {
                                editDialog.taskItem = model
                                editDialog.currentIndex = index
                                editDialog.open()
                                editDialog.updateTextFields()
                            }
                            onRemoveTask: {
                                taskManager.removeTask(index)
                                textEntry.updateY()
                            }
                        }
                    }
                }

                DropArea {
                    anchors { fill: parent; margins: 10 }

                    onEntered: {
                        visualModel.items.move(
                                drag.source.DelegateModel.itemsIndex,
                                dragArea.DelegateModel.itemsIndex)
                    }
                }
            }
        }
    }

    Dialog {
        id: editDialog
        title: qsTr("Edit Task")
        standardButtons: Dialog.Ok | Dialog.Cancel

        property var taskItem: null
        property int currentIndex: -1

        ColumnLayout {
            TextField {
                id: editTitleInput
                placeholderText: qsTr("Enter task title")
                Layout.fillWidth: true
            }

            TextField {
                id: editTaskInput
                placeholderText: qsTr("Enter task description")
                Layout.fillWidth: true
            }
        }

        function updateTextFields() {
            if (taskItem) {
                editTitleInput.text = taskItem.title
                editTaskInput.text = taskItem.description
            }
        }

        onAccepted: {
            if (taskItem && currentIndex !== -1) {
                var newTitle = editTitleInput.text.trim() === "" ? taskItem.title : editTitleInput.text
                var newDescription = editTaskInput.text.trim() === "" ? taskItem.description : editTaskInput.text
                taskManager.editTask(currentIndex, newTitle, newDescription)
                taskItem = null
                currentIndex = -1
            }
            editTitleInput.text = ""
            editTaskInput.text = ""
        }
    }
}
