import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
Item {
    id: root
    property real progress: 0.0             // 0.0 → 1.0
    property color colorStart: "#ffffff"    // màu bắt đầu
    property color colorEnd: "#ff6a00"      // màu kết thúc
    property real maxValue: 160             // giá trị tối đa để hiển thị số
    property alias valueText: textValue.text
    property bool allowUpdate: false


    Canvas {
        id: canvas
        anchors.fill: parent

        Connections {
                target: root
                onProgressChanged: canvas.requestPaint()
            }

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            var centerX = width / 2
            var centerY = height / 2
            var radius = Math.min(width, height) / 2 - 24

            var startAngle = Math.PI * 0.74
            var totalSweep = Math.PI * 1.53
            var endAngle = startAngle + totalSweep * root.progress

            ctx.clearRect(0, 0, width, height)

            // nền mờ
            ctx.beginPath()
            ctx.lineWidth = 14
            ctx.lineCap = "round"
            ctx.strokeStyle = "rgba(255,255,255,0.12)"
            ctx.arc(centerX, centerY, radius, startAngle, startAngle + totalSweep, false)
            ctx.stroke()

            // tiến độ
            ctx.beginPath()
            ctx.lineWidth = 12
            ctx.lineCap = "round"
            var g = ctx.createLinearGradient(centerX - radius, centerY, centerX + radius, centerY)
            g.addColorStop(0, root.colorStart)
            g.addColorStop(1, root.colorEnd)
            ctx.strokeStyle = g
            ctx.arc(centerX, centerY, radius, startAngle, endAngle, false)
            ctx.stroke()
        }
    }

    // Hiển thị giá trị
    Text {
        id: textValue
        anchors.centerIn: parent
        text: Math.round(root.progress * root.maxValue)
        font.pixelSize: 35
        color: "white"
    }

    // Hiệu ứng chuyển mượt
    Behavior on progress {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
}
