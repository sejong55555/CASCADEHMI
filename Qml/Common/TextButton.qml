import QtQuick 2.7
import "../Global"

Item {
    id:root
    width:116;height:36
    property string btntext:""
    property alias btnsource: btn.source
    property string imagename: "cmd_orange"
    property string imagestate: "n"
    property string prestate: ""
    property bool dim: (imagestate==="d")? false : true

    property alias textBoxW: textfield.width
    property alias textBoxH: textfield.height

    property alias fontsize: textfield.font.pixelSize

    property string fontcolor: "#222222"

    property alias verticalAlignment:  textfield.verticalAlignment;
    property alias horizontalAlignment:  textfield.horizontalAlignment

    signal sigClick()

    Image{
        id:btn
        anchors.fill: parent
        source:Variables.sourcePath+"btn_"+imagename+"_"+imagestate+".png"

        Text{
            id:textfield
            width:88;height:18
            font.pixelSize: height
            text: btntext
            color: (imagename==="cmd_orange")?"#FFFFFF":fontcolor
            anchors.centerIn: parent
            verticalAlignment:  Text.AlignVCenter
            horizontalAlignment:  Text.AlignHCenter
        }

        MouseArea{
            id:mousearea
            enabled:dim
            anchors.fill: parent
            onPressed: {
                prestate = imagestate
                imagestate = "p"
            }
            onReleased: {
                imagestate = prestate
                sigClick()
            }
        }
    }
}

