import QtQuick 2.7
import QtQuick 2.10
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    signal sigReadFlagSetting()

    property bool silentFlag
    property bool boilerFlag

    Column{
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        TitleBar{
            id:title
            left_1st_Text: qsTr("Function")
            onSigLClickTitleBar: {
                Variables.content="Home"
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
                            waterTempSetting.visible=true
                            break;
                        }
                        }
                    }
                    Component.onCompleted: {
                        switch(index){
                        case 1 : {
                            if(appModel.getSilentMode() ==="true")
                                silentFlag =true
                            else
                                silentFlag =false
                            titleToggleInit(silentFlag);
                            break;}
                        case 2 : {
                            if(appModel.getThirdPartyBoilerMode() ==="true")
                                boilerFlag =true
                            else
                                boilerFlag =false
                            titleToggleInit(boilerFlag);
                            break;}
                       }
                    }
                    onSigtoggleOn: {
                        if(index===1){
                            silentFlag=true
                            appModel.setSilentMode("true")
                        }
                        else if(index===2){
                            boilerFlag=true                            
                            appModel.setThirdPartyBoilerMode("true")
                        }
                    }
                    onSigtoggleOff: {
                        if(index===1){
                            silentFlag=false
                            appModel.setSilentMode("false")
                        }
                        else if(index===2){
                            boilerFlag=false
                            appModel.setThirdPartyBoilerMode("false")
                        }
                    }
            }
        }
    }
    WaterTempSetting{
        id:waterTempSetting
        visible:false
    }    

    ListModel{
        id:listmodel
        ListElement{listName:qsTr("물 온도 설정");statename:"B";subText:""}
        ListElement{listName:qsTr("Silent Mode");statename:"C";subText:""}
        ListElement{listName:qsTr("Third Party Boiler");statename:"C";subText:""}
    }

    onSigReadFlagSetting: {
    }

    Component.onCompleted: {
    }
}
