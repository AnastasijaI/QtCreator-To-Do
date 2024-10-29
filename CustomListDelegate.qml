import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: ListView.view.width
    height: descriptionRect.visible ? 78 : 48

    property alias title: taskTitle.text
    property alias description: taskDescription.text
    property alias completed: taskCheckbox.checked

    signal removeTask()
    signal editTask()
    signal toggleCompletion(bool completed)

    property bool descriptionClicked: false

    Rectangle {
        id: rect
        width: parent.width
        height: 48
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: 'gray'
        opacity: 0.2
        border.color: Qt.darker(color)
    }

    RowLayout {
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        y: 10
        width: parent.width - 40

        CheckBox {
            id: taskCheckbox
            checked: false
            onCheckedChanged: toggleCompletion(checked)

            indicator: Rectangle {
                width: 24
                height: 24
                anchors.left: parent.left; anchors.leftMargin: 5
                color: taskCheckbox.checked ? "green" : "white"
                radius: 12
            }
        }

        Text {
            id: taskTitle
            Layout.fillWidth: true
            color: 'black'
            font.pixelSize: 24
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.strikeout: taskCheckbox.checked
        }
    }

    Item {
        anchors.right: desc.left
        anchors.top: rect.top
        anchors.topMargin: 12
        anchors.rightMargin: 40
        Layout.fillHeight: true
        Layout.preferredWidth: editIcon.width
        Image {
            id: editIcon
            source: 'pencil.png'
            width: 24
            height: 24
        }

        MouseArea {
            anchors.fill: editIcon
            onClicked: root.editTask()
        }
    }

    Item {
        id:desc
        anchors.right: remove.left
        anchors.top: rect.top
        anchors.rightMargin: 40
        anchors.topMargin: 12
        Layout.fillHeight: true
        Layout.preferredWidth: showDescButton.width
        Button {
            id: showDescButton
            height: 24
            width: 24
            // visible: !descriptionRect.visible
            background: Rectangle {
                color: "blue"
                radius: 5
            }
            onClicked: {
                descriptionClicked = !descriptionClicked
                if(descriptionRect.opacity === 0){
                    descriptionRect.visible = true;
                    root.height = 78;
                    descriptionRect.opacity = 1;
                }
                else{
                    descriptionRect.visible = false;
                    root.height = 48;
                    descriptionRect.opacity = 0;
                }
            }
        }
    }
    Item {
        id:remove
        anchors.right: rect.right
        anchors.top: rect.top
        anchors.rightMargin: 8
        anchors.topMargin: 12
        width: 24
        height: 24

        Image {
            id: deleteIcon
            anchors.centerIn: parent
            source: 'remove.png'
            width: 24
            height: 24
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.removeTask()
        }
    }

    Rectangle {
        id: descriptionRect
        width: root.width
        height: 30
        color: "lightblue"
        visible: false
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        opacity: 0

        Component.onDestruction: {
            if(visible)
                --numberOfDes
        }

        onVisibleChanged: {
            if(visible){
                ++numberOfDes
            }else{
                --numberOfDes
            }
        }

        Text {
            id: taskDescription
            Layout.fillWidth: true
            anchors.centerIn: parent
            color: 'darkblue'
            font.pixelSize: 25
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            font.strikeout: taskCheckbox.checked
        }
    }
}
