import QtQuick 2.7

Item{
    id: root
    x: 20; y: 210
    width: 440; height: 42
    property string textstring

    property real appearTime : 1000
    property real fadeoutTime : 1000
    property real operationTime : 1000

    signal sigFadeStart()
    signal sigFadeDone()

    Textmold{
        id: textmold
        anchors.fill: parent
        textfieldWidth: 400
        textfieldHeight: 18
        color: "#56595D"
        radius: 21
        clip: true
        textfieldText: textstring
        fontsize: 18
        fontcolor: "#FFFFFF"

        Component.onCompleted:{
            shadowEnable = false
            horizontalAlignment = Text.AlignHCenter
            verticalAlignment = Text.AlignVCenter
            textFieldAlign()
        }
    }

    SequentialAnimation {
        id: fadeout
        loops: 1
        NumberAnimation {target: textmold; property: "opacity"; from: 0; to:1; duration: appearTime}
        NumberAnimation {target: root; property: "operationTime"; from: 0; duration: operationTime}
        NumberAnimation {target: textmold; property: "opacity"; from: 1; to: 0; duration: fadeoutTime}
        onStopped: {
           fadeout.running = false
           sigFadeDone()
        }
    }

    states:[
        State{
            name:"1line"
            PropertyChanges{ target:textmold; wrapEnum: 1}
            PropertyChanges{ target:root; width: 440; height: 42; }
        },

        State{
            name:"2line"
            PropertyChanges{ target:textmold; textfieldWidth: 400; textfieldHeight: 18*2 + 5*1 ; wrapEnum: 2; linespace: 5}
            PropertyChanges{ target:root; width: 440; height: 65; x: 20; y: 187}
        }
    ]

    function textFieldAlign(){
        textmold.textFieldAlign();
    }

    onSigFadeStart: {
        fadeout.start()
    }
}
