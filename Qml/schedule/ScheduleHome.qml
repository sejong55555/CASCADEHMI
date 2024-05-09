import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQml 2.0
import QtQuick.VirtualKeyboard 2.0
import "../Global"
import "../Common"

Item {
    id: root
    // width: Variables.sourceWidth;height: Variables.sourceHeight
    property string slientStartTime:""
    property string slientEndTime:""

    property string _silentStartHour
    property string _silentStartMin
    property string _silentStartAmpm

    property string _silentEndHour
    property string _silentEndMin
    property string _silentEndAmpm

    property string componentid:""

    property string selectedmenu: ""
    property string selectediconSource: ""

    property string popuptoastText :""

    property var homeListmodel

    property var roadingthemodel

    StackView{
        id:stackView
        anchors.fill: parent
        initialItem:scheduleListHome
    }

    TitleBarWindow{
        id:scheduleListHome
        titleName:"Schedule"
        mainModel:homeListmodel
        subModel: submodel
        titleState:"B"
        onSigrightItemClick: {
            initilizingConfirmBg.visible=true
        }
        onSiglistBarClick:{//delivery index
            selectedmenu=_selectedmenu
            selectediconSource=_selectediconSource
            console.log(selectedmenu+"  "+selectediconSource)
            roadingthemodel=modelRead(selectediconSource)//스케쥴 리스트 해당 디바이스에 맞는 model 불러오기
            editSchedule.sigmodelchange(selectediconSource)

            switch(selectediconSource){
            case "circuit_DHW_recirculation":{
                stackView.push(dhwrecirculation)
                break;
            }
            case "circuit_exception_date":{
                stackView.push(exeptionSchedule)
                // exeptionSchedule.visible=true
                break;
            }
            case "circuit_silent_mode":{
                editSchedule.setSilentedit(_silentStartHour,_silentStartMin,_silentStartAmpm,_silentEndHour,_silentEndMin,_silentEndAmpm)
                editSchedule.visible=true
                break;
            }
            default:{
                stackView.push(selectedmenulist)
                break;
            }
            }
        }
        onSigbackClick:{
            Variables.content="Home"
            // stackView.pop()
        }
    }

    Component{
        id:selectedmenulist
        TitleBarWindow{
            titleName: qsTr(selectedmenu)
            titleState:"F"
            leftIconSource: selectediconSource
            mainModel:dailyNlist
            subModel:submodel
            onSigrightItemClick:{
                addSchedule.visible=true
            }
            onSiglistBarClick:{

                switch(_index){
                case 0:{
                    stackView.push(dailyschedule)
                    break;}
                case 1:{
                    stackView.push(schedulelist)
                    break;}
                }
            }
            onSigbackClick:{
                stackView.pop()              
            }
        }
    }

    Component{
        id:dhwrecirculation
        ScheduleList{
            titleName:qsTr("DHW Recirculation")
            titleIconSource:selectediconSource
            rightItemClickEnable:false
            themodel:roadingthemodel
            onSigbackClick: {
                stackView.pop()
            }
        }
    }

    Component{
        id:dailyschedule
        ScheduleDaily{
            titleIconSource:selectediconSource;
            themodel:roadingthemodel
            onSigrightItemClickDaily:{
                addSchedule.visible=true
            }
            onSigbackClickDaily: {
                stackView.pop()
            }
            onSigeditClickDaily: {
                editSchedule.visible=true
            }
        }
    }

    Component{
        id:schedulelist
        ScheduleList{
            // titleName:"Schedule List"
            titleIconSource:selectediconSource
            themodel:roadingthemodel
            onSigrightItemClick:{
                addSchedule.visible=true
            }
            onSigbackClick: {
                stackView.pop()
            }
        }
    }

    Component{
        id:exeptionSchedule
        ScheduleList{
            titleName:qsTr("Exception Day")
            titleIconSource:selectediconSource
            backgroundText:qsTr("Tap ‘+’ button to add exception day.")
            themodel:roadingthemodel
            onSigrightItemClick:{
                // exaddSchedule.visible=true
                exeditSchedule.visible=true
            }
            //list click시 edit 등장
            onSigbackClick:{
                stackView.pop()
            }
        }
    }

    ExceptionAddSchedule{
        id:exaddSchedule
        visible:false
        onSigBackClickExAdd:{
            exaddSchedule.visible=false
        }
        onSigDoneClickExAdd: {
            roadingthemodel=modelRead(selectediconSource)
            exaddSchedule.visible=false
            //*to do interface로 ex schedule 추가
        }

    }

    ExceptionEditSchedule{
        id:exeditSchedule
        visible:false
        onSigBackClickExEdit:{
            exeditSchedule.visible=false
        }
        onSigDoneClickExEdit: {
            roadingthemodel=modelRead(selectediconSource)
            exeditSchedule.visible=false
            //*to do interface로 ex schedule 추가
        }
    }

    AddSchedule{
        id:addSchedule
        visible:false
        onSigBackClickAdd:{
            addSchedule.visible=false
            addSchedule.initaddSchedule()
        }
        onSigDoneClickAdd:{
            //selectediconSource로 구분해서 DB에 schedule 추가 신호
            roadingthemodel=modelRead(selectediconSource)
            addSchedule.initaddSchedule()
            addSchedule.visible=false
            popuptoastText=qsTr("A schedule has been added.")
            popuptoastComponent.visible=true
            popuptoastComponent.sigFadeStart()
        }
    }

    EditSchedule{
        id:editSchedule
        visible:false
        onSigBackClickEditSchedule:{
            //schedule activation toggle을 그냥 DB에 있으면 읽어와서 model update하면 되는데 없으면 뒤로가기 키 했을때 toggle초기화 기능 추가
            editSchedule.visible=false
        }
        onSigDoneClickEditSchedule:{
            //*to Do var somedata를 selectediconSource로 구분해서 DB에 schedule 수정 신호
            roadingthemodel=modelRead(selectediconSource)//model reroad
            editSchedule.visible=false
            popuptoastText=qsTr("A schedule has been edited.")
            popuptoastComponent.visible=true
            popuptoastComponent.sigFadeStart()
        }

        onSigDeleteClickEditSchedule: {
            deletePopup.visible=true
        }
    }


    Rectangle {
        id:deletePopup
        visible:false
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        color:"#26000000"
        MouseArea{anchors.fill:parent}
        PopupPickerRadio{
            anchors.centerIn: parent
            firstbtnText:"Cancel"
            secondbtnText:"Delete"
            textfieldText:qsTr("Delete Repeating Schedule")
            firstTextField:qsTr("Only this schedule")
            secondTextField:qsTr("All repeating schedules")
            onSigRightClick: {
                popuptoastText=qsTr("A schedule has been deleted.")

                //model reroad
                // roadingthemodel=modelRead(selectediconSource)

                deletePopup.visible=false
                editSchedule.visible=false
                popuptoastComponent.visible=true
                popuptoastComponent.sigFadeStart()

                if(radiobtnChecked===true){
                    //only this schedule delete
                }
                else if(radiobtn2Checked===true){
                    //all repeat schedule delete
                }
            }
            onSigLeftClick: {
                deletePopup.visible=false
            }
        }
    }

    //the following code, for initializing of schedule data
    ScheduleInitialize{
        id:initilizing
        visible:false
        onSigInitDone: {
            //selectediconSource로 구분해서 DB에 schedule 추가
            initilizing.visible=false
            popuptoastText=qsTr("Schedule has been initialized.")
            popuptoastComponent.visible=true
            popuptoastComponent.sigFadeStart()
        }
    }

    PopupToast{
        id:popuptoastComponent
        visible:false
        state:"1line"
        textstring:popuptoastText
        onSigFadeDone: {
            popuptoastComponent.visible=false
        }
    }

    Rectangle{
        id:initilizingConfirmBg
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        color:"#26000000"
        MouseArea{anchors.fill:parent}
        PopupLine{
            id:initilizingConfirm
            x:20;y:20
            state:"2line"
            opacity:1
            textBox:qsTr("All schedule data will be reset.\nAre you sure you want to initialize?")
            firstbtnText:"Cancel"
            secondbtnText:"Initialize"
            onSigLClick: {
                initilizingConfirmBg.visible= false
            }
            onSigRClick: {
                initilizingConfirmBg.visible=false
                initilizing.visible=true
                initilizing.initStart()
            }
        }
    }

    //model
    ListModel{
        id: mainmodel
        ListElement{Listtitle: "Circuit";statename:"G";iconSource:"circuit_1";subText:"";rightItemsourcename:"";}
        //main,model에서 circuit 개수에 따라 model 추가되어야 함. circuit은 home에서 read하는 부분에서 읽어서 바로 model에 추가하기
        ListElement{Listtitle: "Hot Water";statename:"G";iconSource:"circuit_hotwater";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: "DHW Heater";statename:"G";iconSource:"circuit_DHW_heater";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: "DHW Recirculation";statename:"G";iconSource:"circuit_DHW_recirculation";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: "Silent Mode";statename:"H";iconSource:"circuit_silent_mode";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: "Exception Date";statename:"G";iconSource:"circuit_exception_date";subText:"";rightItemsourcename:""}
    }
    ListModel{
        id:dailyNlist
        ListElement{Listtitle: "Daily Schedule";iconSource:"";statename:"A";rightItemsourcename:"";}
        ListElement{Listtitle: "Schedule List";iconSource:"";statename:"A";rightItemsourcename:"";}
    }

    ListModel{
        id:exceptionlistmodel

    }

    //각 디바이스의 스케쥴을 읽어와서 element 아래와 같은 형태로 넣으면 읽어올 것으로 .. 예상...
    //알맞게 어떻게 변경할까..
    ListModel{
        id:circuitmodel//date객체와 time따로 가져올 수 있을 것으로 예상..
        // ListElement{date:"2024-04-10";time:"00";
        //     detail:[
        //         ListElement{hour:"00";min:"20";runningMode:"on";temp:"";days:""}
        //     ]
        // }
        // ListElement{date:"2024-04-10";time:"06";
        //     detail:[
        //         ListElement{hour:"06";min:"20";runningMode:"heat";temp:"28.5";days:""},
        //         ListElement{hour:"06";min:"37";runningMode:"cool";temp:"17";days:""},
        //         ListElement{hour:"06";min:"50";runningMode:"auto";temp:"";days:""}
        //     ]
        // }
        // ListElement{date:"2024-04-10";time:"08";
        //     detail:[
        //         ListElement{hour:"08";min:"50";runningMode:"cool";temp:"21";days:""}
        //     ]
        // }
        // ListElement{date:"2024-04-10";time:"10";
        //     detail:[
        //         ListElement{hour:"10";min:"50";runningMode:"cool";temp:"18";days:""},
        //         ListElement{hour:"10";min:"50";runningMode:"off";temp:"";days:""}
        //     ]
        // }
    }

    ListModel{
        id:hotwatermodel
        ListElement{date:"2024-04-10";time:"06";
            detail:[
                ListElement{hour:"06";min:"20";runningMode:"on";temp:"55"},
                ListElement{hour:"06";min:"37";runningMode:"off";temp:""}
            ]}
        ListElement{date:"2024-04-10";time:"08";
            detail:[
                ListElement{hour:"06";min:"20";runningMode:"on";temp:"62"},
                ListElement{hour:"06";min:"37";runningMode:"off";temp:""}
            ]}
        ListElement{date:"2024-04-10";time:"15";
            detail:[
                ListElement{hour:"06";min:"20";runningMode:"on";temp:"50"},
                ListElement{hour:"06";min:"50";runningMode:"off";temp:""}
            ]}
    }

    ListModel{
        id:dhwheatermodel
        ListElement{date:"2024-04-10";time:"06";
            detail:[
                ListElement{hour:"06";min:"20";runningMode:"heat";temp:"28.5"},
                ListElement{hour:"06";min:"37";runningMode:"cool";temp:"17"},
                ListElement{hour:"06";min:"50";runningMode:"auto";temp:""}
            ]}
        ListElement{date:"2024-04-10";time:"08";
            detail:[
                ListElement{hour:"06";min:"20";runningMode:"heat";temp:"28.5"},
                ListElement{hour:"06";min:"37";runningMode:"cool";temp:"17"},
                ListElement{hour:"06";min:"50";runningMode:"auto";temp:""}
            ]}
        ListElement{date:"2024-04-10";time:"15";
            detail:[
                ListElement{hour:"06";min:"20";runningMode:"heat";temp:"28.5"},
                ListElement{hour:"06";min:"37";runningMode:"cool";temp:"17"},
                ListElement{hour:"06";min:"50";runningMode:"auto";temp:""}
            ]}
    }

    ListModel{
        id:dhwrecirculationmodel
    }

    ListModel{
        id: submodel
    }

    function silentRead(){
        // *to do DB에서 date read해서 저장
        var slientTimeText

        _silentStartHour="6"
        _silentStartMin="00"
        _silentStartAmpm="AM"

        _silentEndHour="2"
        _silentEndMin="00"
        _silentEndAmpm="PM"

        slientStartTime=_silentStartHour+":"+_silentStartMin+" "+_silentStartAmpm
        slientEndTime=_silentEndHour+":"+_silentEndMin+" "+_silentEndAmpm
        slientTimeText=slientStartTime+" ~ "+slientEndTime

        return slientTimeText

        //*to do silence time 읽어오기...
    }

    function modelRead(name){
        //To do:날짜 입력부분 추가해서 읽어야함
        var themodelTemp
        //*to do menu에 따라서 read DB data 변경할 수 있게
        themodelTemp=(name==="circuit_1")?circuitmodel:(name==="circuit_hotwater")?hotwatermodel:(name==="circuit_DHW_heater")?dhwheatermodel:(name==="circuit_DHW_heater")?exceptionlistmodel:dhwrecirculationmodel
        console.log("model's been updated.")
        return themodelTemp
    }

    function circuitModelRead(){
        // var resultData = appModel.ddc_getSchedules()// _date에 따라서 데이터 불러오기
        var resultData=[//_read날짜 읽어와서 result date에 append
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test1",
                       "time": "8:00 AM",
                       "runmode":"on",
                       "temp":"",
                       "days": [true,true,false,true,true,false,true],
                       "weeklySchedules": ["1", "2", "3"],
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test2",
                       "time": "10:12 AM",
                       "runmode":"heat",
                       "temp":"28.5",
                       "days": [false,false,false,false,false,true,true],
                       "weeklySchedules": ["1", "2", "3"],
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test2",
                       "time": "10:47 AM",
                       "runmode":"cool",
                       "temp":"18",
                       "days": [false,false,false,false,false,true,true],
                       "weeklySchedules": ["1", "2", "3"],
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test3",
                       "time": "11:00 AM",
                       "runmode":"cool",
                       "temp":"17",
                       "days": [true,true,true,true,true,false,false],
                       "weeklySchedules": ["1", "2", "3"],
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test4",
                       "time": "11:43 PM",
                       "runmode":"auto",
                       "temp":"5",
                       "days": [true,true,false,false,true,false,false],
                       "weeklySchedules": ["1", "2", "3"],
                    }
                ]
        circuitmodel.clear()

        var hourlist=[]
        var uniquehourlist=[]
        var minlist=[]
        var ampmlist=[]
        var isUselist=[]
        var runningModelist=[]
        var templist=[]
        var dayslist=[]

        var detailtemp=[]
                // {"time":[],"min":[],"isUse":[],"runningMode":[],"temp":[],"days":[]}
        var nextindex=0

        var hourTemp
        var minTemp
        var ampmTemp
        var prehourTemp

        for(var item=0;item<resultData.length;item++){
            nextindex=item+1

            hourTemp=resultData[item]["time"].split(" ")[0].split(":")[0]
            minTemp=resultData[item]["time"].split(" ")[0].split(":")[1]
            ampmTemp=resultData[item]["time"].split(" ")[1]

            if(resultData[nextindex]!== undefined){
                prehourTemp=resultData[nextindex]["time"].split(" ")[0].split(":")[0]
            }
            else{
                prehourTemp="null"
            }

            hourlist.push(hourTemp)
            minlist.push(minTemp)
            ampmlist.push(ampmTemp)
            isUselist.push(resultData[item]["isUse"])
            runningModelist.push(resultData[item]["runmode"])
            templist.push(resultData[item]["temp"])
            dayslist.push(resultData[item]["days"])

            if(hourTemp!==prehourTemp){
                hourlist.forEach(function(item) {
                    if (uniquehourlist.indexOf(item) === -1) {
                        uniquehourlist.push(item);
                    }
                });
                detailtemp.push({"time":uniquehourlist
                              ,"hour":hourlist
                              ,"min":minlist
                              ,"ampm":ampmlist
                              ,"isUse":isUselist
                              ,"runningMode":runningModelist
                              ,"temp":templist
                              ,"days":dayslist})

                hourlist=[];
                uniquehourlist=[];
                minlist=[];
                ampmlist=[];
                isUselist=[];
                runningModelist=[];
                templist=[];
                dayslist=[];
            }
        }


        for(var i in detailtemp){
            circuitmodel.append({time:detailtemp[i]["time"][0],detail:[]})
            for(var j in detailtemp[i]["min"]){
                // console.log(detailtemp[i]["days"][j])
                // console.log(typeof(detailtemp[i]["days"][j]))
                console.log(getRepeatText(detailtemp[i]["days"][j]))
                circuitmodel.get(i).detail.append({hour:detailtemp[i]["hour"][j]
                                                     ,min:detailtemp[i]["min"][j]
                                                     ,ampm:detailtemp[i]["ampm"][j]
                                                     ,isUse:detailtemp[i]["isUse"][j]
                                                     ,runningMode:detailtemp[i]["runningMode"][j]
                                                     ,temp:detailtemp[i]["temp"][j]
                                                     /*day가 ["MON","","WED",...]가 아닌
                                                     MON 처음 기준으로  [true,false,true,...]로 들어오길 희망..*/
                                                     //
                                                     ,days:detailtemp[i]["days"][j]
                                                     })
            }
        }
    }

    function getRepeatText(_days){
        var dayOfWeekidx=0

        var dayOfWeekidxList=[]

        var repeatTextTemp=""
        for(var key in _days){

            if(_days[key]===true){
                dayOfWeekidxList.push(dayOfWeekidx)
                repeatTextTemp+=key+" " //to do 변수에 qsTr할 수 있나
            }
            dayOfWeekidx++;
        }

        dayOfWeekidxList=dayOfWeekidxList.join(',')
        if(dayOfWeekidxList==="0,1,2,3,4,5,6"){
            repeatTextTemp=qsTr("Everyday")
        }
        else if(dayOfWeekidxList==="0,6"){
            repeatTextTemp=qsTr("Weekend")
        }
        else if(dayOfWeekidxList==="1,2,3,4,5"){
            repeatTextTemp=qsTr("Weekday")
        }
        return repeatTextTemp
    }

    function opacityInit(_model,_opacityValue){
        for(var i=0;i < _model.count;i++){
        _model.get(i).Textopacity=_opacityValue
        }
    }

    InputPanel {
        id: virtualKeyboard
        visible: Qt.inputMethod.visible
        width: parent.width
        height: parent.height * 0.4
        y: parent.height - height
    }

    Component.onCompleted: {
        circuitModelRead()
        var silentTextTemp=silentRead()
        mainmodel.get(4).subText=silentTextTemp
        homeListmodel=mainmodel
    }
}
