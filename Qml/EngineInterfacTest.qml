import QtQuick 2.7
import QtQuick.Controls 2.0

import EnumHMI 1.0

Rectangle {
    id:control
    anchors.fill: parent
    //color: "skyblue"

    function setDate()
    {
        var value =appModel.ddc_setDate("2024-03-27")
        console.log("set Date result :"+value)
    }

    function setTime()
    {
        var value =appModel.ddc_setTime("09:00")
        console.log("set Time result :"+value)
    }

    function readPointTest()
    {
        console.log("Get DDC readPoint Test");
        //var result = appModel.ddc_readPointValues(["0300003D", "0000013A"])
        var result = appModel.ddc_readPointValues(["0300003D"])
        for(var i =0;i<result.length; i++){
            console.log("index ="+i +" ,id ="+result[i]["id"] +" , presentValue ="+result[i]["presentValue"]+" ,correction ="+result[i]["correctionValue"]+" ,alarm ="+result[i]["alarmStatus"]+ " , OutOfService ="+result[i]["outOfService"])
        }
    }

    function readPoint2Test()
    {
        console.log("Get DDC readPoint Test");
        var result = appModel.ddc_readPointValues(["0300003D", "0000013A"])
        for(var i =0;i<result.length; i++){
            console.log("index ="+i +" ,id ="+result[i]["id"] +" , presentValue ="+result[i]["presentValue"]+" ,correction ="+result[i]["correctionValue"]+" ,alarm ="+result[i]["alarmStatus"]+ " , OutOfService ="+result[i]["outOfService"])
        }
    }

    function readPoint3Test()
    {
        console.log("Get DDC readPoint Test");
        var result = appModel.ddc_readPointValues(["00000129", "0000013A","0000013B","01000090","0400025C","01000188","010000B7","01000197","0100008F","00000138","00000139","04000004","04000009","04000006"])
        for(var i =0;i<result.length; i++){
            console.log("index ="+i +" ,id ="+result[i]["id"] +" , presentValue ="+result[i]["presentValue"]+" ,correction ="+result[i]["correctionValue"]+" ,alarm ="+result[i]["alarmStatus"]+ " , OutOfService ="+result[i]["outOfService"])
        }
    }

    function writePointTest()
    {
        console.log("write point 1 Test");
        appModel.ddc_writePointValue("0400025C", "test")
    }

    function writePointsTest()
    {
        console.log("write point n Test");

        var setData ={
            "controlPointValues":[{"id": "0400025C", "presentValue" : "1"}, {"id": "0800025C", "presentValue" : "201"}, {"id": "0900025C", "presentValue" : "301"}, {"id": "0a00025C", "presentValue" : "401"}]
        }
        appModel.ddc_writePointValues(setData)
    }

    function setScheduleTest()
    {
        console.log("Set Schdule Test");
        var scheduleData = {
           "isUse": true,
           "isSpecial": true,
           "id": "test1",
           "name": "My Schedule 1",
           "time": "10:00 AM",
           "day": ["MON", "WEN","","", "FRI","",""],
           "weeklySchedules": ["1", "2", "3"],
           "controlPointValues":[{"id": "0400025C", "presentValue" : "1"}, {"id": "0800025C", "presentValue" : "201"}]
        };

        appModel.ddc_setSchedule(scheduleData)
    }


    function addScheduleTest()
    {
        console.log("Add Schdule Test");
        var scheduleData = {
           "isUse": true,
           "isSpecial": true,
           "id": "test2",
           "name": "My Schedule 2",
           "time": "10:00 AM",
           "day": ["MON", "WEN","","", "FRI","","SUN"],
           "weeklySchedules": ["1", "2", "3"],
           "controlPointValues":[{"id": "0400025C", "presentValue" : "1"}, {"id": "0800025C", "presentValue" : "201"}]
        };
        appModel.ddc_addSchedule(scheduleData)
    }

    function deleteScheduleTest()
    {
        console.log("Delete Schdule Test")
        appModel.ddc_deleteSchedule("test1")
    }

    function getScheduleTest()
    {
        console.log("Get Schdule Test")
        var resultData = appModel.ddc_getSchedules()

        for(var i =0;i<resultData.length; i++){
            console.log("index ="+i +" ,isUse ="+resultData[i]["isUse"]+" ,isSpecial ="+resultData[i]["isSpecial"]+" ,time ="+resultData[i]["time"]+" ,id ="+resultData[i]["id"]+" ,name ="+resultData[i]["name"]+" ,timeText ="+resultData[i]["timeText"])

            //daylist
            for(var j=0;j<resultData[i]["days"].length;j++){
                console.log("days ="+ resultData[i]["days"])
            }

            //weeklySchedules
            for(var j=0;j<resultData[i]["weeklySchedules"].length;j++){
                console.log("weekly Schedules ="+ resultData[i]["weeklySchedules"])
            }

            //control point values
            for(var j=0;j<resultData[i]["controlPointValues"].length;j++){
                var controlPointValue = resultData[i]["controlPointValues"][j];
                console.log("controlPointValues[" + j + "]:");
                console.log("id =" + controlPointValue["id"]);
                console.log("presentValue =" + controlPointValue["presentValue"]);
            }

            //crontabCommands
            for(var j=0;j<resultData[i]["crontabCommands"].length;j++){
                console.log("crontabCommands ="+ resultData[i]["crontabCommands"])
            }
        }
    }

    function readAlarmHistoryAllTest()
    {
        var resultData =  appModel.ddc_readAlarmHistoryAll()
        for(var i =0;i<resultData.length; i++){
            console.log("index ="+i +" ,occurDate ="+resultData[i]["occurDate"]+" ,occurTime ="+resultData[i]["occurTime"]+" ,recoverDate ="+resultData[i]["recoverDate"]+" ,recoverTime ="+resultData[i]["recoverTime"]+" ,alarmCode ="+resultData[i]["alarmCode"]+" ,isRecovered ="+resultData[i]["isRecovered"])
        }
    }

    function readAlarmHistoryMonthTest(year, month)
    {
        var resultData =  appModel.ddc_readAlarmHistoryMonth(year, month)
        for(var i =0;i<resultData.length; i++){
            console.log("index ="+i +" ,occurDate ="+resultData[i]["occurDate"]+" ,occurTime ="+resultData[i]["occurTime"]+" ,recoverDate ="+resultData[i]["recoverDate"]+" ,recoverTime ="+resultData[i]["recoverTime"]+" ,alarmCode ="+resultData[i]["alarmCode"]+" ,isRecovered ="+resultData[i]["isRecovered"])
        }
    }

    function readAlarmHistoryPeriodTest(startDate, endDate)
    {
        var resultData =  appModel.ddc_readAlarmHistoryPeriod(startDate, endDate)
        for(var i =0;i<resultData.length; i++){
            console.log("index ="+i +" ,occurDate ="+resultData[i]["occurDate"]+" ,occurTime ="+resultData[i]["occurTime"]+" ,recoverDate ="+resultData[i]["recoverDate"]+" ,recoverTime ="+resultData[i]["recoverTime"]+" ,alarmCode ="+resultData[i]["alarmCode"]+" ,isRecovered ="+resultData[i]["isRecovered"])
        }
    }

    function clearAlarmHistoryTest(){
        if(!appModel.ddc_clearAlarmHistory())
            console.log("Fail! Clear Alar History ")
        else
            console.log("Success! Clear Alar History ")
    }

    function getActiveAlarms()
    {
        if(appModel.ddc_getActiveAlarms())
            console.log("Success ! getActive Alarms")
        else
            console.log("Fail ! getActive Alarms")
    }


    Rectangle { //temporary code
        id:ddcSampleTest
        anchors.fill: parent
        color: "white"
        //visible: false

        Button {
            width: one.width
            height: 40
            x:0
            y:0
            text: "Home Return"
            font.pixelSize: 15
            onClicked: {
                control.visible =false
            }
        }



        Rectangle {
           id: one
           width: parent.width/4
           height: parent.height
           y:100
           radius: 10
           color: "transparent"
           border.color: "skyblue"

           Column
           {
               spacing: 5

               Button {
                   width: one.width
                   height: 40
                   text: "set date"
                   font.pixelSize: 15
                   onClicked: {
                        setDate()
                   }
               }

               Button {
                   width: one.width
                   height: 40
                   text: "set time"
                   font.pixelSize: 15
                   onClicked: {
                        setTime()
                   }
               }

               Button {
                   width: one.width
                   height: 40
                   text: "readPoint 1개"
                   font.pixelSize: 15
                   onClicked:{
                       readPointTest()
                   }
               }

               Button {
                   width: one.width
                   height: 40
                   text: "readPoint 2개"
                   font.pixelSize: 15
                   onClicked:{
                       readPoint2Test()
                   }
               }

               Button {
                   width: one.width
                   height: 40
                   text: "readPoint n 개"
                   font.pixelSize: 15
                   onClicked:{
                       readPoint3Test()
                   }
               }

               Button {
                   width: one.width
                   height: 40
                   text: "writePoint 1개 "
                   font.pixelSize: 15
                   onClicked:{
                       writePointTest()
                   }
               }

               Button {
                   width: one.width
                   height: 40
                   text: "writePoint n개 "
                   font.pixelSize: 15
                   onClicked:{
                       writePointsTest()
                   }
               }


           }
        }

        Rectangle {
            id:two
            x:one.width+5
            width: parent.width/4
            height: parent.height
            y:100
            radius: 10
            color: "transparent"
            border.color: "green"

            Column
            {
                spacing: 5

                Button {
                    width: one.width
                    height: 40
                    text: "setSchedule Test"
                    font.pixelSize: 15
                    onClicked:{
                        setScheduleTest()
                    }
                }

                Button {
                    width: one.width
                    height: 40
                    text: "addSchedule Test"
                    font.pixelSize: 15
                    onClicked:{
                        addScheduleTest()
                    }
                }

                Button {
                    width: one.width
                    height: 40
                    text: "deleteSchedule Test"
                    font.pixelSize: 15
                    onClicked:{
                        deleteScheduleTest()
                    }
                }

                Button {
                    width: one.width
                    height: 40
                    text: "getSchedule Test"
                    font.pixelSize: 15
                    onClicked:{
                        getScheduleTest()
                    }
                }

                Button {
                    width: one.width
                    height: 40
                    text: "Schedule config"
                    font.pixelSize: 15
                    onClicked:{
                        //getScheduleTest()
                        schedule_popup.visible =true
                    }
                }

                Button {
                   width: two.width
                   height: 40
                   text: "ReadAlarmHistoryAll test"
                   font.pixelSize: 15
                   onClicked:{
                       readAlarmHistoryAllTest()
                   }
                }

                Button {
                   width: two.width
                   height: 40
                   text: "ReadAlarmHistoryMonth test"
                   font.pixelSize: 15
                   onClicked:{
                       readAlarmHistoryMonthTest(2024,4)

                   }
                }
                Button {
                   width: two.width
                   height: 40
                   text: "ReadAlarmHistoryPeriod test"
                   font.pixelSize: 15
                   onClicked:{
                       readAlarmHistoryPeriodTest("2024-03-01", "2024-04-01")
                   }
                }
                Button {
                   width: two.width
                   height: 40
                   text: "ClearAlarmHistory test"
                   font.pixelSize: 15
                   onClicked:{
                       clearAlarmHistoryTest()
                   }
                }

                Button {
                   width: two.width
                   height: 40
                   text: "GetActiveAlarms test"
                   font.pixelSize: 15
                   onClicked:{
                       getActiveAlarms()
                   }
                }
            }
        }
    }
    /////////////////////// Engine Interface Test




    ////////////////////// Schedule Config Set, Unit Test

    property var scheduleDataTemplate: {
        "isUse": true,
        "isSpecial": true,
        "id": "test1",
        "name": "My Schedule 1",
        "time": "10:00 AM",
        "day": ["MON", "WEN","","", "FRI","",""],
        "weeklySchedules": ["1", "2", "3"],
        "controlPointValues":[{"id": "0400025C", "presentValue" : "1"}, {"id": "0800025C", "presentValue" : "201"}]
     };


    Rectangle {
        id: schedule_popup
        anchors.fill: parent
        visible: false

        Rectangle {
            anchors.fill: parent
            color: "lightblue"

            Column {
                x:parent.x+20
                y:parent.y+20
                spacing: 8

                Row {
                    spacing: 120
                    Text {
                        text: "isUse"
                        verticalAlignment: Text.AlignBottom
                    }

                    ComboBox {
                        id: isUseValue
                        model: ["true", "false"]
                        onCurrentTextChanged: {
                            scheduleDataTemplate.isUse = currentText === "true";
                        }
                    }
                }

                Row {
                    spacing: 100
                    Text {
                        text: "isSpecial"
                        verticalAlignment: Text.AlignBottom
                    }

                    ComboBox {
                        id: isSpecialValue
                        model: ["true", "false"]
                        onCurrentTextChanged: {
                            scheduleDataTemplate.isSpecial = currentText === "true";
                        }
                    }
                }

                Row {
                    spacing: 140
                    Text {
                        text: "id"
                        verticalAlignment: Text.AlignBottom
                    }

                    Rectangle {
                        width: 100
                        height: 20
                        color: "white"

                        TextInput {
                           id: idValue
                           anchors.fill: parent
                           text: "test1"
                           cursorVisible: true
                        }

                    }
                }

                Row {
                    spacing: 120
                    Text {
                        text: "name"
                        verticalAlignment: Text.AlignBottom
                    }

                    Rectangle {
                        width: 100
                        height: 20
                        color: "white"

                        TextInput {
                           id: nameValue
                           anchors.fill: parent
                           text: "test1_name"
                           cursorVisible: true
                        }
                    }
                }

                Row {
                    spacing: 125
                    Text {
                        text: "time"
                        verticalAlignment: Text.AlignBottom
                    }

                    Rectangle {
                        width: 200
                        height: 20
                        color: "white"

                        TextInput {
                           id: timeValue
                           anchors.fill: parent
                           text: "10:00"
                           cursorVisible: true
                        }

                    }
                }

                Row {
                    spacing: 130
                    Text {
                        text: "day"
                        verticalAlignment: Text.AlignBottom
                    }

                    Rectangle {
                        width: 400
                        height: 20
                        color: "white"

                        TextInput {
                           id: daysValue
                           anchors.fill: parent
                           text: "[\"MON\", \"TUE\",\"WEN\",\"THU\", \"FRI\",\"SAT\",\"SUN\"]"
                           cursorVisible: true
                        }

                    }
                }

                Row {
                    spacing: 114
                    Text {
                        text: "weekly"
                        verticalAlignment: Text.AlignBottom
                    }

                    Rectangle {
                        width: 400
                        height: 20
                        color: "white"

                        TextInput {
                           id: weeklysValue
                           anchors.fill: parent
                           text: "[\"1\", \"2\", \"3\", \"4\", \"5\", \"6\", \"7\"]"
                           cursorVisible: true
                        }

                    }
                }

                Row {
                    spacing: 84
                    Text {
                        text: "controlpoint"
                        verticalAlignment: Text.AlignBottom
                    }

                    Rectangle {
                        width: 600
                        height: 20
                        color: "white"

                        TextInput {
                           id: controlPointsValue
                           anchors.fill: parent
                           text: "[{\"id\": \"0400025C\", \"presentValue\" : \"1\"}, {\"id\": \"0800025C\", \"presentValue\" : \"201\"}]"
                           cursorVisible: true
                           horizontalAlignment: TextInput.AlignLeft
                        }
                    }
                }
            }
        }

        Rectangle {
            x:10
            y:parent.height-300
            width: parent.width -20
            height: 230
            color: "white"

            ListView {
                anchors.fill: parent
                model: ListModel {
                    id:scheduleModel
                }

                delegate: Item {
                    width: ListView.view.width
                    height: 40
                    Text {
                        text: "index :"+model.index +
                              ", id :"+model.id +
                              ", name :"+model.name +
                              ", isUse :"+model.isUse +
                              ", isSpecial :"+model.isSpecial +
                              ", time :"+model.time
                    }
                }
            }
        }

        Button {
            id: returnButton
            x:0
            y:parent.height-50
            width: 100
            height: 50
            text:"return "
            onClicked: {
                schedule_popup.visible = false
            }
        }

        Button {
            id: setButton
            x:returnButton.width+returnButton.x+10
            y:parent.height-50
            width: 100
            height: 50
            text:"Set/Add "
            onClicked: {
                scheduleDataTemplate.id = idValue.text
                scheduleDataTemplate.name = nameValue.text
                scheduleDataTemplate.time = timeValue.text

                var dayJsonString = daysValue.text
                var dayParsedJson = JSON.parse(dayJsonString)
                scheduleDataTemplate.day = dayParsedJson

                var weekJsonString = weeklysValue.text
                var weekParsedJson = JSON.parse(weekJsonString)
                scheduleDataTemplate.weeklySchedules = weekParsedJson

                var jsonString = controlPointsValue.text
                var parsedJson = JSON.parse(jsonString)
                scheduleDataTemplate.controlPointValues = parsedJson


                appModel.ddc_setSchedule(scheduleDataTemplate)

                console.log("### = "+JSON.stringify(scheduleDataTemplate))
            }
        }

        Button {
            id: getButton
            x:setButton.width+setButton.x+10
            y:parent.height-50
            width: 100
            height: 50
            text:"Get "
            onClicked: {

                scheduleModel.clear()

                //getScheduleTest() //clear 정상동작 체크, log 확인

                var resultData = appModel.ddc_getSchedules()

                //Listview update
                for(var i =0;i<resultData.length; i++){
                    console.log("index ="+i +" ,isUse ="+resultData[i]["isUse"]+" ,isSpecial ="+resultData[i]["isSpecial"]+" ,time ="+resultData[i]["time"]+" ,id ="+resultData[i]["id"]+" ,name ="+resultData[i]["name"]+" ,timeText ="+resultData[i]["timeText"])
                    scheduleModel.append({
                             "index": i,
                             "id": resultData[i]["id"],
                             "name": resultData[i]["name"],
                             "isUse": resultData[i]["isUse"],
                             "isSpecial": resultData[i]["isSpecial"],
                             "time": resultData[i]["time"],
                             "days": resultData[i]["day"],
                             "controlP": resultData[i]["controlPointValues"]
                       })
                }

            }
        }

        Button {
            id: deleteButton
            x:getButton.width+getButton.x+10
            y:parent.height-50
            width: 100
            height: 50
            text:"Delete "
            onClicked: {
                scheduleModel.clear()
                appModel.ddc_deleteSchedule(deleteValue.text)

                var resultData = appModel.ddc_getSchedules()

                //Listview update
                for(var i =0;i<resultData.length; i++){
                    console.log("index ="+i +" ,isUse ="+resultData[i]["isUse"]+" ,isSpecial ="+resultData[i]["isSpecial"]+" ,time ="+resultData[i]["time"]+" ,id ="+resultData[i]["id"]+" ,name ="+resultData[i]["name"]+" ,timeText ="+resultData[i]["timeText"])
                    scheduleModel.append({
                             "index": i,
                             "id": resultData[i]["id"],
                             "name": resultData[i]["name"],
                             "isUse": resultData[i]["isUse"],
                             "isSpecial": resultData[i]["isSpecial"],
                             "time": resultData[i]["time"],
                             "days": resultData[i]["day"],
                             "controlP": resultData[i]["controlPointValues"]
                       })
                }
            }
        }

        Row {
            x:deleteButton.width+deleteButton.x+30
            y:parent.height-50
            width: 300
            height: 50
            spacing: 10

            Text {
                text: "delete ID"
            }

            Rectangle {
                width: 100
                height: 20
                color: "white"

                TextInput {
                   id: deleteValue
                   anchors.fill: parent
                   text: "test1"
                   cursorVisible: true
                }
            }
        }
    }

}
