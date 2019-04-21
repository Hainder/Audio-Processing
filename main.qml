import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import DAW_CPP 1.0
import Qt.labs.platform 1.1
Window {

    visible: true
    width: 640
    height: 480
    title: appCaption.text


    TrackData {
         id: data

     }

    FileDialog {

        property string filepath: " "
        id: fileDialogSave
        title: "Please save file"
        //folder: shortcuts.music
        nameFilters: ["Audio Files (*.wav)","All files (*)"]
        fileMode: FileDialog.SaveFile;
        currentFile: "Wav"
        onAccepted: {

            fileDialogSave.filepath = fileDialogSave.currentFile.toString().replace("file:///", "")
            data.wavWrite(fileDialogSave.filepath);
            console.log("You chose: " + filepath)

        }
        onRejected: {
            console.log("Canceled")

        }


    }

    FileDialog {

        property string filepath: " "
        property bool soundexist: false
        id: fileDialog
        title: "Please choose a file"
        nameFilters: ["Audio Files (*.wav)","(*.ogg)","All files (*)"]
        onAccepted: {

            controlSound.gain = 1;
            controlSound.pan = 0;
            controlSound.timeshift = 0;
            fileDialog.filepath = fileDialog.currentFile.toString().replace("file:///", "")
            data.getSound(fileDialog.filepath)
            console.log("You chose: " + fileDialog.currentFile.toString().replace("file://", ""))
            tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,false);
            tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,false);

            fileDialog.soundexist = true
        }
        onRejected: {
            console.log("Canceled")

        }


    }
    Rectangle{
        anchors.fill: parent
        color: "#dadada"
        Text {
            id:appCaption
            text: "DAW Test Task"
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 12
        }
        Rectangle{
            id:controlsRect
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: appCaption.bottom
            anchors.margins: 5
            height: 30
            Row{
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 15
                Text {
                    id: controlsText
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Controls:"
                    font.pointSize: 12
                }
                Button{
                    id:zoomInButton
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 10

                    onClicked: {
                        tracksListView.end/=2
                        tracksListViewSec.end/=2

                    }
                    text: "+"
                }
                Button{
                    id:zoomOutButton
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 10
                    onClicked: {
                        tracksListView.end*=2
                        tracksListViewSec.end*=2
                    }
                    text: "-"
                }
                Button{
                    id:importButton
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 10
                    text: "Import"
                    onClicked: {
                        fileDialog.visible = true
                    }
                }
                Button{
                    property var str
                    id:generateButton
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 10
                    onClicked: {
                        // generate current mix to file
                        //
                        if (fileDialog.soundexist){
                            fileDialogSave.currentFile = fileDialogSave.currentFile.toString().replace("/", "");
                            fileDialogSave.visible = true
                         }
                    }
                    text: "Generate"
                }

            }

        }
        Control{
            anchors.topMargin: 5
            anchors.top: controlsRect.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle{
                property var gain: 1
                property var pan: 0
                property var timeshift: 0
                id: controlSound
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: controlsRect.bottom
                anchors.margins: 5
                height: 30
                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 15
                        Button{
                            id:gainPluss
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.gain += 0.1;
                                if(controlSound.gain>4){
                                    controlSound.gain = 4;
                                }
                                if (fileDialog.soundexist) {
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "Gain +"
                        }
                        Button{
                            id:gainMinus
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.gain -= 0.1;
                                if(controlSound.gain<0){
                                    controlSound.gain = 0;
                                }
                                if (fileDialog.soundexist){
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "Gain -"
                        }
                        Button{
                            id:panningLeft
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.pan -= 0.1;

                                if(controlSound.pan<-1){
                                    controlSound.pan = -1
                                }
                                if (fileDialog.soundexist) {
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "panning Left +"
                        }
                        Button{
                            id:panningCenter
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.pan = 0;
                                if(fileDialog.soundexist){
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "panning Center"
                        }
                        Button{
                            id:panningRight
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.pan += 0.1;

                                if(controlSound.pan>1){
                                    controlSound.pan = 1
                                }
                                if (fileDialog.soundexist){
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "panning Right +"
                        }

                    }//endof 1 Row
           }//endof Rectangle
            Rectangle{

                id: audiotimeshift
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: controlSound.bottom
                anchors.margins: 5
                height: 30
                    Row{
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 15
                        Button{
                            id:timeshiftleft
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.timeshift -= 0.5
                                if (controlSound.timeshift<0){
                                    controlSound.timeshift = 0;
                                }
                                if (fileDialog.soundexist){
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "Time Left +"
                        }
                        Button{
                            id:timeshiftzero
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.timeshift = 0
                                if (fileDialog.soundexist){
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "Time Zero"
                        }
                        Button{
                            id:timeshiftright
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                controlSound.timeshift += 0.5
                                if (fileDialog.soundexist){
                                    data.setEffects(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                    tracksListView.audiodata = data.getAudioLeft(fileDialog.filepath,true)
                                    tracksListViewSec.audiodata = data.getAudioRight(fileDialog.filepath,true)
                                }
                            }
                            text: "Time Right +"
                        }

                        Button{
                            id:playAudio
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 10
                            onClicked: {
                                if (fileDialog.soundexist){
                                    data.playAudio(fileDialog.filepath,controlSound.gain,controlSound.pan,controlSound.timeshift)
                                }
                            }
                            text: "Play"
                        }

                    }//endof 2 Row
           }
        }
        ListView{
            property int end: 48000*57 // sample rate * track duration(sec)
            property var audiodata: 0
            property var gain: 1
            anchors.topMargin: 70
            anchors.top: controlsRect.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: dropRect.top
            anchors.bottomMargin: 10
            id:tracksListView
            spacing: 10
            clip: true
            model: TracksModel{
                id:tracksListModel
            }
            delegate: Track {
                end:tracksListView.end
                width: tracksListView.width
                height: 120
                trackNameText: trackName
                audiodata: tracksListView.audiodata

            }
        }
        ListView{
            property int end: 48000*57 // sample rate * track duration(sec)
            property var audiodata: 0
            property var gain: 1
            anchors.topMargin: 200
            anchors.top: controlsRect.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: dropRect.top
            anchors.bottomMargin: 10
            id:tracksListViewSec
            spacing: 10
            clip: true
            model: TracksModelSec{
                id:tracksListModelSec
            }
            delegate: TrackSec {
                end:tracksListViewSec.end
                width: tracksListViewSec.width
                height: 120
                trackNameText: trackName
                audiodata: tracksListViewSec.audiodata

            }
        }

        Rectangle{
            id:dropRect
            color: "#fafafa"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            radius: 4
            border.color: "#ababab"
            border.width: 1
            Text {
                text: "Drop file here"
                font.pointSize: 12
                anchors.centerIn: parent
            }
            DropArea{
                anchors.fill: parent
            }
        }
    }
}
