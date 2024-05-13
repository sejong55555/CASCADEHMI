import QtQuick 2.7
import QtQuick 2.10
import QtQml 2.0
import QtQuick.VirtualKeyboard 2.0
import "../Global"
import "../Common"
Rectangle {
    id:root
    width:Variables.sourceWidth;height:Variables.sourceHeight

    property string setUsage: "" //설정할 전체 사용량
    signal sigBackClickInputEnergy()
    signal sigDoneClickInputEnergy(string _setTotalusage)

    Column{
        TitleBar{
            left_1st_Text:qsTr("전체 용량")
            onSigLClickTitleBar:{
                sigBackClickInputEnergy(setUsage)
            }
        }
        Rectangle{
            width:root.width;height:70
            Text{
                x:20;y:8
                width:440;height:14
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color:"#555555"
                text:qsTr("설치된 실외기 용량을 입력해주세요.")
                font.pixelSize: 14
            }
            CTextField{
                id:setTextBox
                x:120;y:32
                width:240;height:30
                // textFieldText: setUsage
                defaultText:"0~99999"
                activeText:"0~99999"
                focusOpt:true
                clickEnable:true
                textFieldvalidator:IntValidator{}

                InputPanel {
                    id: virtualKeyboard
                    visible: false
                    width: Variables.sourceWidth
                    height: Variables.sourceHeight* 0.4
                    x:100
                    y: Variables.sourceHeight - height
                }

                on_SigTextFieldInit: {
                    setUsage=""
                }
                Component.onCompleted:{
                    setTextBox.sigActiveFocus()
                }
            }
        }
        Cnumberpad{
            onSigClickNumber: {

                if(_numText==="enter-868482"){
                    sigDoneClickInputEnergy(setUsage)
                }
                else if(_numText==="backspace-868482"){
                    setUsage=setUsage.slice(0, -1)
                }
                else{
                    setUsage=setUsage+_numText
                }
                setTextBox.textFieldText=setUsage
                // console.log(setUsage)
            }
        }
    }
    onSetUsageChanged: {
        setTextBox.textFieldText=setUsage
    }
}
