import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"

Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    signal sigReadTempSetting()

    Column{
        TitleBar{
            id:title
            left_1st_Text: "Temperature Unit Setting"
            onSigLClickTitleBar: {
                sigReadSettingDefault()
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
                            tempUnitPopup.visible=true
                            break;
                        }
                        }
                    }

            }
        }
    }

    onSigReadTempSetting: {

        listmodel.get(0).subText=Variables.tempUnit
        listmodel.get(1).subText=Variables.tempUnit==="Celsius"?Variables.minimumUnit+" "+suffix+"C":Variables.minimumUnit+" "+suffix+"F"
    }

    PopupList{
        id:tempUnitPopup
        visible:false
        scrollviewmodel:tempmodel
        scrollbarEnable:false
        shadowV:0
        shadowH:4
        onSigClickDelegate: {
            listmodel.get(0).subText= scrollviewmodel.get(sendData).listName
            console.log("Selected Temperature Unit : "+scrollviewmodel.get(sendData).listName)
            Variables.tempUnit=scrollviewmodel.get(sendData).listName
            sigReadTempSetting()
        }

        Component.onCompleted: {
            console.log(tempUnitPopup.selectedDelegateColor)
            for(var i=0; i < tempUnitPopup.scrollviewmodel.count; i++){
                if(tempUnitPopup.scrollviewmodel.get(i).listName===Variables.tempUnit){
                    tempUnitPopup.sigSelectedDelegate(i)
                }
            }
        }
    }

    ListModel{
        id:listmodel
        ListElement{listName:"Celsius/Fahrenheit";statename:"B";subText:""}
        ListElement{listName:"Minimum Unit";statename:"B";subText:""}
    }

}
