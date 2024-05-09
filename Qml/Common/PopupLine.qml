import QtQuick 2.7

import QtQml 2.0


import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4

Item{
    id:root

    property alias btn_offset_X: buttonRow.x
    property alias btn_offset_Y: buttonRow.y

    property alias textBox: textmold.textfieldText
    property alias textBoxShadowEnable: textmold.textshadowEnable

    property alias firstbtnText: firstbtn.btntext
    property alias secondbtnText: secondbtn.btntext
    property alias rowspacing: buttonRow.spacing
    property bool textBtnType: true // or "image"

    signal sigRClick()
    signal sigLClick()


    Textmold{
        id:textmold
        anchors.fill: parent
        textfieldX:20; textfieldY:30
        color:"#FFFFFF"
        textfieldWidth:400; textfieldHeight:20

        textshadowEnable:false
        horizontalAlignment: Text.AlignHCenter
        fontsize:20
        radius:15

        Row{
            topPadding:176;leftPadding:97;spacing:15
            id:buttonRow
            anchors.fill:parent

            TextButton{id:firstbtn;imagename:"cmd_gray";btntext:"Text";visible:textBtnType
                onSigClick:{
                    sigLClick()
                }
            }
            TextButton{id:secondbtn;imagename:"cmd_orange";btntext:"Text";visible:textBtnType
                onSigClick:{
                    sigRClick()
                }
            }
            TitleBarButton{id:firstTitlebtn;visible:(!textBtnType)
                onSigClick:{
                    sigLClick()
                }
            }
            TitleBarButton{id:secondTitlebtn;visible:(!textBtnType)
                onSigClick:{
                    sigRClick()
                }
            }
        }

    }

    states:[
        State{
            name:"1line"
            PropertyChanges{ target:textmold; textfieldX: 20; textfieldY: 30; wrapEnum: 0}
            PropertyChanges{ target:root; width: 440; height: 136}
            PropertyChanges{ target:buttonRow; y:80}
        },

        State{
            name:"2line"
            PropertyChanges{ target:textmold; textfieldWidth: 400; textfieldHeight: 44; textfieldX: 20; textfieldY: 76; wrapEnum: 3; linespace: 4}
            PropertyChanges{ target:root; width: 440; height: 232}
            PropertyChanges{ target:buttonRow; y:176}
        },

        State{
            name:"3line"
            PropertyChanges{ target:textmold; textfieldWidth: 400; textfieldHeight: 68; textfieldX: 20; textfieldY: 64; wrapEnum: 3; linespace: 4}
            PropertyChanges{ target:root; width: 440; height: 232}
            PropertyChanges{ target:buttonRow; y:176}
        },

        State{
            name:"4line"
            PropertyChanges{ target:textmold; textfieldWidth: 400; textfieldHeight: 92; textfieldX: 20; textfieldY: 50; wrapEnum: 3; linespace: 4}
            PropertyChanges{ target:root; width: 440; height: 232}
            PropertyChanges{ target:buttonRow; y:176}
        }
    ]

    function setText(textline){
        textmold.setTextfield(textline);
    }

    function textFieldAlign(){
        textmold.textFieldAlign();
    }
}

