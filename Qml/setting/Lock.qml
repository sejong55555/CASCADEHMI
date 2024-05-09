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
            left_1st_Text: "Lock"
            onSigLClickTitleBar: {
                sigReadSettingDefault()
                root.visible=false
            }
        }
        List{
            id:alllock
            left_1st_Text: "All Lock"
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
                    onImagenameChanged: {
                        var toggleTemp=imagename==="on"?true:false
                        titleToggleInit(toggleTemp)
                    }
                    onSigtoggleOn: {//각 lock mode토글시 inf에 신호를 보내고variable변경 함수 호출+onSigReadLockSetting())
                        switch(index){
                        case 0:{
                            console.log("on")
                            break;
                        }
                        case 1:{
                            break;
                        }
                        case 2:{
                            break;
                        }
                        }
                    }
                    onSigtoggleOff: {
                        switch(index){
                        case 0:{
                            console.log("off")
                            break;
                        }
                        case 1:{
                            break;
                        }
                        case 2:{
                            break;
                        }
                        }
                    }
            }
        }
    }

    Component.onCompleted: {

        var tempText=Variables.onOffLock===true?"on":"off"
        listmodel.get(0).Imagename=Variables.onOffLock===true?"on":"off"
        listmodel.get(1).Imagename=Variables.modeLock===true?"on":"off"
        listmodel.get(2).Imagename=Variables.dhwLock===true?"on":"off"
    }

    onSigReadLockSetting: {
        listmodel.get(0).Imagename=Variables.onOffLock===true?"on":"off"
        listmodel.get(1).Imagename=Variables.modeLock===true?"on":"off"
        listmodel.get(2).Imagename=Variables.dhwLock===true?"on":"off"
        //lock 상태 읽어와서 Imagestate에 넣어야함
    }

    ListModel{
        id:listmodel
        ListElement{listName:"ON/OFF Lock";Textopacity:1;Imagestate:"n";Imagename:"done"}
        ListElement{listName:"Mode Lock";Textopacity:1;Imagestate:"n";Imagename:"done"}
        ListElement{listName:"DHW Lock";Textopacity:1;Imagestate:"n";Imagename:"done"}
    }


}
