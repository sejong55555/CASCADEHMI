import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"

Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    signal sigReadScreenSetting()

    Column{
        TitleBar{
            id:title
            left_1st_Text: "Screen Saver"
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
                    imagename:model.Imagename
                    onSigClick: {
                        switch(index){
                            case 0:{
                                popuplist.scrollbarEnable=false
                                popuplist.isSaver=true
                                popuplist.headerText="Screen Saver Timer"
                                popuplist.scrollviewmodel=saverTimermodel
                                popuplist.sigSelectedDelegate(screensaverTime)
                                break;
                            }
                            case 1:{
                                popuplist.scrollbarEnable=true
                                popuplist.isSaver=false
                                popuplist.headerText="LCD Brightness in Idle"
                                popuplist.scrollviewmodel=lcdBrightnessmodel
                                popuplist.sigSelectedDelegate(lcdIdle)
                                break;
                            }
                        }
                        popuplist.visible=true
                    }
                    onImagenameChanged: {
                        var toggleTemp=imagename==="on"?true:false

                        titleToggleInit(toggleTemp)

                    }
                    onSigtoggleOn: {//*to do inf신호 보내고 variable변경 함수 호출+onSigReadScreenSetting
                        autoReturnMainScreen=true//나중엔 읽어와서 사용
                        appModel.setAutoRetrunMainScreen("true")
                        console.log("ON")
                    }
                    onSigtoggleOff: {
                        autoReturnMainScreen=false//나중엔 읽어와서 사용
                        appModel.setAutoRetrunMainScreen("false")
                        console.log("OFF")
                    }
                }
            clip:true
        }
    }

    PopupList{
        id:popuplist
        property bool isSaver:true
        visible:false
        scrollviewmodel:saverTimermodel
        scrollbarEnable:false
        shadowV:0
        shadowH:4
        onSigClickDelegate: {
            //inf로 setting 값 변경 신호 보내야함
            if(isSaver===true){
                screensaverTime=sendData
            }
            else if(isSaver===false){
                lcdIdle=sendData
            }
            sigReadScreenSetting()
        }

        Component.onCompleted: {
            listviewSizeFit()
        }
    }

    property int screensaverTime :0
    property int lcdIdle :0
    property bool autoReturnMainScreen : false

    onSigReadScreenSetting: {
        listmodel.get(0).subText=saverTimermodel.get(screensaverTime).listName
        listmodel.get(1).subText=lcdBrightnessmodel.get(lcdIdle).listName

        if(autoReturnMainScreen){
            listmodel.get(2).Imagename="on"
        }
        else if(!autoReturnMainScreen){
            listmodel.get(2).Imagename="off"
        }
        appModel.setScreenSaveTime(listmodel.get(0).subText)
        appModel.setLCDBacklightIdle(listmodel.get(1).subText)

    }

    ListModel{
        id:listmodel
        ListElement{listName:qsTr("Screen Saver Timer");statename:"B";subText:"";Imagename:"done"}
        ListElement{listName:qsTr("LCD Brightness In Idle");statename:"B";subText:"";Imagename:"done"}
        ListElement{listName:qsTr("Auto Return to Main Screen");statename:"C";subText:"";Imagename:"done"}
    }

    ListModel{
        id:saverTimermodel
        ListElement{listName:"15s"}
        ListElement{listName:"30s"}
        ListElement{listName:"1m"}
        ListElement{listName:"OFF"}
    }

    ListModel{
        id:lcdBrightnessmodel
        ListElement{listName:"OFF"}
        ListElement{listName:"25%"}
        ListElement{listName:"50%"}
        ListElement{listName:"70%"}
        ListElement{listName:"100%"}
    }

}
