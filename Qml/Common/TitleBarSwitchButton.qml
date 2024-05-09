import QtQuick 2.10
import "../Global"
Item {
    id:root
    width:56;height:30
    property alias btnsource: btn.source
    property string prestate: ""
    property string imagename: "switch"
    property string imagestate:imagestateFlag===true? "left":"right"

    property bool imagestateFlag: true

    property bool dim: (imagestate==="d")? false : true

    signal sigClickSwitch()

    Image{
        id:btn
        anchors.fill: parent
        source:Variables.sourcePath+"btn_"+imagename+"_"+imagestate+".png"
        MouseArea{
            id:mousearea
            enabled:dim
            anchors.fill: parent
            onClicked: {
                imagestateFlag=!imagestateFlag
                sigClickSwitch()
            }
        }
    }
}
