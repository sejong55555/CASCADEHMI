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
                        }
                    }
                    onImagenameChanged: {
                        var toggleTemp=imagename==="on"?true:false
                        titleToggleInit(toggleTemp)
                    }
                    onSigtoggleOn: {//*to do inf신호 보내고 variable변경 함수 호출+onSigReadScreenSetting
                        console.log("ON")
                    }
                    onSigtoggleOff: {
                        console.log("OFF")
                    }
                }
            clip:true
        }
    }

    onSigReadScreenSetting: {
            listmodel.get(0).subText=Variables.screensaverTime+" s"
            listmodel.get(1).subText=Variables.lcdIdle===true?"ON":"OFF"
            listmodel.get(2).Imagename=Variables.autoReturnMainScreen===true?"on":"off"
    }

    ListModel{
        id:listmodel
        ListElement{listName:"Screen Saver Timer";statename:"B";subText:"";Imagename:"done"}
        ListElement{listName:"LCD Brightness In Idle";statename:"B";subText:"";Imagename:"done"}
        ListElement{listName:"Auto Return to Main Screen";statename:"C";subText:"";Imagename:"done"}
    }

}
