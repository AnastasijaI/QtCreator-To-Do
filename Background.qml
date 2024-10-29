import QtQuick 2.15

Rectangle {
    id: root
    anchors.fill: parent
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#ffffe0" }
        GradientStop { position: 1.0; color: "#ffd700" }
    }
}
