import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"
Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    property string opertitleText: "Circuit"
    property bool circuitToggleFlag: true

    property string setfstText:"Cool"
    property string setsndText:"18"
    property string suffix

    property var themodel: circuitmodel

    signal sigBackClickOperating(string _sendrunnigmode,string _sendtemperature)
    signal sigBackClickOperatinghot(string _sendtemperature)
    signal sigSetDefaultData(string _getrunnigmode,string _gettemperature)
    signal sigModelchange(string _selectediconSource)

    // MouseArea{anchors.fill:parent}
    Column{
            anchors.fill:parent
            TitleBar{
                id:titleBar
                left_1st_Text:"Operation Settings"
                onSigLClickTitleBar: {
                    if(circuitToggleFlag===true){
                        if(themodel===hotwatermodel){
                            sigBackClickOperatinghot(setfstText)
                        }
                        else{
                            sigBackClickOperating(setfstText,setsndText)
                        }
                    }

                    else if(circuitToggleFlag===false){
                        if(themodel===hotwatermodel){
                            sigBackClickOperatinghot("")
                        }
                        else{
                            sigBackClickOperating("","")
                        }
                    }
                }
            }

            List{
                id:circuitActoption
                left_1st_Text:opertitleText
                state:"C"
                imagename:"on"
                onSigtoggleOff: {
                    circuitToggleFlag=false
                    opacityInit(themodel,0.3)
                    // for(var i=0;i < themodel.count;i++){
                    //     themodel.get(i).Textopacity=0.3
                    // }
                }
                onSigtoggleOn: {
                    circuitToggleFlag=true
                    opacityInit(themodel,1)
                    // for(var i=0;i < themodel.count;i++){
                    //     themodel.get(i).Textopacity=1
                    // }
                }
            }

            ListView{
                id:subexpandlist
                width:root.width
                height:root.height-titleBar.height
                clip:true
                z:-1
                model:themodel
                delegate:List{
                    id:listdelegate
                    left_1st_Text:listtitle
                    rightItemtextField:index===0?setfstText+suffix:index===1?setsndText+tempscroll.suffix:""
                    state:"B"
                    expand1:true
                    textOpacity:Textopacity
                    rightTextBoxClip:false

                    onSigClick:{
                        switch(index){
                            case 0:{
                                if(themodel===circuitmodel){
                                    runningmodescroll.visible=true
                                }
                                else if(themodel===hotwatermodel){
                                    tempscroll2.visible=true
                                }
                                //runmode listview visble
                                break;

                            }
                            case 1:{
                                tempscroll.visible=true
                                //runmode listview visble
                                break;
                            }

                        }
                    }
                    Component.onCompleted: {
                        if(index===0){
                        }
                        else if(index===1){
                        }
                        else if(index===2){
                            leftcolW=220
                            rightTextBoxW=126
                        }
                    }
                }
            }
        }

    PopupList{
        id:runningmodescroll
        visible:false
//        scrollviewmodel:runningmodel
        delegateTextBoxH:21
        headerText:"running mode"
        onSigClickDelegate: {
            setfstText=scrollviewmodel.get(sendData).listName

            if(setfstText==="Cool"){
                tempscroll.scrollviewmodel=coolmodel
                setsndText=tempscroll.scrollviewmodel.get(0).listName
                themodel.get(1).Textopacity=1
                console.log(setsndText)
            }
            else if(setfstText==="Heat"){
                tempscroll.scrollviewmodel=heatmodel
                setsndText=tempscroll.scrollviewmodel.get(0).listName
                themodel.get(1).Textopacity=1
            }
            else if(setfstText==="Auto"){
                tempscroll.scrollviewmodel=emptymodel
                themodel.get(1).Textopacity=0.3
            }
            visible=false
        }
    }

    PopupList{
        id:tempscroll
        visible:false
        headerText:"Setting Temp"
        suffix: setsndText===""?"":" ̊"
        scrollviewmodel:setfstText==="Cool"?coolmodel:setfstText==="Heat"?heatmodel:hotmodel
        onSigClickDelegate: {
            setsndText=scrollviewmodel.get(sendData).listName
            visible=false
        }
    }

    PopupList{
        id:tempscroll2
        visible:false
        headerText:"Setting Temp"
        suffix:" ̊"
        scrollviewmodel:hotmodel
        onSigClickDelegate: {
            setfstText=scrollviewmodel.get(sendData).listName
            visible=false
        }
    }

    ListModel{
        id:circuitmodel
        ListElement{listtitle:"Running Mode";Textopacity:1}
        ListElement{listtitle:"Temperature";Textopacity:1}
    }

    ListModel{
        id:hotwatermodel
        ListElement{listtitle:"Temperature";Textopacity:1}
    }

    ListModel{
        id:runningmodel
        ListElement{listName:"Cool"}
        ListElement{listName:"Heat"}
        ListElement{listName:"Auto"}
    }

    ListModel{
        id:coolmodel
    }
    ListModel{
        id:heatmodel
    }
    ListModel{
        id:hotmodel
    }

    onSigSetDefaultData:{
        if(themodel===hotwatermodel){
            setfstText=_gettemperature
            suffix=" ̊"
        }
        else{
            setfstText=_getrunnigmode
            setsndText=_gettemperature
        }
    }

    onSigModelchange:{
        if(_selectediconSource==="circuit_hotwater"){
            themodel=hotwatermodel
        }
        else{
            themodel=circuitmodel
        }
    }

    Component.onCompleted: {
        runningmodescroll.scrollviewmodel=runningmodel
        Variables.modelrangeSet(Variables.coolmin,Variables.coolmax,coolmodel)
        Variables.modelrangeSet(Variables.heatmin,Variables.heatmax,heatmodel)
        Variables.modelrangeSet(Variables.automin,Variables.automax,hotmodel)
    }

    function sethotwaterOper(_temp){
        setfstText=_temp
    }

    function initaddOperationSetting(){
        setfstText="Cool"
        setsndText="18"
        circuitToggleFlag=true
        circuitActoption.titleToggleInit(true)
        opacityInit(themodel,1)
    }

    function initeditOperationSetting(){
        circuitToggleFlag=true
        circuitActoption.titleToggleInit(true)
        opacityInit(themodel,1)
    }


}

