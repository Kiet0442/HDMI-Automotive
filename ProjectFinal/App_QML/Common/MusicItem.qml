import QtQuick 2.12
Item {
    id: root
    property string title
    property string author
    property url imageSource
    property int imgWidth: 127
    property int imgHeight: 148

    width: imgWidth
    height: imgHeight + 50  // Text chiếm 50 px

    Rectangle {
        id: imgRect
        width: imgWidth
        height: imgHeight
        Image { anchors.fill: parent; source: imageSource }
    }

    Text {
        text: title
        anchors.top: imgRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10
        font.pointSize: 16
        color: "#FFF"
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        text: author
        anchors.top: imgRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 50
        font.pointSize: 13
        color: "#FFF"
        horizontalAlignment: Text.AlignHCenter
    }
}
