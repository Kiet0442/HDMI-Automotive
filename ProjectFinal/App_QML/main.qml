import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {

    // Loader để load màn hình
    Loader {
        id: pageLoader1
        anchors.fill: parent
        source: "ClusterWindow.qml"
    }

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: "IVIWindow.qml"
    }
}
