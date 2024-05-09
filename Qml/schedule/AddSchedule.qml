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

    property string hourText:""
    property string minText: ""
    property string ampmText: ""

    property string startYear: ""
    property string startMonth: ""
    property string startDate: ""

    property string endYear: ""
    property string endMonth: ""
    property string endDate: ""

    property string timeText:hourText===""?"":hourText+":"+minText+" "+ampmText
    property string repeatText
    property string runnigmodeText:"Cool"
    property string temperatureText:"18"

    property string tempDegree: " ̊"

    signal sigDoneClickAdd()
    signal sigBackClickAdd()

    Column{
        anchors.fill:parent
        TitleBar{
            id:titleBar
            left_1st_Text:"Add Schedule"
            onSigLClickTitleBar: {
                sigBackClickAdd()
            }
        }
        ListView{
            width:root.width
            height:root.height-titleBar.height
            z:-1
            clip:true
            model:themodel
            delegate:List{
                id:listdelegate
                left_1st_Text:qsTr(listtitle)
                rightItemtextField:index===0?timeText:index===1?qsTr(repeatText):qsTr(runnigmodeText)
                state:"B"
                rightTextBoxClip:false

                Row{
                    id:operationmold
                    leftPadding: 420;topPadding:27
                    visible:index===2?true:false
                    spacing:10
                    Rectangle{
                        id:operationmidline
                        visible:tempDegree===""?false:true
                        anchors.verticalCenter: parent.verticalCenter
                        width:1;height:16
                        color:"#979797"
                    }
                    Text{
                        id:operationTextBox
                        anchors.verticalCenter: parent.verticalCenter
                        width: 22;height:width
                        text:temperatureText+tempDegree
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color:"#555555"
                        font.pixelSize: 18
                    }
                }
                onSigClick:{
                    switch(index){
                        case 0:{
                            timeOption.visible=true;
                            break;
                        }
                        case 1:{
                            repeatOption.visible=true;
                            break;
                        }
                        case 2:{
                            operatingOption.visible=true;
                            break;
                        }
                    }
                }
                Component.onCompleted: {
                    if(index===0){
                        listdelegate.timeText
                    }
                    else if(index===1){
                    }
                    else if(index===2){
                        rightTextBoxW=150
                    }
                }
            }
        }
    }

    TitleBarButton{
        id:doneButton
        width:56;height:30
        x:414;y:11
        imagename:"done"
        onSigClick: {
            sigDoneClickAdd()
            //schedulemodel에 data추가? engine에만? engine에도 보내서 db저장 끝
        }
    }
    Rectangle{
        id:timeOption
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        color:"#26000000"
        visible:false
        MouseArea{anchors.fill:parent;}
        PopupPicker{
            textfieldText:"Time"
            anchors.centerIn: parent
            midline:false
            state:"triple"
            firstmodel:12
            secondmodel:60
            thirdmodel:ampmmodel

            onSigCancelClick: {
                timeOption.visible=false
            }
            onSigOkClick: {

                timeOption.visible=false

                var temphourText
                var tempminText

                // if(_firstText.toString().length<2){
                //     temphourText="0"+_firstText.toString()
                //     hourText=temphourText
                // }

                // else if(_firstText.toString().length>=2){
                //     temphourText=_firstText.toString()
                //     hourText=temphourText
                // }
                if(_secondText.toString().length<2){
                    tempminText="0"+_secondText.toString()
                    minText=tempminText
                }

                else if(_secondText.toString().length>=2){
                    tempminText=_secondText.toString()
                    minText=tempminText
                }
                hourText=_firstText.toString()/*.padStart(2, '0')*/
                // minText=_secondText.toString().padStart(2, '0')
                ampmText=ampmmodel.get(_thirdText).index
            }
        }
    }

    //operationComponent{}
    RepeatSchedule{
        id:repeatOption
        visible:false
        onSigBackClickRepeatSchedule:{
            visible=false
            // repeatText=""

            repeatText=getRepeatText(repeatOption._dayOfWeek)

            startYear=_startDateList["year"]
            startMonth=_startDateList["month"]
            startDate=_startDateList["date"]

            endYear=_endDateList["year"]
            endMonth=_endDateList["month"]
            endDate=_endDateList["date"]
        }
    }

    ScheduleOperating{
        id:operatingOption
        visible:false
        onSigBackClickOperating:{

            runnigmodeText=_sendrunnigmode
            temperatureText=_sendtemperature
            // console.log(runnigmodeText+"::"+temperatureText)
            if(runnigmodeText===""||temperatureText===""){
                tempDegree=""
                if(runnigmodeText===""&&temperatureText===""){
                    runnigmodeText="Off"
                }
            }

            else{
                tempDegree=" ̊"
            }
            visible=false
        }
    }


    ListModel{
        id:ampmmodel
        ListElement{index:"AM"}
        ListElement{index:"PM"}
    }
    ListModel{
        id:themodel
        ListElement{listtitle:"Time";}
        ListElement{listtitle:"Repeat Schedule";}
        ListElement{listtitle:"Operation Settings";}
    }

    Component.onCompleted: {
        initaddSchedule()
        repeatText="Everyday"
    }

    function initaddSchedule(){
        hourText=""
        minText=""
        ampmText=""

        repeatText="Everyday"

        startYear=""
        startMonth=""
        startDate=""

        endYear=""
        endMonth=""
        endDate=""

        runnigmodeText="Cool"
        temperatureText="18"
        tempDegree=" ̊"

        repeatOption.initRepeatSchedule()
        operatingOption.initaddOperationSetting()
    }
}
