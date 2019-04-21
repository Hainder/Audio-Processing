import QtQuick 2.12
import QtQuick.Controls 2.5
import DAW_CPP 1.0



Item {
    property alias trackNameText: trackNameText.text
    property int end: 0
    property var audiodata: 0
    property var gain: 1
    onEndChanged: {
        drawCanvas.requestPaint()
    }
    onAudiodataChanged: {
        drawCanvas.requestPaint()
    }
    //onGainChanged: {
    //    drawCanvas.requestPaint()
    //}

    TrackData {
         id: data

     }


    id: root


    Rectangle {
        anchors.fill: parent
        anchors.margins: 5
        color: "#cecece"
        border.color: "#ababab"
        border.width: 1
        radius: 4
        Text {
            id: trackNameText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 4
        }
        Rectangle {
            id: trackViewDelim
            anchors.topMargin: 2
            anchors.top: trackNameText.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#ababab"
        }
        Item {
            id: trackRawView
            anchors.top: trackViewDelim.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 4
            clip: true

            Canvas {
                id: drawCanvas
                anchors.fill: parent
                anchors.bottomMargin: 20
                onPaint: {
                    // uncomment to view profiling info in application log
                    // console.time("DRAW TIME")
                    var ctx = drawCanvas.getContext('2d')
                    ctx.reset()
                    ctx.fillStyle = "#414141"
                    ctx.fillRect(0, 0, drawCanvas.width, drawCanvas.height)
                    var arrayToDraw =    root.audiodata
                    ctx.fillStyle = "#ffccdd"
                    for (var i = 0; i < drawCanvas.width; ++i) {
                        var yPos = arrayToDraw[Math.floor(
                                                   i * root.end / drawCanvas.width)]
                                * drawCanvas.height / 2
                        ctx.fillRect(i, drawCanvas.height / 2 + yPos, 1, 1)
                    }
                    ctx.fill()
                    // uncomment to view profiling info in application log
                    // console.timeEnd("DRAW TIME")
                }

            }

            Item {
                id: timingRepeater
                anchors.fill: parent
                property int barsCount: drawCanvas.width / 90
                Repeater {
                    model: timingRepeater.barsCount
                    Rectangle {
                        anchors.top: timingRepeater.top
                        anchors.bottom: timingRepeater.bottom
                        width: 1
                        color: "#ababab"
                        x: index * drawCanvas.width / timingRepeater.barsCount
                        Text {
                            id: timeText
                            anchors.leftMargin: 2
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom

                        }
                    }
                }
            }
        }
    }
}
