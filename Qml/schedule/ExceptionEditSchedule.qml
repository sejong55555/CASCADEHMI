import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"
Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    property string startDateString: _startMonth+" "+_startDate+", "+_startYear
    property string endDateString: _endMonth+" "+_endDate+", "+_endYear

    property string forDiffStart:""
    property string forDiffEnd:""

    property string _titleText: ""

    property string _startYear: ""
    property string _startMonth: ""
    property string _startDate: ""

    property string _endYear: ""
    property string _endMonth: ""
    property string _endDate: ""

    property string _repeatopt: ""

    property string _popuptoastText: ""
    property bool activationToggleFlagEx: true
    signal sigBackClickExEdit()
    signal sigDoneClickExEdit(string _title,string _stYear,string _stMonth,string _stDate,string _endYear,string _endMonth,string _endDate,string _repeat)

    function opacityInitEx(_opacityValue){
        var enabledFlag
        var dimFlag

        if(_opacityValue===0.3){
            enabledFlag=false
            dimFlag="d"
        }
        else{
            enabledFlag=true
            dimFlag="n"
        }
        title.opacity=_opacityValue
        repeat.opacity=_opacityValue
        datesetting.opacity=_opacityValue

        title.sigComponentEnable(enabledFlag)
        repeat.sigComponentEnable(enabledFlag)
        startDeteBtn.imagestate=dimFlag
        endDeteBtn.imagestate=dimFlag
    }

    function initScheduleActEx(){
        activationToggleFlagEx=true
        scheduleActoptionEx.titleToggleInit(true)
        opacityInitEx(1)
    }

    Column{
        anchors.fill:parent
        TitleBar{
            id:titleBar
            left_1st_Text:qsTr("Edit Exception Day")
            state:"C"
            onSigLClickTitleBar: {
                initScheduleActEx()
                title.sigTextFieldFocus()
                initEx()
                sigBackClickExEdit()
            }
        }
        Flickable{
            // width:480;height:272
            width:Variables.sourceWidth+300;height:Variables.sourceWidth-titleBar.height
            contentHeight: listcol.height
            clip:true
            Column{
                id:listcol
                height:title.height+repeat.height+datesetting.height+scheduleActoptionEx.height
                List{
                    id:scheduleActoptionEx
                    left_1st_Text:qsTr("Schedule Activation")
                    state:"C"
                    imagename:"on"
                    onSigClick: {
                        title.sigTextFieldFocus()
                    }
                    onSigtoggleOff: {
                        activationToggleFlagEx=false
                        opacityInitEx(0.3)
                    }
                    onSigtoggleOn: {
                        activationToggleFlagEx=true
                        opacityInitEx(1)
                    }
                }
                List{
                    id:title
                    left_1st_Text:qsTr("Title")
                    state:"F"
                    // mouseEnable:opacity===0.3?false:true
                    custumText1:qsTr("Holiday")
                    custumText2:qsTr("Holiday")
                    onSigClick: {
                        title.sigTextFieldFocus()
                    }
                }
                List{
                    id:repeat
                    left_1st_Text:qsTr("Repeat")
                    state:"E"
                    textBoxspacing:64
                    mouseEnable:opacity===0.3?false:true
                    radioLtext:qsTr("Every Year")
                    radioRtext:qsTr("Once")
                    radioLBoxW:106
                    radioRBoxW:67
                    radioExclusive:true
                    rightTextBoxClip:false
                    Component.onCompleted: {siginitchecked()}
                    onSigClick: {
                        title.sigTextFieldFocus()
                    }
                    onSigradioLClick: {
                        //*to do _repeatOpt변경
                        title.sigTextFieldFocus()
                    }
                    onSigradioRClick: {
                        title.sigTextFieldFocus()
                    }
                }
                Rectangle{
                    id:datesetting
                    // visible:false
                    width:root.width;height:96
                    Text{
                        id:datesettingTextBox
                        width:183;height:18
                        x:20;y:19
                        text:qsTr("Date Settings")
                        font.pixelSize: 18
                        verticalAlignment: Text.AlignVCenter
                        color:"#222222"
                    }
                    Row{
                        topPadding:49
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
                                id:startDeteBtn
                                width:95;height:30
                                imagename:"date"
                                textBoxW:75;textBoxH:14
                                fontsize:14
                                btntext:startDateString
                                onSigClick: {
                                    title.sigTextFieldFocus()
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
                                id:endDeteBtn
                                width:95;height:30
                                imagename:"date"
                                textBoxW:75;textBoxH:14
                                fontsize:14
                                btntext:endDateString
                                onSigClick: {
                                    title.sigTextFieldFocus()
                                    enddatePopupbg.visible=true
                                }
                            }
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

                _startMonth=monthmodel.get(_firstText).index.slice(0,3);
                _startDate=_secondText+1;
                _startYear=thirdprefix+_thirdText;

                forDiffStart=Number(_startYear+_firstText+_startDate)

                if(forDiffStart>forDiffEnd){
                    popuptoastText=qsTr("End Date has to be later than Start Date.")
                    popuptoastComponent.visible=true
                    popuptoastComponent.sigFadeStart()
                }
                else{
                    startdatePopupbg.visible=false
                }
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
                _endMonth=monthmodel.get(_firstText).index.slice(0,3);
                _endDate=_secondText+1;
                _endYear=thirdprefix+_thirdText;

                forDiffEnd=Number(_endYear+_firstText+_endDate)

                if(forDiffStart>forDiffEnd){
                    popuptoastText=qsTr("End Date has to be later than Start Date.")
                    popuptoastComponent.visible=true
                    popuptoastComponent.sigFadeStart()
                }
                else{
                    enddatePopupbg.visible=false
                }
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
        initEx()
    }

    function initEx(){
        _startYear=Variables.globalTodayYear
        _startMonth=monthmodel.get(Variables.globalTodayMonth).index.slice(0,3)
        _startDate=Variables.globalTodayDate

        _endYear=Variables.globalTodayYear7
        _endMonth=monthmodel.get(Variables.globalTodayMonth7).index.slice(0,3)
        _endDate=Variables.globalTodayDate7

        startdatePicker.sigSetDefaultIndex(Variables.globalTodayMonth,_startDate-1,_startYear)
        enddatePicker.sigSetDefaultIndex(Variables.globalTodayMonth7,_endDate-1,_endYear)

        forDiffStart=Number(_startYear+Variables.globalTodayMonth+_startDate)
        forDiffEnd=Number(_endYear+Variables.globalTodayMonth7+_endDate)

        title.sigTextFieldInit()
        repeat.siginitchecked()
    }
}
