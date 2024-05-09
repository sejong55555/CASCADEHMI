import QtQuick 2.7
import QtQml 2.0
import "../Common"
Rectangle{
    id:root
    width:480;height:272

    property string currentState:"cool" //running mode에서 선택(클릭)된 device
    signal sigbackClick()
    signal sigDefaultRunmode(string _runmode)//home circuit에서 보여지는 device가 running mode 창의 기본 선택된 device보여주기 위함
    signal sigSendRunmode(string sendrunmode)//선택된 device가 home circuit에서 보이도록 함

    Column{
        TitleBar{
            id:runnigmodetitle
            left_1st_Text: qsTr("Running Mode")
            onSigLClickTitleBar: {
                sigbackClick()
            }
        }
        Row{
            id:contentmold
            topPadding: 56;
            leftPadding:20;spacing:10
            Repeater{
                model:['Cool','Heat','Auto']
                IconTemp{
                    id:icon
                    property string iconnameprefix: "mode_card_"

                    width:140
                    height:98;
                    radius:6
                    color:currentState===modelData?"#222222":"#DEE1E5"
                    shadowEnable: false
                    textshadowEnable: false

                    iconX:46;iconY:16
                    iconWidth:47;iconHeight:36
                    textfieldX:10;textfieldY:64
                    textfieldWidth:120;textfieldHeight:18
                    horizontalAlignment: Text.AlignHCenter
                    fontsize:18
                    fontcolor:currentState===modelData?"#FFFFFF":"#222222"

                    imagestate: currentState===modelData? "s":"n"
                    iconImageName: icon.iconnameprefix + modelData.charAt(0).toLowerCase() + modelData.slice(1) +  "_"

                    textfieldText: qsTr(modelData)

                    mouseEnable:true

                    onSigClick: {
                        currentState=modelData
                    }
                    onSigReleased: {
                        sigSendRunmode(currentState)
                        //currentState에 맞는 기기운전 함수를 callback해서 신호 보냄
                        //home circuit 화면으로 돌아가야함
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        console.log(currentState)
        //현재 운전중인 상태를 engine에서 가져와서 currentState에 저장해서 사용cool heat auto에 맞게
    }

    onSigDefaultRunmode:{
        currentState=_runmode
    }
}
