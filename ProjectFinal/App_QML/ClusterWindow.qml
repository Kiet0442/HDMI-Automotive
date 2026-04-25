import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "Common"
Window {
    id: windowCluster
    visible: true
    width: 1280
    height: 520
    title: qsTr("Cluster")

    Component.onCompleted: {
           startGaugeAnimation()
       }
    function startGaugeAnimation() {
           animFull.start()
       }

    Item {
        id: background
        width: parent.width
        height: parent.height
        Image {
            id: imgbackground
            fillMode: Image.PreserveAspectFit
            source: content2.visible
                ? "qrc:/Images/Back-ground/Bg-battery.svg"
                : "qrc:/Images/Back-ground/Bg-music.svg"
        }
       }

    // Icon left
    Item {
        id: iconleft
        width: 243
        height: 287
        anchors.top: background.top
        anchors.left: background.left

        ListModel {
            id: iconModel
            ListElement {
                name: "turnleft"
                imgX: 165
                imgY: 53
                imgWidth: 32
                imgSource: "qrc:/Images/Icon-left/turn-left.svg"
                buttonIndex: 4
            }
            ListElement {
                name: "handbrake"
                imgX: 119
                imgY: 84
                imgWidth: 32
                imgSource: "qrc:/Images/Icon-left/handbrake.svg"
                buttonIndex: 7
            }
            ListElement {
                name: "battery"
                imgX: 81
                imgY: 129
                imgWidth: 32
                imgSource: "qrc:/Images/Icon-left/battery.svg"
                buttonIndex: 9
            }
            ListElement {
                name: "temperature"
                imgX: 56
                imgY: 184
                imgWidth: 32
                imgSource: "qrc:/Images/Icon-left/temperature.svg"
                buttonIndex: 8
            }
            ListElement {
                name: "abs"
                imgX: 38
                imgY: 241
                imgWidth: 32
                imgSource: "qrc:/Images/Icon-left/brake-abs.svg"
                buttonIndex: 3
            }
        }

        Repeater {
            model: iconModel
            delegate: Image {
                id: imageIcon
                objectName: name
                x: imgX
                y: imgY
                width: imgWidth
                source: imgSource
                fillMode: Image.PreserveAspectFit

                // Opacity mặc định
                opacity: 1

                // Animation nháy
                SequentialAnimation {
                    id: blinkAnimation
                    loops: Animation.Infinite
                    running: false

                    NumberAnimation {
                        target: imageIcon
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: imageIcon
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }

                Connections {
                    target: serialManager
                    onEspDataUpdated: function(data) {
                        if (buttonIndex >= 0 && buttonIndex < espData.buttons.length) {
                            if (espData.buttons[buttonIndex] === 1) {
                                blinkAnimation.running = true
                            } else {
                                blinkAnimation.running = false
                                imageIcon.opacity = 1
                            }
                        }
                    }
                }
            }
        }
    }


    //icon right
    Item {
        id: iconright
        width: 243
        height: 287
        anchors.top: background.top
        anchors.right: background.right

        ListModel {
            id: iconModel2
            ListElement { name: "turnright"; imgX: 38; imgY: 53; imgWidth: 32;  imgSource: "qrc:/Images/Icon-right/turn-right.svg"; buttonIndex: 5 }
            ListElement { name: "lighthigh"; imgX: 84; imgY: 84; imgWidth: 32; imgSource: "qrc:/Images/Icon-right/light-high.svg"; buttonIndex: 1 }
            ListElement { name: "lightdown"; imgX: 122; imgY: 129; imgWidth: 32;  imgSource: "qrc:/Images/Icon-right/light-down.svg"; buttonIndex: 2 }
            ListElement { name: "seatbelt"; imgX: 147; imgY: 184; imgWidth: 32; imgSource: "qrc:/Images/Icon-right/seat-belt.svg"; buttonIndex: 6 }
            ListElement { name: "parking"; imgX: 165; imgY: 241; imgWidth: 32; imgSource: "qrc:/Images/Icon-right/parking.svg"; buttonIndex: 0 }
        }

        Repeater {
            model: iconModel2
            delegate: Image {
                id: imageIcon2
                objectName: name
                x: imgX
                y: imgY
                width: imgWidth
                source: imgSource
                fillMode: Image.PreserveAspectFit

                opacity: 1

                SequentialAnimation {
                    id: blinkAnimation2
                    loops: Animation.Infinite
                    running: false

                    NumberAnimation { target: imageIcon2; property: "opacity"; from: 0.3; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: imageIcon2; property: "opacity"; from: 1.0; to: 0.3; duration: 500; easing.type: Easing.InOutQuad }
                }

                Connections {
                    target: serialManager
                    onEspDataUpdated: function(data) {
                        if (buttonIndex >= 0 && buttonIndex < espData.buttons.length) {
                            if (espData.buttons[buttonIndex] === 1) {
                                blinkAnimation2.running = true
                            } else {
                                blinkAnimation2.running = false
                                imageIcon2.opacity = 1
                            }
                        }
                    }
                }
            }
        }
    }

    //Time
    Item {
        id: timer
        width: 168
        height: 40
        anchors.top: background.top
        anchors.horizontalCenter: background.horizontalCenter
        anchors.topMargin: 30

        Text {
            id: texttime
            width: parent.width
            text: Qt.formatTime(new Date(), "hh:mm:ss AP")
            horizontalAlignment: Text.AlignHCenter
            color: "#FFF"
            font.pointSize: 18
        }

        Timer {
            id: realtimeTimer
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                texttime.text = Qt.formatTime(new Date(), "hh:mm:ss AP")
            }
        }
    }

    //Speed
    Item{
        id: speed
        width: 350
        height: 350
        anchors.left: background.left
        anchors.verticalCenter: background.verticalCenter
        anchors.leftMargin: 100

        Image{
            id: speedcircle
            anchors.verticalCenterOffset: -23
            anchors.horizontalCenterOffset: 0
            source: "Images/Speed-tacho-fuel/information.png"
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: speed
        }

        ProgressArc {
               id: progressArc1
               anchors.fill: parent
               maxValue: 160
               colorStart: "#ffffff"
               colorEnd: "#ff6a00"
               allowUpdate: false
           }

            // text hiển thị tốc độ
            Text {
                id: textkm
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(progressArc1.progress * 160)
                font.pixelSize: 35
                color: "white"
            }
        Text {
            id: textecho
            text: qsTr("Echo")
            anchors.rightMargin: 0
            anchors.leftMargin: 1
            anchors.top: textkm.bottom
            anchors.topMargin: 100
            anchors.left: textkm.left
            anchors.right: textkm.right
            horizontalAlignment: Text.AlignHCenter
            color: "#FFF"
            font.pointSize: 12
        }
        Connections {
            target: serialManager
            onEspDataUpdated: {
                if (progressArc1.allowUpdate)
                    progressArc1.progress = espData.pot32 / progressArc1.maxValue
            }
        }

    }

    //Tacho
    Item{
        id: tacho
        width: 350
        height: 350
        anchors.right:  background.right
        anchors.verticalCenter: background.verticalCenter
        anchors.rightMargin: 100
        Image{
            id: tachocircle
            anchors.verticalCenterOffset: -23
            anchors.horizontalCenterOffset: 0
            source: "Images/Speed-tacho-fuel/rondella.png"
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: tacho
        }
        ProgressArc {
               id: progressArc
               anchors.fill: parent
               maxValue: 8
               colorStart: "#ffffff"
               colorEnd: "#ff6a00"
               allowUpdate: false
           }


            // text hiển thị tốc độ: tham chiếu tới progressArc.progress
            Text {
                id: texttacho
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(progressArc.progress * 8)
                font.pixelSize: 35
                color: "white"
            }

        Text {
            id: textgear
            text: qsTr("Gear")
            anchors.rightMargin: 0
            anchors.leftMargin: 1
            anchors.top: texttacho.bottom
            anchors.topMargin: 101
            anchors.left: texttacho.left
            anchors.right: texttacho.right
            horizontalAlignment: Text.AlignHCenter
            color: "#FFF"
            font.pointSize: 12
        }
        Connections {
            target: serialManager
            onEspDataUpdated: {
                if (progressArc.allowUpdate)
                    progressArc.progress = espData.pot33 / progressArc.maxValue
            }
        }
    }

    //fuel
        ArcGauge {
            id: fuelGauge
            width: 300
            height: 300
            anchors.bottom: background.bottom
            anchors.left: background.left
            anchors.bottomMargin: 55
            anchors.leftMargin: 40

            startAngle: Math.PI * 0.43
            totalSweep: Math.PI * 0.44
            reverse: false
            rotationAngle: 10
            colorStart: "#00CC33"
            colorEnd: "#FFF"
            labelMin: "0"
            labelMax: "100"

            // progress được update realtime
            progress: 0.0
            allowUpdate: false
        }

        Connections {
            target: serialManager
            onEspDataUpdated: {
                if (fuelGauge.allowUpdate) {
                    fuelGauge.progress = espData.pot34 / 100.0
                }
            }
        }

        Image {
            id: batteryimg
            width: 30
            height: 30
            anchors.bottom: fuelGauge.bottom
            anchors.left: fuelGauge.left
            anchors.bottomMargin: 20
            anchors.leftMargin: 30
            source: "Images/Icon-left/battery.svg"
        }



        // Temperature Gauge
        ArcGauge {
            id: tempGauge
            width: 300
            height: 300
            anchors.bottom: background.bottom
            anchors.right: background.right
            anchors.bottomMargin: 55
            anchors.rightMargin: 40

            startAngle: Math.PI * 0.13
            totalSweep: Math.PI * 0.44
            reverse: true
            rotationAngle: -10
            colorStart: "#FFFFFF"
            colorEnd: "#FF3333"
            labelMin: ""
            labelMax: ""  // ví dụ nhiệt độ tối đa 50°C

            progress: 0.0
            allowUpdate: false
        }

        // Connections để cập nhật dữ liệu ESP32
        Connections {
            target: serialManager
            onEspDataUpdated: {
                if (tempGauge.allowUpdate) {
                    tempGauge.progress = espData.temp / 50.0
                }
            }
        }

        Image {
            id: tempimg
            width: 30
            height: 30
            anchors.bottom: tempGauge.bottom
            anchors.right: tempGauge.right
            anchors.bottomMargin: 20
            anchors.rightMargin: 30
            source: "Images/Icon-left/temperature.svg"
        }
        Text {
            id: text0tacho
            anchors.bottom: tempGauge.bottom
            anchors.right: tempGauge.right
            text: qsTr("0")
            anchors.bottomMargin: 13
            font.pointSize: 13
            anchors.rightMargin: 170
            color: "#FFFFFF"
        }
        Text {
            id: text8tacho
            anchors.bottom: tempGauge.bottom
            anchors.right: tempGauge.right
            text: qsTr("50")
            anchors.bottomMargin: 135
            anchors.rightMargin: 19
            color: "#FFFFFF"
        }

        SequentialAnimation {
            id: animFull
            running: false

            // Tăng lên max
            ParallelAnimation {
                NumberAnimation { target: progressArc1; property: "progress"; to: 1; duration: 1000 }
                NumberAnimation { target: progressArc;  property: "progress"; to: 1; duration: 1000 }
                NumberAnimation { target: fuelGauge;    property: "progress"; to: 1; duration: 1000 }
                NumberAnimation { target: tempGauge;    property: "progress"; to: 1; duration: 1000 }
            }

            // Giảm về 0
            ParallelAnimation {
                NumberAnimation { target: progressArc1; property: "progress"; to: 0; duration: 1000 }
                NumberAnimation { target: progressArc;  property: "progress"; to: 0; duration: 1000 }
                NumberAnimation { target: fuelGauge;    property: "progress"; to: 0; duration: 1000 }
                NumberAnimation { target: tempGauge;    property: "progress"; to: 0; duration: 1000 }
            }

            onStopped: {
                // cho phép nhận dữ liệu esp
                progressArc1.allowUpdate = true
                progressArc.allowUpdate = true
                fuelGauge.allowUpdate = true
                tempGauge.allowUpdate = true
            }
        }


    Image {
        id: icondirectionlimit
        source: "Images/Icon-instruction/Limit.svg"
        width: 53
        height: 53
        anchors.bottom: background.bottom
        anchors.left: background.left
        anchors.leftMargin: 370
        anchors.bottomMargin: 60

    }
    Image {
        id: icondirection
        source: "Images/Icon-instruction/Mini_Nav.svg"
        width: 53
        height: 53
        anchors.bottom: background.bottom
        anchors.right: background.right
        anchors.rightMargin: 370
        anchors.bottomMargin: 60
    }
//content music
    Item{
        id: content1
        width: 405
        height: 404
        anchors.horizontalCenter: background.horizontalCenter
        anchors.verticalCenter: background.verticalCenter
        anchors.verticalCenterOffset: 20
        visible: false
//        MusicPlayer {
//                anchors.fill: parent
//            }
        Item {
            id: weather
            height: 346
            width: 266
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            Text {
                id: textcity
                text: qsTr("Da Nang")
                width: 178
                height: 55
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#FFF"
                font.pointSize: 15
            }
            Text {
                 id: texttemp
                 text: qsTr("29°")
                 width: 91
                 height: 90
                 anchors.horizontalCenter: parent.horizontalCenter
                 anchors.top: textcity.bottom
                 horizontalAlignment: Text.AlignHCenter
                 anchors.topMargin: 5
                 font.pointSize: 25
                 color: "#FFF"
                }
            Text {
                 id: textclear
                 text: qsTr("CLEAR")
                 width: 42
                 height: 28
                 anchors.horizontalCenter: parent.horizontalCenter
                 anchors.top: texttemp.bottom
                 horizontalAlignment: Text.AlignHCenter
                 anchors.topMargin: 5
                 font.pointSize: 9
                 color: "#FFF"
                }
            Text {
                id: textsta
                text: qsTr("H: 30° L:12°")
                width: 69
                height: 28
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textclear.bottom
                horizontalAlignment: Text.AlignHCenter
                anchors.topMargin: 2
                font.pointSize: 9
                color: "#FFF"
            }
            Row {
                id: forecastRow
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                spacing: 10

                Repeater {
                    model: 5
                    delegate: Column {
                        width: 42
                        height: 77
                        spacing: 2

                        Text {
                            text: (10 + index) + "PM"
                            width: 41
                            height: 20
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 7
                            color: "#FFF"
                        }

                        Image {
                            width: 31
                            height: 33
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/Images/weather-ivi/Weather1.png"
                        }

                        Text {
                            text: "29°"
                            width: 31
                            height: 20
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "#FFF"
                            font.pointSize: 6
                        }
                    }
                }
            }


        }

}

    //content battery
    Item {
        id: content2
        width: 365
        height: 390
        anchors.centerIn: background
        visible: true

        BatteryItem {
            id: battery
            widthBattery: 159
            heightBattery: 250
            chargeLevel: 150
            isCharging: false
            anchors.centerIn: parent
        }
        Connections {
            target: serialManager
            onEspDataUpdated: function(data) {
                // Chuyển % sang px
                battery.chargeLevel = espData.pot34 * battery.heightBattery / 100

                var delta = espData.pot34 - battery.previousCharge

                // Chỉ cập nhật trạng thái nếu chênh lệch > 0.5
                if (delta > 0.5) {
                    battery.isCharging = true
                } else if (delta < -0.5) {
                    battery.isCharging = false
                }

                // Lưu giá trị lần này
                battery.previousCharge = espData.pot34
            }
        }

    }

        Row {
                id: pageIndicator
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30

                Rectangle {
                    id: dot1
                    width: 13
                    height: 13
                    radius: 13
                    color: content2.visible ? "white" : "#8A8A8A"
                    opacity: content2.visible ? 1.0 : 0.5
                }

                Rectangle {
                    id: dot2
                    width: 13
                    height: 13
                    radius: 13
                    color: content1.visible ? "white" : "#8A8A8A"
                    opacity: content1.visible ? 1.0 : 0.5
                }
            }

//        // Vuốt để chuyển trang
        MultiPointTouchArea {
            anchors.fill: parent
            onReleased: {
                if (touchPoints[0].x - touchPoints[0].startX > 100) {
                    content2.visible = true
                    content1.visible = false
                } else if (touchPoints[0].startX - touchPoints[0].x > 100) {
                    // Vuốt trái → sang content2
                    content2.visible = false
                    content1.visible = true
                }
            }
        }

    }


