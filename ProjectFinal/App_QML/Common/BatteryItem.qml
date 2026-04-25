import QtQuick 2.12

Item {
    id: root
    property real chargeLevel: 0
    property bool isCharging: false
    property int widthBattery: 159
    property int heightBattery: 250
    property real previousCharge: 0

    property int maxTimeMinutes: 60  // 100% pin = 60 phút
    property int remainingTime: Math.round((1 - chargeLevel / heightBattery) * maxTimeMinutes)


    width: widthBattery
    height: heightBattery + 100  // bao gồm text + head + status

    // Text Energy
    Text {
        id: textenergy
        text: qsTr("Energy")
        color: "#FFF"
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        font.pointSize: 15
    }

    // Main battery
    Rectangle {
        id: mainbattery
        width: widthBattery
        height: heightBattery
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: textenergy.bottom
        anchors.topMargin: 40
        radius: 20
        color: "#33373C"
        clip: true

        property real chargeLevel: root.chargeLevel
        property bool isCharging: root.isCharging

        // Rectangle sạc
        Rectangle {
            id: chargeFill
            width: parent.width
            height: mainbattery.chargeLevel
            anchors.bottom: parent.bottom
            color: "#00FF7F"
            radius: 18
            opacity: 0.9
            visible: mainbattery.isCharging
        }

        Image {
            id: flashcharge
            anchors.verticalCenterOffset: -22
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Images/Battery/Charge.png"
            anchors.centerIn: mainbattery
            anchors.horizontalCenterOffset: -50
            visible: mainbattery.isCharging

            Text {
                id: textcharge
                text: qsTr("Charging")
                color: "#FFF"
                font.pointSize: 16
                anchors.left: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 15
            }
        }

        Text {
            id: valuecharge
            width: 50; height: 50
            text: Math.round(mainbattery.chargeLevel / battery.heightBattery * 100) + "%"
            anchors.leftMargin: 0
            anchors.rightMargin: -100
            font.pointSize: 25
            color: "#FFF"
            anchors.top: flashcharge.bottom
            anchors.left: flashcharge.left
            anchors.right: flashcharge.right
            anchors.topMargin: 20
            horizontalAlignment: Text.AlignHCenter
            visible: mainbattery.isCharging
        }

        // Rectangle xả
        Rectangle {
            id: dischargeFill
            width: parent.width
            height: mainbattery.chargeLevel
            anchors.bottom: parent.bottom
            color: "#05D5FF"
            radius: 18
            opacity: 0.9
            visible: !mainbattery.isCharging
        }

        Text {
            id: valuechargeoff
            width: 50; height: 50
            text: Math.round(mainbattery.chargeLevel / battery.heightBattery * 100) + "%"
            anchors.leftMargin: 6
            anchors.topMargin: -14
            anchors.rightMargin: -100
            font.pointSize: 25
            color: "#FFF"
            anchors.top: flashcharge.bottom
            anchors.left: flashcharge.left
            anchors.right: flashcharge.right
            horizontalAlignment: Text.AlignHCenter
            visible: !mainbattery.isCharging
        }

    }

    // Head battery
    Image {
        id: headbattery
        anchors.left: mainbattery.left
        anchors.right: mainbattery.right
        anchors.bottom: mainbattery.top
        anchors.bottomMargin: 10
        source: "qrc:/Images/Battery/headbattery.png"
        fillMode: Image.PreserveAspectFit
        z: 3
    }

    // Status
    Item {
        id: status
        width: 170
        height: 33
        anchors.top: mainbattery.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25

        // Charging status
        Item {
            id: statusCharge
            anchors.fill: parent
            visible: mainbattery.isCharging
            Image { id: remainingimg; source: "qrc:/Images/Battery/Time-remain.png"; fillMode: Image.PreserveAspectFit }
            Text {
                id: textremain
                text: remainingTime + "m Remaining"  // sử dụng property remainingTime
                color: "#FFF"
                font.pointSize: 12
                anchors.left: remainingimg.right
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 5
                 }
        }

        // Discharge status
        Item {
            id: statusUse
            anchors.fill: parent
            visible: !mainbattery.isCharging
            Image { id: useimg; source: "qrc:/Images/Battery/Time-used.png"; fillMode: Image.PreserveAspectFit }
            Text {
               id: textuse
               text: (maxTimeMinutes - remainingTime) + "m Used"  // thời gian đã dùng
               color: "#FFF"
               font.pointSize: 12
               anchors.left: useimg.right
               anchors.leftMargin: 10
               anchors.top: parent.top
               anchors.topMargin: 5
              }
        }
    }
}
