import QtQuick 2.12

Item {
    id: root
    width: 405
    height: 404

    // 3 music items
//    MusicItem {
//        id: musicPre
//        imgWidth: 127; imgHeight: 148
//        x: 0
//        y: 30
//        title: "Thien An oi"
//        author: "Jackma"
//        imageSource: "qrc:/Images/Music/imgjack.png"
//    }

    MusicItem {
        id: musicCurrent
        imgWidth: 186; imgHeight: 217
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenterOffset: 0
        z:2
        title: "Thien An oi"
        author: "Jackma"
        imageSource: "qrc:/Images/Music/imgjack.png"
    }

//    MusicItem {
//        id: musicNext
//        imgWidth: 127; imgHeight: 148
//        anchors.right: parent.right
//        y: 30
//        z:1
//        title: "Thien An oi"
//        author: "Jackma"
//        imageSource: "qrc:/Images/Music/imgjack.png"
//    }


    // Thanh progress + nút
    Item {
        id: playBar
        width: 344
        height: 53
        anchors.top: musicCurrent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40

        Image { id: prevBtn; source: "qrc:/Images/Music/Previous.svg"; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
        Image { id: bar; source: "qrc:/Images/Music/Total.svg"; anchors.centerIn: parent }
        Image {
            id: barProgress
            source: "qrc:/Images/Music/Played.svg"
            anchors.left: bar.left
            anchors.top: bar.top
            height: bar.height
            width: 0
            smooth: true
            NumberAnimation on width {
                from: 0; to: bar.width; duration: 10000; loops: Animation.Infinite; running: true
                easing.type: Easing.InOutQuad
            }
        }
        Text { id: timeMusic; text: "-3:34"; anchors.top: bar.bottom; anchors.right: bar.right; anchors.topMargin: 5; color: "#FFF" }
        Image { id: nextBtn; source: "qrc:/Images/Music/Next.svg"; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
    }
}
