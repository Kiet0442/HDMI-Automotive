import QtQuick 2.1

Item {
    id: root
    property real progress: 0.0          // 0.0 → 1.0
    property real startAngle: Math.PI*0.43
    property real totalSweep: Math.PI*0.44
    property bool reverse: false
    property color colorStart: "#00CC33"
    property color colorEnd: "#FFFFFF"
    property string labelMin: "0"
    property string labelMax: "100"
    property real iconSize: 30
    property real rotationAngle: 0
    property bool allowUpdate: false


    // 🔹 Behavior đúng chỗ — vì progress là property của root
    Behavior on progress {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        rotation: root.rotationAngle

        Connections {
            target: root
            onProgressChanged: canvas.requestPaint()
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centerX = width / 2;
            var centerY = height / 2;
            var radius = Math.min(width, height) / 2 - 24;
            var start = root.startAngle;
            var sweep = root.totalSweep;
            var end = start + sweep * root.progress;

            ctx.clearRect(0, 0, width, height);

            // nền mờ
            ctx.beginPath();
            ctx.lineWidth = 14;
            ctx.lineCap = "round";
            ctx.strokeStyle = "rgba(255,255,255,0.12)";
            ctx.arc(centerX, centerY, radius, start, start + sweep, false);
            ctx.stroke();

            // tiến độ
            ctx.beginPath();
            ctx.lineWidth = 12;
            ctx.lineCap = "round";

            var g = ctx.createLinearGradient(centerX - radius, centerY, centerX + radius, centerY);
            g.addColorStop(0, root.colorStart);
            g.addColorStop(1, root.colorEnd);
            ctx.strokeStyle = g;

            if (root.reverse) {
                var angleEnd = start + sweep;
                var currentAngle = angleEnd - sweep * root.progress;
                ctx.arc(centerX, centerY, radius, angleEnd, currentAngle, true);
            } else {
                ctx.arc(centerX, centerY, radius, start, end, false);
            }

            ctx.stroke();
        }
    }



    // Nhãn min
    Text {
        text: root.labelMin
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 13
        anchors.leftMargin: 170
        font.pointSize: 13
        color: "#FFFFFF"
    }

    // Nhãn max
    Text {
        text: root.labelMax
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 135
        anchors.leftMargin: 10
        font.pointSize: 13
        color: "#FFFFFF"
    }


}
