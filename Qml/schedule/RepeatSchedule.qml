import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle{
    id: root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    property var _dayOfWeek:{ "sun": true, "mon": true, "tue": true, "wed": true, "thu": true, "fri": true, "sat": true }
    //default date
    property string startDateString: _startMonth+" "+_startDate+", "+_startYear
    property string endDateString: _endMonth+" "+_endDate+", "+_endYear

    property string _startYear: ""
    property string _startMonth: ""
    property string _startDate: ""

    property string _endYear: ""
    property string _endMonth: ""
    property string _endDate: ""


    property var _startDateList:{"month":_startMonth,"date":_startDate,"year":_startYear}
    property var _endDateList:{"month":_endMonth,"date":_endDate,"year":_endYear}

    signal sigBackClickRepeatSchedule(/*var _dayOfWeek,*/var _startDateList,var _endDateList)
    MouseArea{anchors.fill:parent}

    Column{
        TitleBar{
            id:titleBar
            left_1st_Text:qsTr("Repeat Schedule")
            onSigLClickTitleBar: {
                sigBackClickRepeatSchedule(/*_dayOfWeek,*/_startDateList,_endDateList)
            }
        }
        Rectangle{
            id:daycontentmold
            width:root.width;height:75
            Column{
                leftPadding:20;topPadding: 8;spacing:8

                Text{
                    text:qsTr("Day")
                    color:"#222222"
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 14
                }

                Rectangle{
                    id:daymold
                    width:440;
                    height:28
//                    opacity:"#26B2EBF4"
                    color:"transparent"
                    border.width: 6
                    border.color: "#F5B2EBF4"
                    clip:true
                    radius:6;

                    Row{
                        width:440;height:28
                        spacing: 1
                        Repeater{
                            id:repeater
                            model:["sun","mon","tue","wed","thu","fri","sat"]
                            Rectangle{
                                id:dateDelegate
                                property bool colorFlag:true
                                color:colorFlag===true?"#222222":"#DEE1E5"
                                width:62;height:28
                                Text{
                                    width:23;height:14
                                    color:colorFlag===true?"#FFFFFF":"#222222"
                                    text:qsTr(modelData.charAt(0).toUpperCase()+modelData.slice(1))
                                    anchors.centerIn: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: 14
                                }
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked: {
                                        dateDelegate.colorFlag=!(dateDelegate.colorFlag)
                                        _dayOfWeek[modelData]=dateDelegate.colorFlag;
                                        for (var key in _dayOfWeek) {
                                            if (!_dayOfWeek[key]) {repeatOpt.rightToggleInit()}
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            id:bottomline
            width:root.width;height:1;color:"#DEE1E5"
        }

        List{
            id:repeatOpt
            state:"E"
            left_1st_Text:qsTr("Repeat")
            mouseEnable:false
            radioLtext:qsTr("Every Week")
            radioRtext:qsTr("Set Period")
            radioExclusive:false
            onSigradioLClick: {
                for (var key in _dayOfWeek) {
                    _dayOfWeek[key] = true;
                }
                for (var i = 0; i < repeater.count; ++i) {
                    var rect=repeater.itemAt(i)
                    rect.colorFlag=true
                }
            }
            onSigradioRClick: {
                _startYear=Variables.globalTodayYear
                _startMonth=monthmodel.get(Variables.globalTodayMonth).index.slice(0,3)
                _startDate=Variables.globalTodayDate

                _endYear=Variables.globalTodayYear7
                _endMonth=monthmodel.get(Variables.globalTodayMonth7).index.slice(0,3)
                _endDate=Variables.globalTodayDate7

                startdatePicker.sigSetDefaultIndex(Variables.globalTodayMonth,_startDate-1,_startYear)
                enddatePicker.sigSetDefaultIndex(Variables.globalTodayMonth7,_endDate-1,_endYear)

                repeatOptcontent.visible=true
            }

            onSigradioROff: {
                repeatOptcontent.visible=false
            }
        }

        Rectangle{
            id:repeatOptcontent
            visible:false
            width:root.width;height:96
            Row{
                topPadding:20
                leftPadding:40
                spacing:50
                Row{
                    spacing:12
                    Text{
                        width:72;height:16
                        font.pixelSize: 16
                        text:qsTr("Start Date")
                        color:"#555555"
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    TextButton{
                        width:95;height:30
                        imagename:"date"
                        textBoxW:75;textBoxH:14
                        fontsize:14
                        btntext:startDateString
                        onSigClick: {
                            startdatePopupbg.visible=true
                        }
                    }
                }

                Row{
                    spacing:10
                    Text{
                        width:64;height:16
                        font.pixelSize: 16
                        text:qsTr("End Date")
                        color:"#555555"
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    TextButton{
                        width:95;height:30
                        imagename:"date"
                        textBoxW:75;textBoxH:14
                        fontsize:14
                        btntext:endDateString
                        onSigClick: {
                            enddatePopupbg.visible=true
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id:startdatePopupbg
        color:"#26000000"
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        MouseArea{anchors.fill:parent}
        PopupPicker{
            id:startdatePicker
            anchors.centerIn: parent
            textfieldText: qsTr("Start Date")
            state:"triple"
            secondtextZeroPadding:1;thirdtextZeroPadding:2;

            _firstdefaultIndex:Variables.globalTodayMonth
            _seconddefaultIndex:Variables.globalTodayDate-1
            _thirddefaultIndex:Variables.globalTodayYear.slice(2)

            firstmodel:monthmodel;secondmodel:31;thirdmodel:100

            secondindexOffset:true
            thirdprefix: "20"

            onSigCancelClick: {
                startdatePopupbg.visible=false
            }
            onSigOkClick: {
                startdatePopupbg.visible=false

                _startMonth=monthmodel.get(_firstText).index.slice(0,3);
                _startDate=_secondText+1;
                _startYear=thirdprefix+_thirdText;
                //first --third text를 받아서 데이터 저장 날짜를 저장-> 이를 뒤로가기 누르면 add schedule의 변수 데이터에 저장함-> 이를 done누르면 model에 작성
            }
        }
    }

    Rectangle{
        id:enddatePopupbg
        color:"#26000000"
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        MouseArea{anchors.fill:parent}
        PopupPicker{
            id:enddatePicker
            textfieldText: qsTr("End Date")
            anchors.centerIn: parent
            state:"triple"
            secondtextZeroPadding:1;thirdtextZeroPadding:2;

            _firstdefaultIndex:Variables.globalTodayMonth7
            _seconddefaultIndex:Variables.globalTodayDate7-1
            _thirddefaultIndex:Variables.globalTodayYear7.slice(2)

            firstmodel:monthmodel;secondmodel:31;thirdmodel:100

            secondindexOffset:true
            thirdprefix: "20"

            onSigCancelClick: {
                enddatePopupbg.visible=false
            }
            onSigOkClick: {
                enddatePopupbg.visible=false
                _endMonth=monthmodel.get(_firstText).index.slice(0,3);
                _endDate=_secondText+1;
                _endYear=thirdprefix+_thirdText;
            }
        }
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

    Component.onCompleted: {
        for (var key in _dayOfWeek) {
            _dayOfWeek[key] = true;
        }
    }

    function initRepeatSchedule(){
        for (var i = 0; i < repeater.count; ++i) {
            var rect=repeater.itemAt(i)
            rect.colorFlag=true
        }
        for (var key in _dayOfWeek) {
            _dayOfWeek[key] = true;
        }

        _startYear=""
        _startMonth=""
        _startDate=""

        _endYear=""
        _endMonth=""
        _endDate=""

        repeatOpt.siginitchecked()

    }
}
