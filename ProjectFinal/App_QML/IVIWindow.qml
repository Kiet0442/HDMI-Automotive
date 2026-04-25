import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    id: windowIVI
    width: 1440
    height: 720
    visible: true
    title: qsTr("IVI Interface")

    property bool updatingFromESP32: false
    property bool isDarkTheme: true
    property string currentLang: "vi"
    property bool settingsLoaded: false

    Component.onCompleted: {
            serialManager.requestSettings()
        }
    // ===== Connections để nhận tín hiệu =====
    Connections {
        target: serialManager

        onThemeReceived:{
            isDarkTheme = (theme === "dark")
            themeSwitch.checked = isDarkTheme
            updatingFromESP32 = false
        }

        onLanguageReceived:{
            currentLang = lang
            translatorMgr.switchLanguage(lang)
            languageBox.currentIndex = (lang === "vi" ? 1 : 0)
            updatingFromESP32 = false
        }
    }
    property int currentPage: 3

    // Màu sắc theo theme
    property color backgroundColor: isDarkTheme ? "#0f1419" : "#e8edf2"
    property color textColor: isDarkTheme ? "#e8eae9" : "#1e2a36"
    property color secondaryTextColor: isDarkTheme ? "#8a9ba8" : "#556575"
    property color themeColor: isDarkTheme ? "#1a2530" : "#dce2e8"
    property color iconColor: isDarkTheme ? "#00d9ff" : "#2a6ba5"
    property color buttonColor: isDarkTheme ? "#2a3540" : "#c8d2d8"

    // Music player properties
    property bool isPlaying: false
    property int currentSongIndex: 0
    property int songDuration: 240
    property int currentTime: 0

    // Splash screen properties
    property bool showSplash: true

    // Splash Screen - Màn hình khởi động
    Rectangle {
        id: splashScreen
        anchors.fill: parent
        color: "#000000"
        visible: showSplash
        z: 1000

        // Gradient background sáng dần
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000000" }
                GradientStop { position: 0.5; color: "#1a1a2e" }
                GradientStop { position: 1.0; color: "#16213e" }
            }

            // Animation cho gradient
            SequentialAnimation on opacity {
                running: showSplash
                loops: 1
                NumberAnimation {
                    from: 0
                    to: 1
                    duration: 1000
                }
            }
        }

        // Logo hoặc text chính
        Column {
            anchors.centerIn: parent
            spacing: 30

            // Logo text
            Text {
                text: qsTr("IVI SYSTEM")
                font.pixelSize: 80
                font.bold: true
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter

                SequentialAnimation on opacity {
                    running: showSplash
                    loops: 1
                    PauseAnimation { duration: 500 }
                    NumberAnimation {
                        from: 0
                        to: 1
                        duration: 1000
                    }
                }

                SequentialAnimation on scale {
                    running: showSplash
                    loops: 1
                    PauseAnimation { duration: 500 }
                    NumberAnimation {
                        from: 0.8
                        to: 1.0
                        duration: 1000
                        easing.type: Easing.OutBack
                    }
                }
            }

            // Subtitle
            Text {
                text: qsTr("In-Vehicle Infotainment")
                font.pixelSize: 24
                color: "#A0A0A0"
                anchors.horizontalCenter: parent.horizontalCenter

                SequentialAnimation on opacity {
                    running: showSplash
                    loops: 1
                    PauseAnimation { duration: 1000 }
                    NumberAnimation {
                        from: 0
                        to: 1
                        duration: 800
                    }
                }
            }

            // Loading bar
            Rectangle {
                width: 300
                height: 4
                radius: 2
                color: "#333333"
                anchors.horizontalCenter: parent.horizontalCenter

                SequentialAnimation on opacity {
                    running: showSplash
                    loops: 1
                    PauseAnimation { duration: 1500 }
                    NumberAnimation {
                        from: 0
                        to: 1
                        duration: 500
                    }
                }

                Rectangle {
                    id: loadingBar
                    height: parent.height
                    radius: parent.radius
                    color: "#00D9FF"
                    width: 0

                    SequentialAnimation on width {
                        running: showSplash
                        loops: 1
                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            from: 0
                            to: 300
                            duration: 2000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            // Loading text
            Text {
                text: qsTr("System is starting up...")
                font.pixelSize: 16
                color: "#808080"
                anchors.horizontalCenter: parent.horizontalCenter

                SequentialAnimation on opacity {
                    running: showSplash
                    loops: Animation.Infinite
                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        from: 0.3
                        to: 1.0
                        duration: 800
                    }
                    NumberAnimation {
                        from: 1.0
                        to: 0.3
                        duration: 800
                    }
                }
            }
        }

        // Particles effect - các hạt sáng bay
        Repeater {
            model: 20

            Rectangle {
                width: Math.random() * 4 + 2
                height: width
                radius: width / 2
                color: "#FFFFFF"
                opacity: 0
                x: Math.random() * windowIVI.width
                y: Math.random() * windowIVI.height

                SequentialAnimation on opacity {
                    running: showSplash
                    loops: Animation.Infinite
                    PauseAnimation { duration: Math.random() * 2000 }
                    NumberAnimation {
                        from: 0
                        to: Math.random() * 0.6 + 0.2
                        duration: Math.random() * 1000 + 1000
                    }
                    NumberAnimation {
                        from: Math.random() * 0.6 + 0.2
                        to: 0
                        duration: Math.random() * 1000 + 1000
                    }
                }
            }
        }

        // Timer để ẩn splash screen sau 4 giây
        Timer {
            interval: 4000
            running: true
            repeat: false
            onTriggered: {
                splashFadeOut.start()
            }
        }

        // Animation fade out cho splash screen
        NumberAnimation {
            id: splashFadeOut
            target: splashScreen
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 800
            easing.type: Easing.InOutQuad

            onFinished: {
                showSplash = false
                splashScreen.visible = false
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#24282d"
        opacity: showSplash ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 800
                easing.type: Easing.InOutQuad
            }
        }

        // Phần menu bên trái - GIỮ NGUYÊN màu đen/trắng
        Rectangle {
            id: leftMenu
            x: 0
            y: 0
            width: 130
            height: 720
            color: "#24272C"

            // Union 1 → Page 0
            Rectangle {
                x: 40; y: 104
                width: 48; height: 48
                color: "transparent"

                Image {
                    id: icon1
                    source: "qrc:/Images/left-ivi/Union1.png"
                    anchors.fill: parent
                    opacity: currentPage === 0 ? 1.0 : 0.5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackLayout.currentIndex = 0
                        currentPage = 0
                    }
                }
            }

            // Union 2 → Page 1
            Rectangle {
                x: 40; y: 222
                width: 48; height: 48
                color: "transparent"

                Image {
                    id: icon2
                    source: "qrc:/Images/left-ivi/Union2.png"
                    anchors.fill: parent
                    opacity: currentPage === 1 ? 1.0 : 0.5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackLayout.currentIndex = 1
                        currentPage = 1
                    }
                }
            }

            // Union 3 → Page 2
            Rectangle {
                x: 40; y: 342
                width: 48; height: 48
                color: "transparent"

                Image {
                    id: icon3
                    source: "qrc:/Images/left-ivi/Union3.png"
                    anchors.fill: parent
                    opacity: currentPage === 2 ? 1.0 : 0.5

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackLayout.currentIndex = 2
                        currentPage = 2
                    }
                }
            }

            // Union 4 → Page 3
            Rectangle {
                x: 40; y: 462
                width: 48; height: 48
                color: "transparent"

                Image {
                    id: icon4
                    source: "qrc:/Images/left-ivi/Union4.png"
                    anchors.fill: parent
                    opacity: currentPage === 3 ? 1.0 : 0.5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackLayout.currentIndex = 3
                        currentPage = 3
                    }
                }
            }

            // Union 5 → Settings (Page 4)
            Rectangle {
                x: 40; y: 582
                width: 48; height: 48
                color: "transparent"

                Image {
                    id: icon5
                    source: "qrc:/Images/left-ivi/Union5.png"
                    anchors.fill: parent
                    opacity: currentPage === 4 ? 1.0 : 0.5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackLayout.currentIndex = 4
                        currentPage = 4
                    }
                }
            }
        }

        // Phần nội dung bên phải
        Rectangle {
            id: theme
            x: 130
            y: 10
            width: 1303
            height: 700
            color: themeColor
            radius: 24

            StackLayout {
                id: stackLayout
                anchors.fill: parent
                currentIndex: 3

                // ============ PAGE 0: Climate Control ============
                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("V")
                            color: "red"
                            font.pixelSize: 500
                            font.bold: true
                        }
                    }
                }

                // ============ PAGE 1: Navigation/Map ============
                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("K")
                            color: "Yellow"
                            font.pixelSize: 500
                            font.bold: true
                        }
                    }
                }

                // ============ PAGE 2: Phone/Contacts ============
                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("U")
                            color: "blue"
                            font.pixelSize: 500
                            font.bold: true
                        }
                    }
                }

                // ============ PAGE 3: Music Player ============
                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        // Avatar quay
                        Rectangle {
                            width: 63
                            height: 63
                            radius: width/2
                            anchors.verticalCenterOffset: -300
                            anchors.horizontalCenterOffset: -585
                            clip: true
                            anchors.centerIn: parent

                            Image {
                                id: rotatingAvatar
                                anchors.fill: parent
                                source: "qrc:/Images/face-ivi/Face1.png"
                                rotation: 0

                                NumberAnimation on rotation {
                                    id: rotationAnimation
                                    from: 0
                                    to: 360
                                    duration: 5000
                                    loops: Animation.Infinite
                                    running: isPlaying
                                }
                            }
                        }

                        Text {
                            text: "DA NANG"
                            x: 597
                            y: 15
                            color: textColor
                            font.pixelSize: 25
                        }

                        Text {
                            text: "23°"
                            x: 615
                            y: 50
                            color: textColor
                            font.bold: true
                            font.pixelSize: 49
                        }

                        Text {
                            id: timeText
                            x: 1214
                            y: 35
                            color: textColor
                            font.pixelSize: 25
                            font.bold: true

                            Timer {
                                interval: 60000
                                running: true
                                repeat: true
                                onTriggered: {
                                    timeText.text = new Date().toLocaleTimeString(Qt.locale("vi_VN"), "HH:mm")
                                }
                            }

                            Component.onCompleted: {
                                timeText.text = new Date().toLocaleTimeString(Qt.locale("vi_VN"), "HH:mm")
                            }
                        }

                        Text {
                            text: qsTr("H: 30°  L: 12°")
                            x: 605
                            y: 107
                            color: textColor
                            font.pixelSize: 15
                        }

                        Text {
                            text: "10PM"
                            x: 542
                            y: 133
                            color: textColor
                            font.pixelSize: 10
                        }

                        Text {
                            text: "11PM"
                            x: 586
                            y: 133
                            color: textColor
                            font.pixelSize: 10
                        }

                        Text {
                            text: "12PM"
                            x: 630
                            y: 133
                            color: textColor
                            font.pixelSize: 10
                        }

                        Text {
                            text: "1AM"
                            x: 682
                            y: 133
                            color: textColor
                            font.pixelSize: 10
                        }

                        Text {
                            text: "2AM"
                            x: 730
                            y: 133
                            color: textColor
                            font.pixelSize: 10
                        }

                        // Weather
                        Rectangle {
                            x: 544; y: 147
                            width: 24; height: 24
                            color: "transparent"

                            Text {
                                id: weather1
                                anchors.fill: parent
                                text: "⛈"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle {
                            x: 587; y: 147
                            width: 24; height: 24
                            color: "transparent"

                            Text {
                                id: weather2
                                anchors.fill: parent
                                text: "⛈"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle {
                            x: 631; y: 147
                            width: 24; height: 24
                            color: "transparent"

                            Text {
                                id: weather3
                                anchors.fill: parent
                                text: "🌧️"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle {
                            x: 680; y: 147
                            width: 24; height: 24
                            color: "transparent"

                            Text {
                                id: weather4
                                anchors.fill: parent
                                text: "🌧"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle {
                            x: 729; y: 147
                            width: 24; height: 24
                            color: "transparent"

                            Text {
                                id: weather5
                                anchors.fill: parent
                                text: "⛈️"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Text {
                            text: "29°"
                            x: 547
                            y: 177
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "27°"
                            x: 591
                            y: 177
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "25°"
                            x: 635
                            y: 177
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "22°"
                            x: 684
                            y: 177
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "18°"
                            x: 733
                            y: 177
                            font.pixelSize: 10
                            color: textColor
                        }

                        Rectangle {
                            x: 1146; y: 40
                            width: 24; height: 24
                            color: "transparent"

                            Image {
                                id: wifiIcon
                                source: "qrc:/Images/icon-ivi/Wifi.png"
                                anchors.fill: parent
                            }

                        }

                        // Music Model
                        ListModel {
                            id: musicModel

                            ListElement {
                                title: qsTr("Chúng Ta Của Hiện Tại")
                                artist: "Sơn Tùng M-TP"
                                cover: "qrc:/Images/face-ivi/ChungTaCuaHienTai.jpg"
                            }
                            ListElement {
                                title: "Thiên Lý Ơi"
                                artist: "Jack - J97"
                                cover: "qrc:/Images/face-ivi/ThienLyOi.jpg"
                            }
                            ListElement {
                                title: "Tết Đong Đầy"
                                artist: "Khoa"
                                cover: "qrc:/Images/face-ivi/TetDongDay.jpg"
                            }
                            ListElement {
                                title: "Right Now"
                                artist: "Akon"
                                cover: "qrc:/Images/face-ivi/RightNow.png"
                            }
                            ListElement {
                                title: "Last Christmas"
                                artist: "Wham"
                                cover: "qrc:/Images/face-ivi/LastChristmas.jpg"
                            }
                            ListElement {
                                title: "Việt Nam tôi"
                                artist: "Jack - KICM"
                                cover: "qrc:/Images/face-ivi/VietNamToi.jpg"
                            }
                            ListElement {
                                title: "Vua Hair tặc"
                                artist: "noname"
                                cover: "qrc:/Images/face-ivi/VietNamToi.jpg"
                            }
                            ListElement {
                                title: "Right now V2"
                                artist: "Akon x UIA"
                                cover: "qrc:/Images/face-ivi/RightNow.png"
                            }
                        }

                        // Function to load song
                        function loadSong(index) {
                            if (index >= 0 && index < musicModel.count) {
                                currentSongIndex = index
                                var item = musicModel.get(index)
                                avataMusic.source = item.cover
                                nameMusic.text = item.title
                                authorMusic.text = item.artist
                                currentTime = 0
                                customSlider.value = 0
                            }
                        }

                        Image {
                            id: avataMusic
                            x: 305
                            y: 233
                            source: musicModel.get(0).cover
                        }

                        Text {
                            id: nameMusic
                            x: 553
                            y: 233
                            text: musicModel.get(0).title
                            color: textColor
                            font.pixelSize: 25
                        }

                        Text {
                            id: authorMusic
                            x: 554
                            y: 276
                            color: textColor
                            text: musicModel.get(0).artist
                        }

                        // Timer để update slider khi đang phát nhạc
                        Timer {
                            id: playbackTimer
                            interval: 1000
                            running: isPlaying
                            repeat: true
                            onTriggered: {
                                if (currentTime < songDuration) {
                                    currentTime++
                                    customSlider.value = (currentTime / songDuration) * 100
                                } else {
                                    // Tự động chuyển bài tiếp theo khi hết bài
                                    isPlaying = false
                                    currentTime = 0
                                    customSlider.value = 0

                                    var next = currentSongIndex + 1
                                    if (next >= musicModel.count) {
                                        next = 0
                                    }
                                    playPauseButton.isPlaying = true
                                    isPlaying = true
                                    parent.loadSong(next)
                                    serialManager.sendSongNumber(next + 1)
                                }
                            }
                        }

                        // Hiển thị thời gian hiện tại
                        Text {
                            id: currentTimeText
                            x: 305
                            y: 505
                            color: textColor
                            font.pixelSize: 14
                            text: Math.floor(currentTime / 60) + ":" + (currentTime % 60 < 10 ? "0" : "") + (currentTime % 60)
                        }

                        Slider {
                            id: customSlider
                            x: 305
                            y: 479
                            width: 490
                            height: 15
                            from: 0
                            to: 100
                            value: 0

                            onMoved: {
                                // Cho phép người dùng kéo để thay đổi thời gian
                                currentTime = Math.floor((value / 100) * songDuration)
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                radius: height / 2
                                color: isDarkTheme ? "#2a6ba5" : "#00d9ff"
                                opacity: 0.8

                                Rectangle {
                                    width: customSlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: parent.radius
                                    color: isDarkTheme ? "#00d9ff" : "#2a6ba5"
                                    anchors.left: parent.left
                                }
                            }

                            handle: Rectangle {
                                width: 20
                                height: 20
                                radius: 10
                                color: isDarkTheme ? "#00d9ff" : "#2a6ba5"
                                anchors.verticalCenter: parent.verticalCenter
                                x: customSlider.visualPosition * (customSlider.width - width)
                            }
                        }

                        // Hiển thị tổng thời gian
                        Text {
                            id: totalTimeText
                            x: 768
                            y: 505
                            color: textColor
                            font.pixelSize: 14
                            text: Math.floor(songDuration / 60) + ":" + (songDuration % 60 < 10 ? "0" : "") + (songDuration % 60)
                        }

                        // Left icon
                        Rectangle {
                            x: 305; y: 537
                            width: 30; height: 30
                            color: "transparent"

                            Text {
                                id: leftIconText
                                anchors.fill: parent
                                text: "⇆"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: leftIconText.scale = 0.9
                                onReleased: leftIconText.scale = 1.0
                            }
                        }

                        // Right icon
                        Rectangle {
                            x: 765; y: 537
                            width: 30; height: 30
                            color: "transparent"

                            Text {
                                id: rightIconText
                                anchors.fill: parent
                                text: "♡"
                                font.pixelSize: 18
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: rightIconText.scale = 0.9
                                onReleased: rightIconText.scale = 1.0
                            }
                        }

                        // Nút Play/Pause
                        Item {
                            id: playPauseButton
                            x: 531
                            y: 526
                            width: 49
                            height: 52

                            property bool isPlaying: false

                            Text {
                                id: playPauseIcon
                                anchors.centerIn: parent
                                text: isPlaying ? "❚❚" : "▶︎"
                                color: iconColor
                                font.pixelSize: 32
                                font.bold: true

                                // Hiệu ứng scale khi nhấn
                                scale: playPauseMouseArea.pressed ? 0.8 : 1.0
                                Behavior on scale {
                                    NumberAnimation { duration: 100 }
                                }

                                // Hiệu ứng opacity khi nhấn
                                opacity: playPauseMouseArea.pressed ? 0.7 : 1.0
                                Behavior on opacity {
                                    NumberAnimation { duration: 100 }
                                }
                            }

                            MouseArea {
                                id: playPauseMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    isPlaying = !isPlaying
                                    console.log("Music button clicked - isPlaying:", isPlaying)
                                    if (isPlaying) {
                                        // Resume nhạc hoặc phát bài mới
                                        serialManager.sendCommand("start")
                                    } else {
                                        // Tạm dừng nhạc
                                        serialManager.sendCommand("pause")
                                    }
                                }
                            }

                        }

                        // Previous button
                        Rectangle {
                            x: 421; y: 537
                            width: 30; height: 30
                            color: "transparent"

                            Text {
                                id: musicLeftIcon
                                anchors.fill: parent
                                text: "◀◀"
                                font.pixelSize: 20
                                font.bold: true
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: musicLeftIcon.scale = 0.9
                                onReleased: musicLeftIcon.scale = 1.0
                                onClicked: {
                                    var prevIndex = currentSongIndex - 1
                                    if (prevIndex < 0) {
                                        prevIndex = musicModel.count - 1
                                    }
                                    playPauseButton.isPlaying = true
                                    isPlaying = true
                                    parent.parent.loadSong(prevIndex)
                                    serialManager.sendSongNumber(prevIndex + 1)
                                }
                            }
                        }

                        // Next button
                        Rectangle {
                            x: 665; y: 537
                            width: 30; height: 30
                            color: "transparent"

                            Text {
                                id: musicRightIcon
                                anchors.fill: parent
                                text: "▶︎▶︎"
                                font.pixelSize: 20
                                font.bold: true
                                color: iconColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: musicRightIcon.scale = 0.9
                                onReleased: musicRightIcon.scale = 1.0
                                onClicked: {
                                    var nextIndex = currentSongIndex + 1
                                    if (nextIndex >= musicModel.count) {
                                        nextIndex = 0
                                    }
                                    playPauseButton.isPlaying = true
                                    isPlaying = true
                                    parent.parent.loadSong(nextIndex)
                                    serialManager.sendSongNumber(nextIndex + 1)
                                }
                            }
                        }

                        Slider {
                            id: volumeSlider
                            x: 324
                            y: 641
                            width: 420
                            height: 15
                            from: 0
                            to: 100
                            value: 50

                            onValueChanged: {
                                var volDF = Math.round(volumeSlider.value * 30 / 100)
                                serialManager.sendData("vol:" + volDF + "\n")
                                console.log("Send volume:", volDF)
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                radius: height / 2
                                color: isDarkTheme ? "#2a6ba5" : "#00d9ff"
                                opacity: 0.8

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: parent.radius
                                    color: isDarkTheme ? "#00d9ff" : "#2a6ba5"
                                    anchors.left: parent.left
                                }
                            }

                            handle: Rectangle {
                                width: 20
                                height: 20
                                radius: 10
                                color: isDarkTheme ? "#00d9ff" : "#2a6ba5"
                                anchors.verticalCenter: parent.verticalCenter
                                x: volumeSlider.visualPosition * (volumeSlider.width - width)
                            }
                        }

                        Rectangle {
                            x: 241; y: 629
                            width: 40; height: 40
                            color: "transparent"

                            Image {
                                id: speakerIcon
                                source: "qrc:/Images/icon-ivi/Speaker.png"
                                anchors.fill: parent
                            }
                        }

                        Text {
                            text: "0"
                            font.pixelSize: 23
                            color: textColor
                            x: 305
                            y: 636
                        }

                        Text {
                            text: "100"
                            font.pixelSize: 23
                            color: textColor
                            x: 750
                            y: 635
                        }

                        Text {
                            text: qsTr("Playlist")
                            font.pixelSize: 40
                            color: textColor
                            x: 918
                            y: 143
                        }

                        ListView {
                            anchors.fill: parent
                            anchors.rightMargin: 35
                            anchors.bottomMargin: 111
                            anchors.leftMargin: 918
                            anchors.topMargin: 222
                            model: musicModel
                            spacing: 10
                            clip: true

                            delegate: Rectangle {
                                width: parent.width
                                height: 90
                                radius: 8
                                color: currentSongIndex === index ? (isDarkTheme ? "#333333" : "#D0D0D0") : (isDarkTheme ? "#1A1A1A" : "#F0F0F0")

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 15

                                    Image {
                                        source: cover
                                        width: 70
                                        height: 70
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }

                                    Column {
                                        spacing: 5
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            text: title
                                            font.pixelSize: 18
                                            font.bold: true
                                            color: textColor
                                        }

                                        Text {
                                            text: artist
                                            font.pixelSize: 15
                                            color: secondaryTextColor
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Playing:", title, "-", artist)
                                        var musicPage = parent.parent.parent.parent
                                        musicPage.loadSong(index)
                                        playPauseButton.isPlaying = true
                                        isPlaying = true

                                        serialManager.sendSongNumber(index + 1)
                                    }
                                }
                            }
                        }
                    }
                }

                // ============ PAGE 4: Settings ============
                Item {
                    Column {
                        anchors.centerIn: parent
                        spacing: 40

                        // ===== TITLE =====
                        Text {
                            id: settingsTitle
                            text: qsTr("SETTINGS")
                            font.pixelSize: 60
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: textColor
                        }

                        // ===== LIGHT/DARK MODE =====
                        Row {
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                id: modeText
                                text: qsTr("Light/Dark Mode:")
                                font.pixelSize: 28
                                color: textColor
                            }

                            Switch {
                                id: themeSwitch
                                checked: isDarkTheme
                                onClicked: {
                                    var newTheme = checked ? "dark" : "light"
                                    console.log("User clicked theme:", newTheme)
                                    serialManager.sendCommand("theme:" + newTheme)
                                    isDarkTheme = checked
                                 }
                            }

                        }

                        // ===== LANGUAGE =====
                        Row {
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                id: langText
                                text: qsTr("Language:")
                                font.pixelSize: 28
                                color: textColor
                            }

                            ComboBox {
                                id: languageBox
                                width: 200
                                model: ["en", "vi"]
                                currentIndex: 0
                                onCurrentIndexChanged: {
                                    console.log("Changing language to:", model[currentIndex])
                                    translatorMgr.switchLanguage(model[currentIndex])
                                    serialManager.sendCommand("lang:" + model[currentIndex])
                                 }
                            }
                        }
                    }
                }
            }
        }
    }
}
