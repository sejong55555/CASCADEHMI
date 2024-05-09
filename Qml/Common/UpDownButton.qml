import QtQuick 2.7
import "../Global"
Rectangle {
    id:root
    width:28;height:width*2
    color:"transparent"

    signal sigupClick()
    signal sigdownClick()

    Column{
        width:28;height:width*2
        Image{
            id:upbtn
            property string _imagestate : "n"
            property string _prestate: ""
            property bool _dim: (upbtn._imagestate==="d")? false : true
            width:root.width;height:width
            source:Variables.sourcePath+"btn_temp_up_"+upbtn._imagestate+".png"
            MouseArea{
                anchors.fill:parent
                enabled:upbtn._dim
                onPressed: {
                    upbtn._prestate = upbtn._imagestate
                    upbtn._imagestate = "p"
                }
                onReleased: {
                    upbtn._imagestate = upbtn._prestate
                    sigupClick()
                }
            }
        }
        Image{
            id:downbtn
            width:root.width;height:width
            property string _imagestate : "n"
            property string _prestate: ""
            property bool _dim: (downbtn._imagestate==="d")? false : true
            source:Variables.sourcePath+"btn_temp_down_"+downbtn._imagestate+".png"
            MouseArea{
                anchors.fill:parent
                enabled:downbtn._dim
                onPressed: {
                    downbtn._prestate = downbtn._imagestate
                    downbtn._imagestate = "p"
                }
                onReleased: {
                   downbtn._imagestate = downbtn._prestate
                    sigdownClick()
                }
            }
        }
    }

}
