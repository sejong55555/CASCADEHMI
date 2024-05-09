import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQml 2.0
import "../Global"

Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight

    color:"#26000000"

    property real scrollBarWidth: 3
    property real scrollBarHeight: 7.5
    property alias listmodels:  listcontents.model

    property string headerText:"running mode"

    property var scollviewmodel
    property string suffix

    signal sigClickscroll()
    MouseArea{anchors.fill:parent;onClicked: {root.visible=false}}
    Column{
        width:200;height:231
        topPadding:21
        leftPadding:140
        Rectangle{
            id:header
            width:parent.width;height:46
            Text{
                width:160;height:18
                anchors.centerIn: parent
                font.pixelSize: 18
                color:"#222222"
                text:headerText
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Rectangle{
            id:bottomline
            width:parent.width;height:2
            color:"#DEE1E5"
        }
        ScrollView{
            id: mainscrollview
            width:200;height:185
            style: scrollbarstyle
            verticalScrollBarPolicy:  Qt.ScrollBarAsNeeded
            ListView{
                id:listcontents
                width:200;height:185
                // anchors.fill:  parent
                clip: true
                model: scollviewmodel
                delegate:  delegateComponent
            }
        }
    }

    Component{
        id: scrollbarstyle
        ScrollViewStyle {
            // transientScrollBars : false
                handle:  Rectangle {
                    implicitWidth:  scrollBarWidth
                    implicitHeight:  scrollBarHeight
                    radius: 15
                    color:  "#999999"
                    }
                scrollBarBackground:  Rectangle{width: scrollBarWidth;height: scrollBarHeight;color:"red";opacity: 1}
                decrementControl:  null
                incrementControl:  null
        }
    }

    Component{
        id: delegateComponent
        Rectangle{
            // z: -1
            width: 200
            height: 37
            color: "#FFFFFF"
            Text{
                anchors.centerIn:  parent
                width: 160
                height: 21
                text: index+suffix
                font.pixelSize: 18
            }
            MouseArea{
                anchors.fill:parent
                onPressed: {
                }
                onClicked: {
                    sigClickscroll()
                }
            }
        }
    }
}

