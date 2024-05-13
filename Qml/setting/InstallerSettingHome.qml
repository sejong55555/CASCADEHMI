import QtQuick 2.7
import QtQml 2.0
import QtQuick.VirtualKeyboard 2.0
import "../Global"
import "../Common"

Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight

    property string inputPassword

    signal sigDoneClickInstallerSetting()

    Column{
        TitleBar{
            id:title
            left_1st_Text: qsTr("Installer Password")
            state:"A"

            onSigLClickTitleBar:{
                root.visible=false
            }
        }

        Rectangle{
            width:Variables.sourceWidth
            height:70
            CTextField{
                id:setTextBox
                x:120
                y:20
                defaultText:"****"
                activeText:"****"
                echomode:2
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
                    inputPassword=""
                }
                Component.onCompleted:{
                    setTextBox.sigActiveFocus()
                }
            }
        }
        Cnumberpad{
            onSigClickNumber: {

                if(_numText==="enter-868482"){
                    sigDoneClickInstallerSetting(inputPassword)
                }
                else if(_numText==="backspace-868482"){
                    inputPassword=setUsage.slice(0, -1)
                }
                else{
                    inputPassword=password+_numText
                }
                setTextBox.textFieldText=inputPassword
            }
        }
    }

    PopupToast{
        id:popuptoastComponent
        visible:false
        state:"1line"
        textstring:qsTr("Password is incorrect")
        onSigFadeDone: {
            popuptoastComponent.visible=false
        }
    }
    //setting에서 global로 받아온 passwd
    property string password:Variables.password

    function passwdIncorrect(){
        popuptoastComponent.visible=true
        popuptoastComponent.sigFadeStart()
    }

    function passwdCorrect(){

    }
    onSigDoneClickInstallerSetting: {
        //inf로 passwd보내기
        if(password===inputPassword){
            passwdCorrect()
        }
        else if(password!==inputPassword){
            passwdIncorrect()
        }
    }
}
