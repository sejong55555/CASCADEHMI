import QtQuick 2.7
import QtQml 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import "../Global"

Rectangle {
    id: root

    width:Variables.sourceWidth
    height:Variables.sourceHeight

    color:"#26000000"

    property string headerText:"running mode"
    property var scrollviewmodel
    property string suffix:""

    property alias selectedDelegateColor: listcontents.currentIndex

    property real delegateTextBoxH:18

    property alias shadowV: popupShadow.verticalOffset
    property alias shadowH: popupShadow.horizontalOffset

    property alias popupW: moldbackground.width
    property alias popupH: moldbackground.height

    property alias scrollbarEnable: scrollbar.visible

    signal sigClickDelegate(string sendData)
    signal sigSelectedDelegate(string sendData)

    MouseArea{anchors.fill:parent;onClicked: {root.visible=false}}

    function listviewSizeFit(){
        moldbackground.height=scrollviewmodel.count*37+46
        listcontents.height=scrollviewmodel.count*37
    }

    Rectangle{
        id:moldbackground
        x:140;y:21
        width:200
        // height:scrollviewmodel.count*37+46
        height:231
        anchors.centerIn: parent
        color:"#FFFFFF"
        Column{
            id:mold
            anchors.fill: parent
            // topPadding: 21;leftPadding:140
            Rectangle{
                id:header
                width:parent.width
                height:46
                Text{
                    width:160
                    height:18
                    anchors.centerIn: parent
                    font.pixelSize: 18
                    color:"#222222"
                    text:headerText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                MouseArea{anchors.fill: parent}
            }
            Rectangle{
                id:midline
                width:200;height:2;color:"#DEE1E5"
            }

            ListView{
                id: listcontents
                width: parent.width
                height: 231-46
                opacity: 1
                clip: true
                model: scrollviewmodel
                delegate: delegateComponent

                ScrollBar.vertical: CscrollBar{id:scrollbar}
                Component.onCompleted: {
                    // listcontents.currentIndex=-1
                }
            }
        }
    }

   DropShadow {
       id:popupShadow
       anchors.fill: moldbackground
       // z: moldbackground.z-1
       verticalOffset: 4
       horizontalOffset: 10
       radius: 44
       samples: 1+radius*2
       color: "#000000"
       opacity: 0.25
       source: moldbackground
   }

    Component{
        id:delegateComponent
        Textmold{
            property int address: 0
            width: mold.width
            height: 37

            textfieldWidth: 160
            textfieldHeight: delegateTextBoxH
            textfieldText: listName+suffix
            textshadowEnable: false
            shadowEnable: false
            fontcolor: "#222222"
            fontsize: 18
            horizontalAlignment: Text.AlignLeft
            color: ListView.isCurrentItem ? "#dee1e5": "#ffffff"
            Component.onCompleted: {
                textFieldAlign()

            }
            MouseArea{
                anchors.fill:parent
                onClicked:{
                    listcontents.currentIndex = index;
                    sigClickDelegate(index)
                    {root.visible=false}
                }
            }
        }
    }

    onSigSelectedDelegate: {
        listcontents.currentIndex=sendData
    }

}



