import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"

Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    signal sigReadDateSetting()

    Column{
        TitleBar{
            id:title
            left_1st_Text:qsTr("Date & Time")
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
                            //time zone설정 visible
                            break;
                        }
                        case 1:{
                            datePopupbg.visible=true
                            break;
                        }

                        case 2:{
                            timePopupbg.visible=true
                            break;
                        }

                        case 3:{
                            timeformatPopup.visible=true
                            break;
                        }
                        }
                    }

            }
        }
    }

    Rectangle{
        id:datePopupbg
        color:"#26000000"
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        MouseArea{anchors.fill:parent}
        PopupPicker{
            id:datePicker
            textfieldText: qsTr("Date")
            anchors.centerIn: parent
            state:"triple"
            secondtextZeroPadding:1;thirdtextZeroPadding:2;

            _firstdefaultIndex:Variables.globalTodayMonth
            _seconddefaultIndex:Variables.globalTodayDate-1
            _thirddefaultIndex:Variables.globalTodayYear.slice(2)

            firstmodel:monthmodel;secondmodel:31;thirdmodel:100

            secondindexOffset:true
            thirdprefix: "20"

            onSigCancelClick: {
                datePopupbg.visible=false
            }
            onSigOkClick: {
                datePopupbg.visible=false
                Variables.currentDateUpdate(thirdprefix+_thirdText,_firstText,_secondText+1)
                sigReadDateSetting()
            }
        }
    }

    Rectangle{
        id:timePopupbg
        color:"#26000000"
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        MouseArea{anchors.fill:parent}
        PopupPicker{
            id:currenttimePicker
            textfieldText:qsTr("Time")
            anchors.centerIn: parent
            midline:false
            state:"triple"
            firstmodel:12
            secondmodel:60
            thirdmodel:ampmmodel

            onSigCancelClick: {
                timePopupbg.visible=false
            }
            onSigOkClick: {
                //to do inf에 현재 시간 변경 신호 보내기 나중에 변수 설정 부분 없애기
                timePopupbg.visible=false
                hourString=_firstText
                minString=Variables.padStart(_secondText.toString(),2)
                ampmString=_thirdText

                // Variables.currentDateUpdate(thirdprefix+_thirdText,_firstText,_secondText+1)
                sigReadDateSetting()
            }
        }
    }

    PopupList{
        id:timeformatPopup
        visible:false
        scrollviewmodel:timeformatmodel
        scrollbarEnable:false
        shadowV:0
        shadowH:4
        onSigClickDelegate: {
            //inf로 setting 값 변경 신호 보내야함
            if(sendData==0){
                isAmPm=true//나중에 삭제
            }
            else if(sendData==1){
                isAmPm=false
            }
            sigReadDateSetting()
        }

        Component.onCompleted: {
            listviewSizeFit()
            for(var i=0; i < timeformatPopup.scrollviewmodel.count; i++){
                if(isAmPm===true){
                    timeformatPopup.sigSelectedDelegate(0)
                }
                else if(isAmPm===false){
                    timeformatPopup.sigSelectedDelegate(1)
                }
            }
        }
    }

    ListModel{
        id:ampmmodel
        ListElement{index:"AM"}
        ListElement{index:"PM"}
    }

    ListModel{
        id:monthmodel
        ListElement{index:qsTr("January")}
        ListElement{index:qsTr("February")}
        ListElement{index:qsTr("March")}
        ListElement{index:qsTr("April")}
        ListElement{index:qsTr("May")}
        ListElement{index:qsTr("June")}
        ListElement{index:qsTr("July")}
        ListElement{index:qsTr("August")}
        ListElement{index:qsTr("September")}
        ListElement{index:qsTr("October")}
        ListElement{index:qsTr("November")}
        ListElement{index:qsTr("December")}
    }


    ListModel{
        id:listmodel//*to do time zone설정 date Time, tiem format등 설정
        ListElement{listName:qsTr("Time Zone");statename:"B";subText:""}
        ListElement{listName:qsTr("Date");statename:"B";subText:""}
        ListElement{listName:qsTr("Time");statename:"B";subText:""}
        ListElement{listName:qsTr("Time Format");statename:"B";subText:""}
    }

    ListModel{
        id:timeformatmodel
        ListElement{listName:"AM/PM"}
        ListElement{listName:qsTr("24 Hour")}
    }

    property string country : qsTr("New York")
    property bool isAmPm: true
    // property var timeformat: ["AM/PM",qsTr("24 Hour")]

    property string currentTimeString: Variables.globalTimeString
    property string hourString:currentTimeString.split(" ")[0].split(":")[0]
    property string minString :currentTimeString.split(" ")[0].split(":")[1]
    property int ampmString:currentTimeString.split(" ")[1]==="AM"?1:0

    function convertDateString(dateString) {
        var parts = dateString.split(" ");
        if (parts.length != 3) {
            return "Invalid date format";
        }

        var month = parts[0];
        var day = parts[1].replace(",", "");
        var year = parts[2];

        // Ensure the month and day are two digits
        if (month.length === 1) {
            month = "0" + month;
        }
        if (day.length === 1) {
            day = "0" + day;
        }
        return year + "-" + month + "-" + day;
    }

    function convertTimeString(timeString) {
        var parts = timeString.split(" ");
        if (parts.length != 2) {
            return "Invalid time format";
        }

        var timePart = parts[0].split(":");
        var period = parts[1];

        if (timePart.length != 2) {
            return "Invalid time format";
        }

        var hours = parseInt(timePart[0]);
        var minutes = timePart[1];

        if (period === "PM" && hours < 12) {
            hours += 12;
        } else if (period === "AM" && hours === 12) {
            hours = 0;
        }

        var hoursString = hours < 10 ? "0" + hours : "" + hours;
        var result = hoursString + ":" + minutes;

        return result;
    }


    onSigReadDateSetting: {
        listmodel.get(0).subText = country
        listmodel.get(1).subText = Variables.globalDateString
        listmodel.get(2).subText = hourString+":"+minString+" "+ampmmodel.get(ampmString).index
        if(isAmPm){
            listmodel.get(3).subText = timeformatmodel.get(0).listName
        }
        else{
            listmodel.get(3).subText = timeformatmodel.get(1).listName
        }

        appModel.setTimeZone(listmodel.get(0).subText)

        if(isAmPm){
            var date = convertDateString(listmodel.get(1).subText)
            appModel.ddc_setDate(date)

            var time = convertTimeString(listmodel.get(2).subText)
            appModel.ddc_setTime(time)
        }
        //time format, in case 24hours, need to modify a code, osea
    }

    Component.onCompleted: {
        currenttimePicker._firstdefaultIndex=hourString
        currenttimePicker._seconddefaultIndex=minString
        currenttimePicker._thirddefaultIndex=ampmString
        sigReadDateSetting()
    }
}
