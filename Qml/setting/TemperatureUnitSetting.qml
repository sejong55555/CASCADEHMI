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
            left_1st_Text: qsTr("Temperature Unit Setting")
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
                    textOpacity:model.Textopacity
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

    property bool isCelsius: true
    property string unitTempSuffix
    property string unitTempText
    property real minimumUnitC:0.5
    property real minimumUnitF:1

    onSigReadTempSetting: {

        if(isCelsius){
            unitTempSuffix="°C"
            unitTempText="Celsius"
            listmodel.get(1).subText=minimumUnitC+" "+unitTempSuffix
            listmodel.get(1).Textopacity = 1
        }
        else if(!isCelsius) {
            unitTempSuffix="°F"
            unitTempText="Fahrenheit"

            listmodel.get(1).subText=minimumUnitF+" "+unitTempSuffix
            listmodel.get(1).Textopacity = 0.3
        }
        listmodel.get(0).subText=unitTempText
    }

    Component.onCompleted: {
        sigReadTempSetting()
    }

    PopupList{
        id:tempUnitPopup
        visible:false
        scrollviewmodel:tempmodel
        scrollbarEnable:false
        shadowV:0
        shadowH:4
        onSigClickDelegate: {
            //inf로 setting 값 변경 신호 보내야함
            if(sendData==0){
                isCelsius=true
            }
            else if(sendData==1){
                isCelsius=false
            }
            isCelsius ? appModel.setTemperatureUnit("true"):appModel.setTemperatureUnit("false")
            unitTempText = scrollviewmodel.get(sendData).listName//나중에 삭제
            sigReadTempSetting()
        }

        Component.onCompleted: {
            // console.log(""+tempUnitPopup.selectedDelegateColor)
            for(var i=0; i < tempUnitPopup.scrollviewmodel.count; i++){
                if(tempUnitPopup.scrollviewmodel.get(i).listName===unitTempText){
                    tempUnitPopup.sigSelectedDelegate(i)
                }
            }
        }
    }

    ListModel{
        id:listmodel
        ListElement{listName:"Celsius/Fahrenheit";statename:"B";subText:"";Textopacity:1}
        ListElement{listName:"Minimum Unit";statename:"B";subText:"";Textopacity:1}
    }

}
