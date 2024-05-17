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

    property bool isCoolingPopup: true
    property real coolTemp:10
    property real heatTemp:32
    property bool isCelsius:true
    property string unitTempSuffix:""

    signal sigReadWaterTemp()

    Column{
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        TitleBar{
            id:title
            left_1st_Text: qsTr("물 온도 설정")
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
                    rightItemtextField:model.subText + unitTempSuffix
                    state:model.statename
                    onSigClick: {
                        switch(index){
                        case 0:{
                            isCoolingPopup=true
                            Variables.modelrangeSet(Variables.coolingWatermin,Variables.coolingWatermax,popupmodel)
                            waterTempPopup.scrollviewmodel=popupmodel
                            waterTempPopup.sigSelectedDelegate(coolTemp-Variables.coolingWatermin)
                            break;
                        }
                        case 1:{
                            isCoolingPopup=false
                            Variables.modelrangeSet(Variables.heatingWatermin,Variables.heatingWatermax,popupmodel)
                            waterTempPopup.scrollviewmodel=popupmodel
                            waterTempPopup.sigSelectedDelegate(heatTemp-Variables.heatingWatermin)
                            break;
                        }
                        }
                        waterTempPopup.visible=true
                    }
            }
        }
    }

    ListModel{
        id:listmodel
        ListElement{listName:qsTr("냉방 물 온도");statename:"B";subText:""}
        ListElement{listName:qsTr("난방 물 온도");statename:"B";subText:""}
    }

    ListModel{
        id:popupmodel
    }

    PopupList{
        id:waterTempPopup
        visible:false
        headerText:qsTr("Setting Temp")
        suffix:"°"
        shadowV:0
        shadowH:4
        scrollviewmodel:popupmodel
        onSigClickDelegate: {
            if(isCoolingPopup===true){
                coolTemp=Number(sendData)+Variables.coolingWatermin
                appModel.setCoolWaterTemperature(coolTemp.toString())
                listmodel.get(0).subText = coolTemp.toString()
            }
            else if(isCoolingPopup===false){
                heatTemp=Number(sendData)+Variables.heatingWatermin
                appModel.setHotWaterTemperature(heatTemp.toString())
                listmodel.get(1).subText = heatTemp.toString()
            }
            sigReadWaterTemp()
        }
    }

    onSigReadWaterTemp:{
        if(isCelsius){
            unitTempSuffix="°C"
        }
        else {
            unitTempSuffix="°F"
        }

        listmodel.get(0).subText=appModel.getCoolWaterTemperature()
        listmodel.get(1).subText=appModel.getHotWaterTemperature()

        coolTemp = parseFloat(appModel.getCoolWaterTemperature())
        heatTemp = parseFloat(appModel.getHotWaterTemperature())
    }

    Component.onCompleted: {
        sigReadWaterTemp()
    }
}
