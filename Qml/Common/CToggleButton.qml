import QtQuick 2.7
import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Global"
Item {
    id:root
    width:37
    height:20
    property alias btnsource: btn.source
    // property string imagename: "toggle"
    property string imagename: "on"
    property string imagestate: "n"//or "off"
    property bool dim: (imagestate==="d")? false : true

    signal _sigtoggleOff()
    signal _sigtoggleOn()

    signal sigtoggleInit(bool initdefalut)

    Image{
        id:btn
        anchors.fill: parent
        source:Variables.sourcePath+"btn_toggle"+"_"+imagename+"_"+imagestate+".png"
        MouseArea{
            id:mousearea
            enabled:dim
            anchors.fill: parent
            onClicked: {
                if(imagename==="on"){
                    imagename="off"
                    _sigtoggleOff()
                }
                else if(imagename==="off"){
                    imagename="on"
                    _sigtoggleOn()
                }
                else{
                    imagename==="d"
                }
            }
        }
    }

    onSigtoggleInit:{
        if(initdefalut===true){
            imagename="on"
        }
        else if(initdefalut===false){
            imagename="off"
        }
    }
}
