import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQml 2.0
import QtQuick.VirtualKeyboard 2.0
import "../Global"
import "../Common"
import EnumHMI 1.0

Item {
    id: root
    // width: Variables.sourceWidth;height: Variables.sourceHeight

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

    property bool isDaily: true
    property string whichDevice: ""

    property var homeListmodel

    property var roadingthemodel

    //code by pms : 삭제를 위한 스케쥴 아이디 임시 저장 변수
    property string strDeleteID: ""

    Connections {
        target: appModel
/**
 * @brief 스케쥴 변경에 따른 업데이트 시그널 철리 슬롯 함수.
 */
        function onSigScheduleChanged(action) {
            console.log("Recv signal schedul change!!!!");

            if(action === EnumHMI.SCHEDULE_ADD) {
                console.log("change add schedule!");
                roadingthemodel=modelRead(whichDevice)
                addSchedule.initaddSchedule()
                addSchedule.visible=false
                popuptoastText=qsTr("A schedule has been added.")
                popuptoastComponent.visible=true
                popuptoastComponent.sigFadeStart()
            } else if(action === EnumHMI.SCHEDULE_EDIT) {
                console.log("change edit schedule!");
                roadingthemodel=modelRead(whichDevice)//model reroad
                editSchedule.visible=false
                popuptoastText=qsTr("A schedule has been edited.")
                popuptoastComponent.visible=true
                popuptoastComponent.sigFadeStart()
            } else {
                //model reroad 필요할 것으로 생각됨.
                // roadingthemodel=modelRead(whichDevice)
                deletePopup.visible=false
                editSchedule.visible=false
                popuptoastComponent.visible=true
                popuptoastComponent.sigFadeStart()
            }
        }
    }

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
            console.log("ini")
            initilizingConfirmBg.visible=true
        }
        onSiglistBarClick:{//delivery index
            selectedmenu=_selectedmenu

            whichDevice=mainmodel.get(_index).Listtitle
            selectediconSource=mainmodel.get(_index).iconSource
            //스케쥴 리스트 해당 디바이스에 맞는 model 불러오기
            switch(_index){

            case 3:{
                roadingthemodel=modelRead(whichDevice)
                stackView.push(dhwrecirculation)
                break;
            }
            case 4:{
                editSchedule.setSilentedit(_silentStartHour,_silentStartMin,_silentStartAmpm,_silentEndHour,_silentEndMin,_silentEndAmpm,isSilentUse)
                editSchedule.visible=true
                break;
            }
            case 5:{
                stackView.push(exeptionSchedule)
                // exeptionSchedule.visible=true
                break;
            }
            default:{
                stackView.push(selectedmenulist)
                break;
            }
            }
            console.log(selectedmenu+"  "+selectediconSource)
            editSchedule.sigmodelchange(selectediconSource)
        }
        onSigbackClick:{
            Variables.content="Home"
            // stackView.pop()
        }
    }

    Component{
        id:selectedmenulist
        TitleBarWindow{
            titleName: selectedmenu
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
                    isDaily=true
                    roadingthemodel=modelRead(whichDevice)
                    stackView.push(dailyschedule)
                    break;}
                case 1:{
                    isDaily=false
                    roadingthemodel=modelRead(whichDevice)
                    stackView.push(listschedule)
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
        id:listschedule
        ScheduleList{
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
            // roadingthemodel=modelRead(whichDevice)
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
            // roadingthemodel=modelRead(whichDevice)
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
        onSigDoneClickAdd :{
            //selectediconSource로 구분해서 DB에 schedule 추가 신호
            console.log("Start add schedule data");
            console.log(data["isUse"]);
            console.log(data["time"]);
            var weekend = data["day"];
            for(var item in weekend)
                console.log(weekend[item]);
            console.log(data["isEveryWeek"]);
            console.log(data["isPeriod"]);
            console.log(data["startDate"]);
            console.log(data["endDate"]);
            console.log(data["operation"]);
            console.log(data["temperature"]);
            console.log("End add schedule data");

            //실제 스케쥴 등록 코드 : 등록 처리는 안되어 있고 업데이트를 위해서 시그널 처리만 되어 있음.
            appModel.ddc_addSchedule(data);

            //아래 부분은 sigScheduleChanged 시그널 처리 부분으로 이동.
//            roadingthemodel=modelRead(selectediconSource)
//            addSchedule.initaddSchedule()
//            addSchedule.visible=false
//            popuptoastText=qsTr("A schedule has been added.")
//            popuptoastComponent.visible=true
//            popuptoastComponent.sigFadeStart()
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
            console.log("Start edit schedule data");
            console.log(data["isUse"]);
            console.log(data["id"]);
            console.log(data["name"]);
            console.log(data["time"]);
            var weekend = data["day"];
            for(var item in weekend)
                console.log(weekend[item]);
            console.log(data["isEveryWeek"]);
            console.log(data["isPeriod"]);
            console.log(data["startDate"]);
            console.log(data["endDate"]);
            console.log(data["operation"]);
            console.log(data["temperature"]);
            console.log("End edit schedule data");

            //실제 스케쥴 편집 코드 : 편집 처리는 안되어 있고 업데이트를 위해서 시그널 처리만 되어 있음.
            appModel.ddc_setSchedule(data);

            //아래 부분은 sigScheduleChanged 시그널 처리 부분으로 이동.
//            roadingthemodel=modelRead(selectediconSource)//model reroad
//            editSchedule.visible=false
//            popuptoastText=qsTr("A schedule has been edited.")
//            popuptoastComponent.visible=true
//            popuptoastComponent.sigFadeStart()
        }

        onSigDeleteClickEditSchedule: {
            console.log("Schedule delete data id : " + data);
            strDeleteID = data;

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
            firstbtnText:qsTr("Cancel")
            secondbtnText:qsTr("Delete")
            textfieldText:qsTr("Delete Repeating Schedule")
            firstTextField:qsTr("Only this schedule")
            secondTextField:qsTr("All repeating schedules")
            onSigRightClick: {
                popuptoastText=qsTr("A schedule has been deleted.")

                //아래 부분은 sigScheduleChanged 시그널 처리 부분으로 이동.
//                //model reroad
//                // roadingthemodel=modelRead(selectediconSource)
//                deletePopup.visible=false
//                editSchedule.visible=false
//                popuptoastComponent.visible=true
//                popuptoastComponent.sigFadeStart()

                var deleteID = -1;
                if(radiobtnChecked===true){
                    //only this schedule delete
                    deleteID = strDeleteID;
                }
                else if(radiobtn2Checked===true){
                    //all repeat schedule delete
                    deleteID = "-1"
                }
                //실제 스케쥴 편집 코드 : 편집 처리는 안되어 있고 업데이트를 위해서 시그널 처리만 되어 있음.
                appModel.ddc_deleteSchedule(deleteID);
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
            firstbtnText:qsTr("Cancel")
            secondbtnText:qsTr("Initialize")
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
        ListElement{Listtitle: qsTr("Circuit");statename:"G";iconSource:"circuit_1";subText:"";rightItemsourcename:"";}
        //main,model에서 circuit 개수에 따라 model 추가되어야 함. circuit은 home에서 read하는 부분에서 읽어서 바로 model에 추가하기
        ListElement{Listtitle: qsTr("Hot Water");statename:"G";iconSource:"circuit_hotwater";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: qsTr("DHW Heater");statename:"G";iconSource:"circuit_DHW_heater";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: qsTr("DHW Recirculation");statename:"G";iconSource:"circuit_DHW_recirculation";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: qsTr("Silent Mode");statename:"H";iconSource:"circuit_silent_mode";subText:"";rightItemsourcename:""}
        ListElement{Listtitle: qsTr("Exception Date");statename:"G";iconSource:"circuit_exception_date";subText:"";rightItemsourcename:""}
    }
    ListModel{
        id:dailyNlist
        ListElement{Listtitle: qsTr("Daily Schedule");iconSource:"";statename:"A";rightItemsourcename:"";}
        ListElement{Listtitle: qsTr("Schedule List");iconSource:"";statename:"A";rightItemsourcename:"";}
    }

    ListModel{
        id:exceptionlistmodel

    }

    //각 디바이스의 스케쥴을 읽어와서 element 아래와 같은 형태로 넣으면 읽어올 것으로 .. 예상...
    //알맞게 어떻게 변경할까..
    ListModel{
        id:circuitmodel//date객체와 time따로 가져올 수 있을 것으로 예상..
    }

    ListModel{
        id:listschedulemodel
    }


    ListModel{
        id:hotwatermodel
    }

    ListModel{
        id:dhwheatermodel        
    }

    ListModel{
        id:dhwrecirculationmodel
    }

    ListModel{
        id: submodel
    }

    ListModel{
        id:monthmodel
        ListElement{index:"January"}
        ListElement{index:"February"}
        ListElement{index:"March"}
        ListElement{index:"April"}
        ListElement{index:"May"}
        ListElement{index:"June"}
        ListElement{index:"July"}
        ListElement{index:"August"}
        ListElement{index:"September"}
        ListElement{index:"October"}
        ListElement{index:"November"}
        ListElement{index:"December"}
    }


    ListModel{
        id:ampmmodel
        ListElement{index:"AM"}
        ListElement{index:"PM"}
    }


    property string silentStartTime : "6:00 AM"
    property string silentEndTime : "2:00 PM"
    property bool isSilentUse: false


    function silentRead(){

        var silentTimeText

        _silentStartHour=silentStartTime.split(" ")[0].split(":")[0]
        _silentStartMin=silentStartTime.split(" ")[0].split(":")[1]
        _silentStartAmpm=silentStartTime.split(" ")[1]==="AM"?0:1

        _silentEndHour=silentEndTime.split(" ")[0].split(":")[0]
        _silentEndMin=silentEndTime.split(" ")[0].split(":")[1]
        _silentEndAmpm=silentEndTime.split(" ")[1]==="AM"?0:1

        var silentStartString = _silentStartHour+":"+_silentStartMin+" "+ampmmodel.get(_silentStartAmpm).index
        var slientEndString = _silentEndHour+":"+_silentEndMin+" "+ampmmodel.get(_silentEndAmpm).index

        silentTimeText=silentStartString+" ~ "+slientEndString

        return silentTimeText
    }

    function modelRead(_device,_date){
        if (_date === undefined) {
            _date = Variables.globalTodayMonth+ "/" +Variables.globalTodayDate + "/" + Variables.globalTodayYear
        }

        //To do:날짜 입력부분 추가해서 읽어야함
        var themodelTemp
        // themodelTemp=(name==="circuit_1")?circuitmodel:(name==="circuit_hotwater")?hotwatermodel:(name==="circuit_DHW_heater")?dhwheatermodel:(name==="circuit_DHW_heater")?exceptionlistmodel:dhwrecirculationmodel
        // themodelTemp=circuitmodel

        if(isDaily===true){
            readmodelForDaily(_device,_date)
            themodelTemp=circuitmodel
        }

        else if(isDaily===false){
            readmodelForList(_device)
            themodelTemp=listschedulemodel
        }
        console.log("model's been updated.")       

        return themodelTemp
    }

    function readmodelForList(){
        //ddc_getSchedules함수에 "날짜 정보 없이" 장치 정보 보내서 데이터 읽어오기
        // var resultData = appModel.ddc_getSchedules(_device)
        //현재는 readmodelForDaily()와 동일한 데이터로 작업 -> 나중에 삭제 해야함
        var resultData=[//_read날짜 읽어와서 result date에 append
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test1",
                       "name":"My Schedule 1",
                       "time": "8:00 AM",
                       "runmode":"on",
                       "temp":"",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/20/24",//month,date,year
                       "days": [true,true,false,true,true,false,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test2",
                       "name":"My Schedule 2",
                       "time": "10:12 AM",
                       "runmode":"heat",
                       "temp":"28.5",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/18/24",//month,date,year
                       "days": [true,false,false,false,false,false,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":false,
                       "isEveryWeek":true
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test3",
                       "name":"My Schedule 3",
                       "time": "10:47 AM",
                       "runmode":"cool",
                       "temp":"18",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/18/24",//month,date,year
                       "days": [false,false,false,false,false,true,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test4",
                       "name":"My Schedule 4",
                       "time": "11:00 AM",
                       "runmode":"cool",
                       "temp":"17",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/19/24",//month,date,year
                       "days": [true,true,true,true,true,false,false],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test5",
                       "name":"My Schedule 5",
                       "time": "11:43 PM",
                       "runmode":"auto",
                       "temp":"5",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/30/24",//month,date,year
                       "days": [true,true,false,false,true,false,false],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test6",
                       "name":"My Schedule 6",
                       "time": "10:40 PM",
                       "runmode":"cool",
                       "temp":"18",
                       "startDate":"06/10/24",//month,date,year
                       "endDate":"06/30/24",//month,date,year
                       "days": [true,true,true,true,true,true,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":false,
                       "isEveryWeek":true
                    },
                    {
                        "isUse": true,
                        "isSpecial": true,
                        "id": "test7",
                        "name":"My Schedule 7",
                        "time": "11:43 PM",
                        "runmode":"auto",
                        "temp":"5",
                        "startDate":"07/07/24",//month,date,year
                        "endDate":"07/21/24",//month,date,year
                        "days": [true,false,false,false,false,false,true],
                        "weeklySchedules": ["1", "2", "3"],
                        "isPeriod":true,
                        "isEveryWeek":false
                     }
                ]
        listschedulemodel.clear()

        var hourTemp
        var minTemp
        var ampmTemp
        var repeatTextTemp

        for(var item=0;item<resultData.length;item++){
            hourTemp=resultData[item]["time"].split(" ")[0].split(":")[0]
            minTemp=resultData[item]["time"].split(" ")[0].split(":")[1]
            ampmTemp=resultData[item]["time"].split(" ")[1]

            repeatTextTemp=getRepeatText(resultData[item]["days"])

            listschedulemodel.append({hour:hourTemp
                                ,min:minTemp
                                ,ampm:ampmTemp
                                ,isUse:resultData[item]["isUse"]
                                ,name:resultData[item]["name"]
                                ,id:resultData[item]["id"]
                                ,temp:resultData[item]["temp"]
                                ,days:repeatTextTemp
                                ,isEveryWeek:resultData[item]["isEveryWeek"]
                                ,isPeriod:resultData[item]["isPeriod"]
                                ,startDate:resultData[item]["startDate"]
                                ,endDate:resultData[item]["endDate"]
                                ,runningMode:resultData[item]["runmode"]
                                })
        }
    }

    function readmodelForDaily(_device,_date){
        // var resultData = appModel.ddc_getSchedules(_device,_date)// _date에 따라서 데이터 불러오기
        var resultData=[//_read날짜 읽어와서 result date에 append
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test1",
                       "name":"My Schedule 1",
                       "time": "8:00 AM",
                       "runmode":"on",
                       "temp":"",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/20/24",//month,date,year
                       "days": [true,true,false,true,true,false,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test2",
                       "name":"My Schedule 2",
                       "time": "10:12 AM",
                       "runmode":"heat",
                       "temp":"28.5",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/18/24",//month,date,year
                       "days": [true,false,false,false,false,false,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":false,
                       "isEveryWeek":true
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test3",
                       "name":"My Schedule 3",
                       "time": "10:47 AM",
                       "runmode":"cool",
                       "temp":"18",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/18/24",//month,date,year
                       "days": [false,false,false,false,false,true,true],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test4",
                       "name":"My Schedule 4",
                       "time": "11:00 AM",
                       "runmode":"cool",
                       "temp":"17",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/19/24",//month,date,year
                       "days": [true,true,true,true,true,false,false],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    },
                    {
                       "isUse": true,
                       "isSpecial": true,
                       "id": "test5",
                       "name":"My Schedule 5",
                       "time": "11:43 PM",
                       "runmode":"auto",
                       "temp":"5",
                       "startDate":"05/10/24",//month,date,year
                       "endDate":"05/30/24",//month,date,year
                       "days": [true,true,false,false,true,false,false],
                       "weeklySchedules": ["1", "2", "3"],
                       "isPeriod":true,
                       "isEveryWeek":false
                    }
                ]
        circuitmodel.clear()
        hotwatermodel.clear()
        dhwheatermodel.clear()

        var hourlist=[]
        var uniquehourlist=[]
        var minlist=[]
        var ampmlist=[]
        var isUselist=[]
        var runningModelist=[]
        var templist=[]
        var dayslist=[]
        var idlist=[]
        var namelist=[]

        var periodlist=[]
        var everyweeklist=[]

        var startlist=[]
        var endlist=[]

        var detailtemp=[]
                // {"time":[],"min":[],"isUse":[],"runningMode":[],"temp":[],"days":[]}
        var nextindex=0

        var hourTemp
        var minTemp
        var ampmTemp
        var prehourTemp

        var repeatTextTemp

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
            idlist.push(resultData[item]["id"])
            namelist.push(resultData[item]["name"])
            startlist.push(resultData[item]["startDate"])
            endlist.push(resultData[item]["endDate"])
            periodlist.push(resultData[item]["isPeriod"])
            everyweeklist.push(resultData[item]["isEveryWeek"])

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
                              ,"id":idlist
                              ,"name":namelist
                              ,"runningMode":runningModelist
                              ,"temp":templist
                              ,"startDate":startlist
                              ,"endDate":endlist
                              ,"days":dayslist
                              ,"isPeriod":periodlist
                              ,"isEveryWeek":everyweeklist
                                })

                hourlist=[];
                uniquehourlist=[];
                minlist=[];
                ampmlist=[];
                isUselist=[];
                runningModelist=[];
                templist=[];
                dayslist=[];
                endlist=[];
                startlist=[];
                idlist=[];
                namelist=[];
                periodlist=[];
                everyweeklist=[];
            }
        }

        for(var i in detailtemp){
            circuitmodel.append({time:detailtemp[i]["time"][0],detail:[]})
            for(var j in detailtemp[i]["min"]){
                // console.log(detailtemp[i]["days"][j])
                // console.log(typeof(detailtemp[i]["days"][j]))
                repeatTextTemp=getRepeatText(detailtemp[i]["days"][j])

                circuitmodel.get(i).detail.append({hour:detailtemp[i]["hour"][j]
                                                     ,min:detailtemp[i]["min"][j]
                                                     ,ampm:detailtemp[i]["ampm"][j]
                                                     ,isUse:detailtemp[i]["isUse"][j]
                                                     ,runningMode:detailtemp[i]["runningMode"][j]
                                                     ,temp:detailtemp[i]["temp"][j]
                                                     ,id:detailtemp[i]["id"][j]
                                                     ,name:detailtemp[i]["name"][j]
                                                     ,startDate:detailtemp[i]["startDate"][j]
                                                     ,endDate:detailtemp[i]["endDate"][j]
                                                     ,isPeriod:detailtemp[i]["isPeriod"][j]
                                                     ,isEveryWeek:detailtemp[i]["isEveryWeek"][j]
                                                     /*day가 ["MON","","WED",...]가 아닌
                                                     MON 처음 기준으로  [true,false,true,...]로 들어오길 희망..*/
                                                     //
                                                     ,days:repeatTextTemp
                                                     })
            }
        }
    }

    function getRepeatText(_days){
        var dayOfWeekidx=0
        var dayOfWeekidxList=[]
        var repeatTextTemp=""

        var dayList=["sun","mon","tue","wed","thu","fri","sat"]

        for(var key=0;key<dayList.length;key++){
            if(_days[key]===true){
                dayOfWeekidxList.push(dayOfWeekidx)
                repeatTextTemp+=dayList[key]+" " //to do 변수에 qsTr할 수 있나
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
        // visible: true
        width: Variables.sourceWidth
        height: Variables.sourceHeight*0.2
        y: Variables.sourceHeight - virtualKeyboard.height
    }

    Component.onCompleted: {
        // circuitModelRead()
        var silentTextTemp=silentRead()
        mainmodel.get(4).subText=silentTextTemp
        homeListmodel=mainmodel
    }
}
