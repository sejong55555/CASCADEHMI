import QtQuick 2.7
import "../Global"
Rectangle {
    id:root
    width:56;height:30
    color:"transparent"

    property alias btnsource: btn.source
    property string prestate: ""
    property string imagename: "add"
    property string imagestate: "n"
    property bool dim: (imagestate==="d")? false : true

    property string btnORicon:"btn_"

    signal sigClick()

    Image{
        id:btn
        anchors.fill: parent
        source:Variables.sourcePath+btnORicon+imagename+"_"+imagestate+".png"
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
