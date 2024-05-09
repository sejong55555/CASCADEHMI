
import QtQuick 2.7

import QtQuick 2.10

import QtQuick.Controls 2.0

Textmold {
    id:root
    width: 440; height: 232; radius: 15
    horizontalAlignment:Text.AlignHCenter
    textfieldX: 20; textfieldY: 16; textfieldWidth: 400; textfieldHeight: 18;
    textfieldText:"Type Something"
    fontsize:18
    color:"#FFFFFF"

    property alias name: radiotext.textfieldText

    property real columnSpacing: toggleRow.spacing
    property int repeateCount: 2

    property alias firstTextField: radiotext.textfieldText
    property alias secondTextField: radiotext2.textfieldText

    property alias radiobtnChecked: radiobtn.checked
    property alias radiobtn2Checked: radiobtn.checked

    property alias firstbtnText: btnrow.firstbtnText
    property alias secondbtnText: btnrow.secondbtnText

    signal sigRightClick()
    signal sigLeftClick()

    Column {
        id: toggleRow
        x:20;y:71
        width:400;height:68
        padding: 0
        spacing:4
        // Repeater{
        //     model:repeateCount
            CRadioButton{
                id:radiobtn
                width:248;height:32
                property real indicatorW : indicatorImageW
                property real indicatorH : indicatorImageH
                anchors.horizontalCenter: toggleRow.horizontalCenter
                Textmold{
                    id:radiotext;
                    x:radiobtn.indicatorW + 4
                    width:212;height:20
                    textfieldWidth:width;textfieldHeight:height;fontsize:20
                    textfieldText: firstTextField
                    shadowEnable: false
                    textshadowEnable: false
                    anchors.verticalCenter: parent.verticalCenter
                    color:"transparent";
                }
            }
            CRadioButton{
                id:radiobtn2
                width:248;height:32
                property real indicatorW : indicatorImageW
                property real indicatorH : indicatorImageH
                anchors.horizontalCenter: toggleRow.horizontalCenter
                Textmold{
                    id:radiotext2;
                    x:radiobtn2.indicatorW + 4
                    width:212;height:20
                    textfieldWidth:width;textfieldHeight:height;fontsize:20
                    textfieldText: textFieldarray
                    anchors.verticalCenter: parent.verticalCenter
                    color:"transparent";
                }
            }
        // }
    }

    ButtonGroup {
        buttons: toggleRow.children
    }

    TextButtonRow{
        id:btnrow
        x:97;y:176
        width:247;height:36
        onSigRowRClickIn:{
            sigRightClick()
        }
        onSigRowLClickIn:{
            sigLeftClick()
        }
    }
}
