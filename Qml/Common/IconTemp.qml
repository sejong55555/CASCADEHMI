import QtQuick 2.7
import "../Global"
Textmold{
    id:root
    property string iconImageName: "water2"
    property string imagestate: ""
    property alias iconWidth: iconImage.width
    property alias iconHeight: iconImage.height
    property real distance:0

    property alias iconX: iconImage.x
    property alias iconY: iconImage.y

    property alias mouseEnable: mousearea.enabled

    signal sigClick()
    signal sigReleased()

    Image{
        id:iconImage
        width:24
        height:iconImage.width
        y:5
        source: Variables.sourcePath+"ic_"+iconImageName+imagestate+".png"
    }

    MouseArea{
        id:mousearea
        anchors.fill:parent
        enabled: false
        onPressed: {
            sigClick()
        }
        onReleased: {
            sigReleased()
        }
    }

    function iconCenterAlign(){
        iconX=0
        iconImage.anchors.verticalCenter=root.verticalCenter
    }

}
