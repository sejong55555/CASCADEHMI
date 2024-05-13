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
                        sigReadFlagSetting()
                        switch(index){
                        case 1 : {
                            console.log(silentFlag)
                            titleToggleInit(silentFlag);

                            break;}
                        case 2 : {
                            console.log(boilerFlag)
                            titleToggleInit(boilerFlag);
                            break;}
                       }
                    }
                    onSigtoggleOn: {
                        //inf에 setting 변경 신호 보내기
                        if(index===0){
                            //silent
                            silentFlag=true //flag는 inf에서 읽어와서 사용할 것이라서 나중에 지우기
                        }
                        else if(index===1){
                            boilerFlag=true
                            //boiler
                        }
                    }
                    onSigtoggleOff: {
                        if(index===0){
                            silentFlag=false
                        }
                        else if(index===1){
                            boilerFlag=true
                        }
                    }
            }
        }
    }
    WaterTempSetting{
        id:waterTempSetting
        visible:false
    }

    property bool silentFlag
    property bool boilerFlag

    ListModel{
        id:listmodel
        ListElement{listName:qsTr("물 온도 설정");statename:"B";subText:""}
        ListElement{listName:qsTr("Silent Mode");statename:"C";subText:""}
        ListElement{listName:qsTr("Third Party Boiler");statename:"C";subText:""}
    }

    onSigReadFlagSetting: {
        //setting 값 불러와서 설정
        silentFlag=true
        boilerFlag=false
    }
    Component.onCompleted: {
        sigReadFlagSetting()
    }
}
