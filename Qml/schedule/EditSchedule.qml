import QtQuick 2.7
import QtQuick 2.10
import QtQml 2.0
import "../Global"
import "../Common"
Rectangle{
    /*To do
      edit done 클릭 DB 변경 신호 보내기
      data에 opacity를 추가해서 사용하려고 합니다....
    */
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    property string hourText:""
    property string minText: ""
    property string ampmText: ""

    property string hourText2:""
    property string minText2: ""
    property string ampmText2: ""

    property var dayOfWeek

    property var themodel:circuitmodel //default

    property string startYear: ""
    property string startMonth: ""
    property string startDate: ""

    property string endYear: ""
    property string endMonth: ""
    property string endDate: ""

    property string fstText:hourText===""?"":hourText+":"+minText+" "+ampmText
    property string sndText:"Everyday"
    property string trdText:"Cool"
    property string fthText:"25"

    property string runnigmodeText
    property string temperatureText

    property string tempDegree: " ̊"

    property bool activationToggleFlag: true

    property int whichEdit:0 //{0:circuit,1:silent}

    //id, name 저장 변수가 필요.
    property string idString: ""
    property string nameString: ""
    property bool isUse

    signal sigBackClickEditSchedule()
    signal sigDeleteClickEditSchedule(var scheduleData)
//    signal sigDoneClickEditSchedule(string _hour, string _min, string _runningmode, string _temperature)
    signal sigDoneClickEditSchedule(var scheduleData)
    signal sigmodelchange(string _selectediconSource)

    Column{
        anchors.fill:parent
        TitleBar{
            id:titleBar
            state:"C"
            left_1st_Text:qsTr("Edit Schedule")
            onSigLClickTitleBar: {
                // initScheduleAct()
                sigBackClickEditSchedule()
            }
            onSigRowLClick: {
                var scheduleID = idString
                sigDeleteClickEditSchedule(scheduleID)
            }
            onSigRowRClick: {
                //activation 상태를 설정 함수에 바로 보내므로 불필요 코드
//                if(activationToggleFlag===true){
//                    sigDoneClickEditSchedule(hourText,minText,trdText,fthText)
//                }
//                else if(activationToggleFlag===false){
//                    sigDoneClickEditSchedule("","","","")
//                }

                var scheduleData = {
                   "isUse": activationToggleFlag,
                   "id": idString,
                   "name": nameString,
                   "time": timeText,
                   "day": [ dayOfWeek["mon"] ? "MON" : ""
                            , dayOfWeek["tue"] ? "TUE" : ""
                            , dayOfWeek["wen"] ? "WEN" : ""
                            , dayOfWeek["the"] ? "THE" : ""
                            , dayOfWeek["fri"] ? "FRI" : ""
                            , dayOfWeek["sat"] ? "SAT" : ""
                            , dayOfWeek["sun"] ? "SUN" : ""
                          ],
                    "isEveryWeek": repeatOption.isEveryWeek,
                    "isPeriod": repeatOption.isPeriod,
                    "startDate": repeatOption.startDateString,
                    "endDate": repeatOption.endDateString,
                    "operation": runnigmodeText,
                    "temperature": temperatureText
                };

                sigDoneClickEditSchedule(scheduleData);
            }
        }

        List{
            id:scheduleActoption
            left_1st_Text:qsTr("Schedule Activation")
            state:"C"
            imagename: "on"
            onSigtoggleOff: {
                activationToggleFlag=false
                Variables.opacityInit(themodel,0.3)
            }
            onSigtoggleOn: {
                activationToggleFlag=true
                Variables.opacityInit(themodel,1)
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
                left_1st_Text:qsTr(listtitle)
                rightItemtextField:index===0?fstText:index===1?sndText:trdText
                state:"B"
                expand1:true
                textOpacity:Textopacity
                rightTextBoxClip:false
                radioExclusive:false
                Row{
                    id:operationmold
                    leftPadding: 420;topPadding:27
                    visible:index===2?true:false
                    spacing:10
                    Rectangle{
                        id:operationmidline
                        visible:tempDegree===""?false:true
                        opacity: Textopacity
                        anchors.verticalCenter: parent.verticalCenter
                        width:1;height:16
                         color:"#979797"
                    }
                    Text{
                        id:operationTextBox
                        Rectangle{anchors.fill: parent;color:"transparent";opacity:0.3}
                        opacity: Textopacity
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignRight
                        width: 22;height:width
                        text:fthText+tempDegree
                        horizontalAlignment: Text.AlignLeft
                        color:"#555555"
                        font.pixelSize: 18
                    }

                }

                onSigClick:{
                    switch(index){
                        case 0:{
                            timeOption.visible=true;
                            timePicker.visible=true;
                            //timepicker 초기값 잡기
                            break;
                        }
                        case 1:{
                            if(themodel===circuitmodel){
                                repeatOption.visible=true;

                            }
                            else if(themodel===silencemodel){
                                timeOption.visible=true;
                                timePicker.visible=false;
                                timePicker2.visible=true;
                            }
                            //repeatOptiopicker 초기값 잡기 days, start/EndDate
                            break;
                        }
                        case 2:{
                            if(themodel===circuitmodel){
                                // operatingOption.setRunnigmodeText=trdText
                                // operatingOption.setTemperatureText=fthText
                                operatingOption.visible=true;
                            }
                            break;
                        }
                    }
                }
                Component.onCompleted: {
                    if(index===0){
                        listdelegate.fstText
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

    Rectangle{
        id:timeOption
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        color:"#26000000"
        visible:false
        MouseArea{anchors.fill:parent;}
        PopupPicker{
            id:timePicker
            textfieldText:qsTr("Time")
            anchors.centerIn: parent
            midline:false
            visible:false
            state:"triple"
            firstmodel:12
            secondmodel:60
            thirdmodel:ampmmodel

            onSigCancelClick: {
                timeOption.visible=false
                visible=false
            }
            onSigOkClick: {
                timeOption.visible=false
                visible=false
                hourText=_firstText/*.toString().padStart(2, '0')*/
                minText=Variables.padStart(_secondText.toString(),2)
                ampmText=ampmmodel.get(_thirdText).index
            }
        }

        PopupPicker{
            id:timePicker2
            textfieldText:"Time"
            anchors.centerIn: parent
            visible:false
            midline:false
            state:"triple"
            firstmodel:12
            secondmodel:60
            thirdmodel:ampmmodel

            onSigCancelClick: {
                timeOption.visible=false
                visible=false
            }
            onSigOkClick: {
                timeOption.visible=false
                visible=false
                hourText2=_firstText/*.toString().padStart(2, '0')*/
                minText2=Variables.padStart(_secondText.toString(),2)
                ampmText2=ampmmodel.get(_thirdText).index
                sndText=hourText2+":"+minText2+" "+ampmText2
            }
        }

    }

    RepeatSchedule{
        id:repeatOption
        visible:false
        onSigBackClickRepeatSchedule:{
            visible=false
            sndText=""
            dayOfWeek=0

            sndText=getRepeatText(repeatOption._dayOfWeek)
            // console.log("sndText"+sndText)
//repeatOption.startDateString 로 설정 !!!!!!!!!!!!
            // startYear= _startDateList["year"]
            // startMonth= _startDateList["month"]
            // startDate= _startDateList["date"]

            // endYear= _endDateList["year"]
            // endMonth= _endDateList["month"]
            // endDate= _endDateList["date"]
        }
    }

    ScheduleOperating{
        id:operatingOption
        visible:false
        onSigBackClickOperating:{
            trdText=_sendrunnigmode
            fthText=_sendtemperature
            if(trdText===""||fthText===""){
                tempDegree=""
                if(trdText===""&&fthText===""){
                    trdText=qsTr("Off")
                }
            }
            else{
                tempDegree=" ̊"
            }
            visible=false
        }
        onSigBackClickOperatinghot:{
            tempDegree=" ̊"
            fthText=_sendtemperature
            if(fthText===""){
                trdText=qsTr("Off")
                tempDegree=""
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
        id:circuitmodel
        ListElement{listtitle:qsTr("Time");Textopacity:1}
        ListElement{listtitle:qsTr("Repeat Schedule");Textopacity:1}
        ListElement{listtitle:qsTr("Operation Settings");Textopacity:1}
    }
    ListModel{
        id:recircuitmodel
        ListElement{listtitle:qsTr("Start Time");Textopacity:1}
        ListElement{listtitle:qsTr("End Time");Textopacity:1}
        ListElement{listtitle:qsTr("Repeat Schedule");Textopacity:1}
    }
    ListModel{
        id:silencemodel
        ListElement{listtitle:qsTr("Start Time");Textopacity:1}
        ListElement{listtitle:qsTr("End Time");Textopacity:1}
    }

    function setSilentedit(_sthour,_stmin,_stampm,_endhour,_endmin,_endampm,_isUse){
        hourText=_sthour
        minText=_stmin
        ampmText=ampmmodel.get(_stampm).index

        hourText2=_endhour
        minText2=_endmin
        ampmText2=ampmmodel.get(_endampm).index

        activationToggleFlag=_isUse
        if(activationToggleFlag===true){
            scheduleActoption.sigtoggleOn()
        }
        else if(activationToggleFlag===false){
            scheduleActoption.sigtoggleOff()
        }
        scheduleActoption.titleToggleInit(activationToggleFlag)


        // fstText=_sthour+":"+_stmin+" "+_stampm
        sndText=_endhour+":"+_endmin+" "+ampmText2

        timePicker.sigSetDefaultIndex(_sthour,_stmin,_stampm)
        timePicker2.sigSetDefaultIndex(_endhour,_endmin,_endampm)
    }

    function sethotwateredit(_temp){

        fthText=_temp
        // timePicker2.sigSetDefaultIndex(_endhour,_endmin,_ampm)
    }

    function seteditSchedule(_hour,_min,_ampm,_runmode,_temp,_days,_isUse,_isEveryWeek,_isPeriod,_startDate,_endDate,_id,_name){
        //todo activate연결
        hourText=_hour
        minText=_min
        ampmText=_ampm
        // sndText="Everyday" //to do ... have to Db days read
        sndText=_days

        activationToggleFlag=_isUse
        if(activationToggleFlag===true){
            scheduleActoption.sigtoggleOn()
        }
        else if(activationToggleFlag===false){
            scheduleActoption.sigtoggleOff()
        }
        scheduleActoption.titleToggleInit(activationToggleFlag)

        repeatOption.editRepeatInit(_days, _startDate,_endDate,_isEveryWeek,_isPeriod)

        trdText=_runmode.charAt(0).toUpperCase()+_runmode.slice(1)

        if(/*trdText==="Auto"||*/trdText==="On"||trdText==="Off"){
            themodel.get(2).Textopacity=0.3
            tempDegree=""
        }
        else{
            tempDegree= " ̊"
        }
        fthText=_temp

        timePicker.sigSetDefaultIndex(_hour,_min,0)//third index AM fixed
        operatingOption.sigSetDefaultData(trdText,fthText)
        operatingOption.initeditOperationSetting()
        //operating 에 Text data전송

        dayOfWeek=[]

    }

    function initScheduleAct(){
        activationToggleFlag=true
        scheduleActoption.titleToggleInit(true)
        opacityInit(themodel,1)
    }

    function repeatTextTolist(_repeatText){
        var daylist=["sun","mon","tue","wed","thu","fri","sat"]
        var repeatDaylist=[]
        var datelistTemp=[]
        repeatDaylist=_repeatText.split(" ")
        for(var item in daylist){
            datelistTemp[item]=false
            var idx=daylist.indexOf(repeatDaylist[item])
            datelistTemp[idx]=true
        }
        console.log(datelistTemp.length)
        return datelistTemp
    }

    onSigmodelchange:{
        // console.log(_selectediconSource)
        switch(_selectediconSource){
        case "circuit_1":{themodel=circuitmodel;operatingOption.sigModelchange(_selectediconSource);break;}
        case "circuit_hotwater":{themodel=circuitmodel;operatingOption.sigModelchange(_selectediconSource);break;}
        case "circuit_DHW_heater":{themodel=circuitmodel;operatingOption.sigModelchange(_selectediconSource);break;}
        case "circuit_DHW_recirculation":{themodel=recircuitmodel;break;}
        case "circuit_exception_date":{break;/*to Do 변경*/}
        case "circuit_silent_mode":{themodel=silencemodel;break;}
        }
    }
}
