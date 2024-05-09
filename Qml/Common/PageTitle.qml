import QtQuick 2.7
import QtQml 2.0
import QtGraphicalEffects 1.0
import "../Global"
Item{
    id:root
    property alias color: background.color
    property real backgoundOpacity:1.0

    property string lefticonname: ""
    property string righticonname : ""

    property alias lefticonSize:lefticon.width
    property alias righticonSize:righticon.width

    property alias leftpadding:titlerow.leftPadding
    property alias rightpadding:titlerow.rightPadding
    property alias toppadding:titlerow.topPadding
    property alias bottompadding:titlerow.bottomPadding

    property alias iconspacing: titlerow.spacing

    signal sigRClickPage()
    signal sigLClickPage()

    Rectangle{
        id:background
        width:parent.width;height:38
        color:"#FFFFFF";opacity: backgoundOpacity
    }

    DropShadow {
        visible: true
        anchors.fill: background
        // z: background.z
        verticalOffset: 5
        radius: 30
        samples: 1+radius*2
        color: "#000000"
        opacity: 0.05
        source: background
    }

    Row{
        id:titlerow
        leftPadding:6;
        rightPadding:6;
        topPadding:1;
        bottomPadding: 1
        spacing: 396

        Image{
            id:lefticon
            width:36;height:lefticon.width
            anchors.verticalCenter: parent.verticalCenter
            source:Variables.sourcePath+"btn_"+lefticonname+"_"+lefticon._imagestate+".png"

            property string _imagestate : "n"
            property string _prestate: ""
            property bool _dim: (lefticon._imagestate==="d")? false : true

            MouseArea{
                anchors.fill:lefticon
                enabled:lefticon._dim
                onPressed: {
                    lefticon._prestate = lefticon._imagestate
                    lefticon._imagestate = "p"
                }
                onReleased: {
                    lefticon._imagestate = lefticon._prestate
                    sigLClickPage()
                }
            }
        }
        Image{
            id:righticon
            width:36;height:righticon.width
            anchors.verticalCenter: parent.verticalCenter
            source:Variables.sourcePath+"btn_"+righticonname+"_"+righticon._imagestate+".png"

            property string _imagestate:"n"
            property string _prestate: ""
            property bool _dim: (righticon._imagestate==="d")? false : true

            MouseArea{
                anchors.fill:righticon
                enabled:righticon._dim
                onPressed: {
                    righticon._prestate = righticon._imagestate
                    righticon._imagestate = "p"
                }
                onReleased: {
                    righticon._imagestate = righticon._prestate
                    sigRClickPage()
                }
            }
        }
    }
}
