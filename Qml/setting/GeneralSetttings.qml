import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"


Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"


    property string popuptoastText

    property string prefix: " ̊"

    signal sigReadSettingDefault()

    Column{
        TitleBar{
            id:title
            left_1st_Text:qsTr("General Settings")
            onSigLClickTitleBar: {
                root.visible=false
            }
        }
        ListView{
            id:view
            width:Variables.sourceWidth
            height:Variables.sourceHeight-title.height
            model:listmodel
            delegate:List{
                    left_1st_Text:model.listName
                    rightItemtextField:model.subText
                    state:model.statename
                    onSigClick: {
                        switch(index){
                        case 0:{
                            langPopup.visible=true;
                            break;
                        }

                        case 1:{
                            temperatureUnitSetting.sigReadTempSetting();
                            temperatureUnitSetting.visible=true;
                            break;
                        }
                        case 2:{
                            dateAndTime.visible=true;
                            break;
                        }

                        case 3:{
                            screenSaver.sigReadScreenSetting();
                            screenSaver.visible=true;
                            break;
                        }
                        case 4:{
                            // lock.sigReadLockSetting();
                            lock.visible=true;
                            break;
                        }
                        case 5:{
                            wifiparing.visible=true;
                            break;
                        }
                        case 6:{
                            //to do reboot 신호 보내야함
                            changeLang.textBoxText=qsTr("Rebooting…")
                            rebootConfirmBg.visible=true
                            break;
                        }
                        }
                    }
                }
            clip:true
            }
        }

    RemoteWifiParing{
        id:wifiparing
        visible:false
    }

    Rectangle{
        id:rebootConfirmBg
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        color:"#26000000"
        MouseArea{anchors.fill:parent}
        PopupLine{
            id:rebootConfirm
            x:20;y:68
            state:"1line"
            opacity:1
            textBox:qsTr("Are you sure you want to reboot?")
            firstbtnText:qsTr("Cancel")
            secondbtnText:qsTr("Reboot")
            onSigLClick: {
                rebootConfirmBg.visible= false
            }
            onSigRClick: {
                rebootConfirmBg.visible=false
                changeLang.visible=true
                changeLang.initStart()
            }
        }
    }

    ListModel{
        id:listmodel
            ListElement{listName:qsTr("Language");statename:"B";subText:""}
            ListElement{listName:qsTr("Temperature Unit");statename:"B";subText:""}
            ListElement{listName:qsTr("Date & Time");statename:"B";subText:""}
            ListElement{listName:qsTr("Screen Saver");statename:"A";subText:""}
            ListElement{listName:qsTr("Lock");statename:"B";subText:""}
            ListElement{listName:qsTr("Wi-Fi Pairing");statename:"B";subText:""}
            ListElement{listName:qsTr("System Reboot");statename:"A";subText:""}
    }

    //lock상태 불러와서 사용
    property bool onOffLock:true
    property int languageOpt:1
    property bool isCelsius:true
    property bool wifiPairing:true

    onSigReadSettingDefault:{//read default setting
        // var forsubText=[languageOpt,isCelsius,Variables.globalDateExpandString,"",onOffLock,Variables.wifipairing,""]

        for(var i=0; i<listmodel.count;i++){
            switch(i){
            case 0 :{
                listmodel.get(i).subText=langmodel.get(languageOpt).listName
                break;
            }
            case 1:{
                if(isCelsius){
                    listmodel.get(i).subText = prefix+"C"
                }
                else{
                    listmodel.get(i).subText = prefix+"F"
                }
                break;
            }
            case 2:{
                listmodel.get(i).subText = Variables.globalDateExpandString
                break;
            }

            case 4:{
                if(onOffLock){ listmodel.get(i).subText = "ON"}
                else{ listmodel.get(i).subText = "OFF"}
                break;
            }

            case 5:{
                if(wifiPairing){ listmodel.get(i).subText = "Connected"}
                else{ listmodel.get(i).subText = "OFF"}
                break;
            }

            }
        }
    }

    ScreenSaver{
        id:screenSaver
        visible:false
    }

    TemperatureUnitSetting{
        id:temperatureUnitSetting
        visible:false
    }

    Lock{
        id:lock
        visible:false
    }

    DateAndTime{
        id:dateAndTime
        visible:false
    }

    PopupList{
        id:langPopup
        visible:false
        scrollviewmodel:langmodel
        scrollbarEnable:false
        shadowV:0
        shadowH:4

        onSigClickDelegate: {
            changeLang.textBoxText=qsTr("Changing language...")
            changeLang.visible=true
            changeLang.initStart()
            listmodel.get(0).subText=scrollviewmodel.get(sendData).listName
            console.log("Selected Language : "+scrollviewmodel.get(sendData).listName)
            // Variables.language=scrollviewmodel.get(sendData).listName

            //todo inf에 변경 신호 보내기
            languageOpt=sendData
        }

        Component.onCompleted: {
            for(var i=0; i < langPopup.scrollviewmodel.count; i++){
                if(langPopup.scrollviewmodel.get(i).listName===langmodel.get(languageOpt).listName){
                    langPopup.sigSelectedDelegate(i)
                }
            }
            listviewSizeFit()
            //*to do focus된 언어 선택되게 나옴
        }
    }

    SettingInitialize{
        id:changeLang
        visible:false
        onSigInitDone: {
            changeLang.visible=false
        }
    }

    ListModel{
        id:langmodel
        ListElement{listName:"English"}
        ListElement{listName:"Español"}
        ListElement{listName:"Français"}
        ListElement{listName:"한국어"}
    }

    ListModel{
        id:tempmodel
        ListElement{listName:qsTr("Celsius")}
        ListElement{listName:qsTr("Fahrenheit")}
    }
}
