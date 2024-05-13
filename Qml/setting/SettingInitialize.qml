import QtQuick 2.7
import "../Global"
import "../Common"
Item {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight

    property int currentImage: 0
    property real doneTime: 0

    property alias textBoxText: textBox.text

    property alias colTopPadding: col.topPadding
    property alias fontsize:textBox.font.pixelSize
    property alias fontcolor:textBox.color

    property string imageIndex: "00"
    signal sigInitDone()

    Rectangle{
        id:background
        color:"#FFFFFF"
        anchors.fill:parent
        MouseArea{
            anchors.fill:parent
        }
    }

    onCurrentImageChanged: {
        if(currentImage.toString().length<2){
            imageIndex="0"+currentImage.toString()
        }
        else{
            imageIndex=currentImage.toString()
        }
    }
    Column{
        id:col
        anchors.fill:parent
        leftPadding:40;topPadding:100;spacing:12
        Image
        {
            id: initializingimage
            width:40;height:40
            anchors.horizontalCenter: parent.horizontalCenter
            source : Variables.sourcePath + "loading/Loading_" + imageIndex+ ".png"
            SequentialAnimation {
                id: initializingSeq
                loops: Animation.Infinite
                NumberAnimation {target: root; property: "currentImage"; from: 0; to: 34; duration: 1000}
                onStopped: {
                    currentImage=0
                   // initializingSeq.running = false
                }
            }
        }
        Text{
            id:textBox
            width:400;height:20
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            // text:qsTr("Changing language...")
            font.pixelSize: 20
            color:"#222222"
        }
    }

    SequentialAnimation {//have to remove
        id: initializingStart//temp interface로 init신호 보내서 3초뒤에 init완료 한다고 가정
        // loops: Animation.Infinite
        loops: 1
        NumberAnimation {target: root; property: "doneTime";from: 0;duration:3000}
        onStopped: {
            initDone()// engine에서 init 완료확인 신호를 받아오는 부분 signal로 받아오면 initDone실행으로 변경
        }
    }

    function initStart(){
        initializingSeq.start()
        initializingStart.start()//temp ionterface로 init 신호 보내야함
    }

    function initDone(){
        //from engine initialize signal
        currentImage=0;doneTime=0;
        initializingSeq.running = false
        // initializingSeq.stop()
        sigInitDone()
    }

    function animationStop(){
        currentImage=0;doneTime=0;
        initializingSeq.running = false
    }
}

