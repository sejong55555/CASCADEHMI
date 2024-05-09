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

    property string suffix: " ̊"

    signal sigReadSettingDefault()

    Column{
        TitleBar{
            id:title
            left_1st_Text:"General Settings"
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
                        }
                    }
                }
            clip:true
            }
        }

    ListModel{
        id:listmodel
            ListElement{listName:"Language";statename:"B";subText:""}
            ListElement{listName:"Temperature Unit";statename:"B";subText:""}
            ListElement{listName:"Date & Time";statename:"B";subText:""}
            ListElement{listName:"Screen Saver";statename:"A";subText:""}
            ListElement{listName:"Lock";statename:"B";subText:""}
            ListElement{listName:"Wi-Fi Pairing";statename:"B";subText:""}
            ListElement{listName:"System Reboot";statename:"A";subText:""}
    }


    onSigReadSettingDefault:{//read default setting
        var forsubText=[Variables.language,Variables.tempUnit,Variables.globalDateExpandString,"",Variables.lockmode,Variables.wifipairing,""]
        for(var i=0; i<listmodel.count;i++){
            if(typeof(forsubText[i])==="boolean"){
                if(forsubText[i]===true){
                    listmodel.get(i).subText="ON"
                }
                else{
                    listmodel.get(i).subText="OFF"
                }
            }

            else{
                if(i===1){
                    listmodel.get(i).subText=forsubText[i]==="Celsius"?suffix+"C":suffix+"F"
                }
                else{
                    listmodel.get(i).subText=forsubText[i]
                }
            }
            // listmodel.get(i).subText
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
            changeLang.visible=true
            changeLang.initStart()
            listmodel.get(0).subText=scrollviewmodel.get(sendData).listName
            console.log("Selected Language : "+scrollviewmodel.get(sendData).listName)
            Variables.language=scrollviewmodel.get(sendData).listName
        }

        Component.onCompleted: {
            console.log(langPopup.selectedDelegateColor)
            for(var i=0; i < langPopup.scrollviewmodel.count; i++){
                if(langPopup.scrollviewmodel.get(i).listName===Variables.language){
                    langPopup.sigSelectedDelegate(i)
                }
            }
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
        ListElement{listName:"Celsius"}
        ListElement{listName:"Fahrenheit"}
    }
}
