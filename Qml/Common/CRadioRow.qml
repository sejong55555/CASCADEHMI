import QtQuick 2.7
import QtQuick 2.10
import QtQuick.Controls 2.0
import "../Global"

Rectangle{
    width:radiobtn.indicatorW+radiotext.width+radiobtn2.indicatorW+radiotext2.width+toggleRow.spacing
    height:radiobtn.indicatorH
    color:"transparent"

    property alias btnGroupExclusive:btnGroup.exclusive
    property alias radiobtnCheck:radiobtn.checked
    property alias radiobtn2Check:radiobtn2.checked

    property string leftRadiotext:"Every Week"
    property string rightRadiotext:"Set Period"

    property bool clickEnable: true

    property int leftRadioBoxW:113
    property int rightRadioBoxW:104

    signal _sigradioLClick()
    signal _sigradioLOff()
    signal _sigradioRClick()
    signal _sigradioROff()

    signal _siginitchecked()
    signal _sigleftToggleInit()

   Row{
       id:toggleRow
       spacing:20
       CRadioButton{
           id:radiobtn
           width:leftRadioBoxW;height:32
           enabled:clickEnable

           property real indicatorW : indicatorImageW
           property real indicatorH : indicatorImageH
           anchors.verticalCenter : toggleRow.verticalCenter
           // checked: true
           Textmold{
               id:radiotext;
               x:radiobtn.indicatorW
               width:81;height:16
               textfieldWidth:width;textfieldHeight:height;fontsize:16
               textfieldText: leftRadiotext
               fontcolor: "#555555"
               shadowEnable: false
               textshadowEnable: false
               anchors.verticalCenter: parent.verticalCenter
               color:"transparent";
           }
           onCheckedChanged:{
               if(checked){
                   _sigradioLClick()
               }
               else{
                   _sigradioLOff()
               }
           }
       }
       CRadioButton{
           id:radiobtn2
           width:rightRadioBoxW;height:32
           property real indicatorW : indicatorImageW
           property real indicatorH : indicatorImageH
           anchors.verticalCenter : toggleRow.verticalCenter
           enabled:clickEnable
           checked: false
           Textmold{
               id:radiotext2;
               x:radiobtn2.indicatorW
               width:72;height:16
               textfieldWidth:width;textfieldHeight:height;fontsize:16
               textfieldText: rightRadiotext
               fontcolor: "#555555"
               anchors.verticalCenter: parent.verticalCenter
               color:"transparent";
           }
           onCheckedChanged:{
               if(checked){
                   _sigradioRClick()
               }
               else{
                   _sigradioROff()
               }
           }
       }
   }

    ButtonGroup {
        id:btnGroup
        buttons: toggleRow.children
        exclusive : false
        // checkState :Qt.Unchecked
    }

    on_Siginitchecked: {
        radiobtn.checked=true
        radiobtn2.checked=false
    }

    on_SigleftToggleInit:{
        radiobtn.checked=false
    }
}
