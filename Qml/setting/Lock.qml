import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"

Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    property bool dimFlag:false

    signal sigReadLockSetting()

    Column{
        TitleBar{
            id:title
            left_1st_Text: qsTr("Lock")
            onSigLClickTitleBar: {
                sigReadSettingDefault()
                root.visible=false
            }
        }
        List{
            id:alllock
            left_1st_Text: qsTr("All Lock")
            state:"C"
            imagename:"on"
            Component.onCompleted: {
                titleToggleInit(false)
            }
            onSigtoggleOff:{
                Variables.opacityInit(listmodel,1)
                for(var i=0;i<listmodel.count;i++){
                    listmodel.get(i).Imagestate="n"
                }

            }
            onSigtoggleOn:{
                Variables.opacityInit(listmodel,0.3)
                for(var i=0;i<listmodel.count;i++){
                    listmodel.get(i).Imagestate="d"
                }
            }
        }
        ListView{
            id:view
            width:Variables.sourceWidth
            height:Variables.sourceHeight-title.height-alllock.height
            model:listmodel
            delegate:List{
                    left_1st_Text:model.listName
                    state:"C"
                    expand1: true
                    imagestate:model.Imagestate
                    imagename:model.Imagename
                    textOpacity: model.Textopacity
                    onImagestateChanged:{
                        toggleDim(imagestate)
                    }
                    // onImagenameChanged: {
                    //     var toggleTemp=imagename==="on"?true:false
                    //     titleToggleInit(toggleTemp)
                    // }

                    Component.onCompleted: {
                        sigReadLockSetting()
                        switch(index){
                        case 0 : {
                            console.log(onOffLock)
                            titleToggleInit(onOffLock);
                            break;
                        }
                        case 1 : {
                            titleToggleInit(modeLock);
                            break;
                        }
                        case 2 : {
                            titleToggleInit(dhwLock);
                            break;
                        }
                        }
                    }
                    onSigtoggleOn: {
                        //각 lock mode토글시 inf에 변경 신호 보내기
                        switch(index){
                        case 0:{
                            onOffLock=true//flag는 inf에서 읽어와서 사용할 것이라서 나중에 지우기
                            console.log("on")
                            break;
                        }
                        case 1:{
                            modeLock=true
                            break;
                        }
                        case 2:{
                            dhwLock=true
                            break;
                        }
                        }
                    }
                    onSigtoggleOff: {
                        switch(index){
                        case 0:{
                            console.log("off")
                            onOffLock=true
                            break;
                        }
                        case 1:{
                            modeLock=true
                            break;
                        }
                        case 2:{
                            dhwLock=true
                            break;
                        }
                        }
                    }
            }
        }
    }

    property bool onOffLock: true
    property bool modeLock: true
    property bool dhwLock: false

    Component.onCompleted: {
        //todo lock 모드 읽어와서 설정
        sigReadLockSetting()
        // var tempText = Variables.onOffLock===true?"on":"off"
        // listmodel.get(0).Imagename = onOffLock===true? "on":"off"
        // listmodel.get(1).Imagename = modeLock===true? "on":"off"
        // listmodel.get(2).Imagename = dhwLock===true? "on":"off"
    }

    onSigReadLockSetting: {
        listmodel.get(0).Imagename = onOffLock===true? "on":"off"
        listmodel.get(1).Imagename = modeLock===true? "on":"off"
        listmodel.get(2).Imagename = dhwLock===true? "on":"off"
        //lock 상태 읽어와서 Imagestate에 넣어야함
    }

    ListModel{
        id:listmodel
        ListElement{listName:qsTr("ON/OFF Lock");Textopacity:1;Imagestate:"n";Imagename:"done"}
        ListElement{listName:qsTr("Mode Lock");Textopacity:1;Imagestate:"n";Imagename:"done"}
        ListElement{listName:qsTr("DHW Lock");Textopacity:1;Imagestate:"n";Imagename:"done"}
    }


}
