
import QtQuick 2.7

import QtQuick 2.10

import QtQml 2.0
import "../Global"

Rectangle {
    id:root
    width:Variables.sourceWidth;
    height:150
    // width:175.73;height:147.74
    color:"#EEEEEE"

    signal sigClickNumber(string _numText)
    property string precolor

    GridView{
        id:numbergrid
        width:180;
        height:147.74
        interactive: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        topMargin:5
        // leftMargin: 152-1.865;rightMargin: 151.73-1.865;
        cellWidth:56.27+3.73;cellHeight :32.28+3.73;
        // cellHeight :32.28;cellWidth:56.27

        model:themodel
        delegate: numberkeydelegate
    }

    Component{
        id:numberkeydelegate
        Rectangle{
            id:cellmold
            width:56.27;height:32.28;radius:4
            color:(numText==="enter-868482")?"#FF9305":(numText==="backspace-868482")?"#6D6D6D":"#FFFFFF"
            Textmold{
                id:textmold
                anchors.fill:parent;anchors.centerIn: parent
                radius:4;color:"transparent"
                visible:(numText==="enter-868482"||numText==="backspace-868482")?false:true
                textfieldWidth:9;textfieldHeight:16;fontsize:14;fontcolor:"#555555";
                horizontalAlignment: Text.AlignHCenter
                textfieldText: numText
                shadowEnable:false
                Component.onCompleted: {
                    textFieldAlign()
                }
            }
            Image{
                id:imagemold
                visible:(numText==="enter-868482"||numText==="backspace-868482")?true:false
                width:20;height:13
                anchors.centerIn: parent
                source:(numText==="enter-868482"||numText==="backspace-868482")?Variables.sourcePath+numText+".svg":""
            }
            MouseArea{
                id:cellmousearea
                property var precolor
                anchors.fill:cellmold

                onPressed: {
                    cellmousearea.precolor=(numText==="enter-868482")?"#FF9305":(numText==="backspace-868482")?"#6D6D6D":"#FFFFFF"
                    numbergrid.currentIndex=index;
                    cellmold.color="#AAAAAA"
                    sigClickNumber(numText)
                }
                onReleased: {
                    cellmold.color=cellmousearea.precolor
                }
            }
        }
    }

    ListModel{
        id:themodel
        ListElement{numText:"1"}
        ListElement{numText:"2"}
        ListElement{numText:"3"}
        ListElement{numText:"4"}
        ListElement{numText:"5"}
        ListElement{numText:"6"}
        ListElement{numText:"7"}
        ListElement{numText:"8"}
        ListElement{numText:"9"}
        ListElement{numText:"backspace-868482"}
        ListElement{numText:"0"}
        ListElement{numText:"enter-868482"}
    }
}
