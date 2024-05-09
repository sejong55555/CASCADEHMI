
import QtQuick 2.7

import QtQuick 2.10

import QtQml 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.0

import "../Global"

//active = focus 상태 일 때 이미지 source 변경되고 x버튼 생성 x버튼: text 전부 지우기
Item{
    id:root
    property string imagestate:(textfield.focus===true)? "s" : "n"
    property real echomode: 0 // 0: normal, 2: password
    property alias placeholdertext: textfield.placeholderText
    property bool focusOpt: false

    property string defaultText:"Default"
    property string activeText:"Active Text"

    property string textFieldText:""
    property var textFieldvalidator:textfield.validator
    property bool clickEnable: true

    signal _sigFocusOff()
    signal _sigTextFieldInit()
    signal _sigHideKeyboard()
    signal sigActiveFocus()

    Image{
        id:moldimage
        width:240;height:30;
        source: Variables.sourcePath+"bg_input_"+imagestate+".png"
        Image{
            id: deletbtn
            x:210;
            width:30;height:30
            source:Variables.sourcePath+"btn_input_delete_n.png"
//            background:Image{source:Variables.sourcePath+"btn_input_delete_n.png"}
            visible: false
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    textFieldText = ""
                    _sigTextFieldInit()
                }
            }
        }
    }

    Item{
        id:moldtext
        x:moldimage.x + 12
        y:moldimage.y + 7
        width: 216; height:16
        TextField{
            id:textfield;
            z:-1
            anchors.fill: parent
            verticalAlignment: TextInput.AlignVCenter
            placeholderText: "Default"
            text:textFieldText
            echoMode: echomode
            focus:focusOpt
            font.pixelSize:16
            passwordCharacter: "*"
            padding: -1;
            enabled: clickEnable

            background: Rectangle{border.color:"transparent"; color:"transparent";}
            onEnabledChanged: {
                textfield.focus=enabled
            }
        }        
    }

    state: (textfield.focus===true)? "active" : "default"

    states:[
        State{
            name:"default"
            PropertyChanges{ target: moldtext; width:216}
            PropertyChanges { target: textfield; placeholderText:defaultText}
            PropertyChanges{ target: deletbtn; visible: false}
        },

        State{
            name:"active"
            PropertyChanges{ target: moldtext; width: 183}
            PropertyChanges { target: textfield; placeholderText:activeText}
            PropertyChanges{ target: deletbtn; visible: true}
        }
    ]

    on_SigFocusOff:{
        focusOpt=false
        textfield.focus=focusOpt
    }

    onSigActiveFocus:{
        textfield.forceActiveFocus()
    }

    // on_SigTextFieldInit:{
    //     textfield.text=""
    //     textFieldText=""
    // }
}
