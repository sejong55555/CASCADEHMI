import QtQuick 2.7
import "../Global"
import "../Common"

Rectangle{
    id:root

    width:Variables.sourceWidth
    height:Variables.sourceHeight

    property bool isEmptymodel: true
    property real newAlarmCount:0

    Column{
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        TitleBar{
            id:title
            state:"B"
            left_1st_Text: qsTr("Notification")

            onSigRClickTitleBar: {
                initilizingConfirmBg.visible=true
            }
            onSigLClickTitleBar: {
                root.visible=false
            }
        }
        Item{
            width:Variables.sourceWidth
            height:Variables.sourceHeight-title.height
            Rectangle{
                id:emptymodel
                visible:isEmptymodel
                width:parent.width
                height:parent.height
                Text{
                    x:40
                    y:100
                    width:400
                    height:20
                    font.pixelSize: 20
                    text:qsTr("No notifications received")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            ListView{
                id:view
                clip:true
                visible:!isEmptymodel
                width:parent.width
                height:parent.height
                model:notificationmodel
                delegate:notidelegate
            }
        }
    }

    Component{
        id:notidelegate
        Rectangle{
            width:Variables.sourceWidth
            height:72
            Column{
                leftPadding:20
                topPadding:10
                spacing:6
                Row{
                    spacing:4
                    width:143+20
                    height:16
                    Text{
                        id:firstTextBox
                        clip:true
                        width:143
                        height:16
                        color:"#555555"
                        font.pixelSize: 16
                        text:occurMonth+" "+occurDate+", "+occurYear +" " +occurTime
                    }
                    Image{
                        anchors.verticalCenter: firstTextBox.verticalCenter
                        width:16;
                        height:16
                        visible:isNew
                        source:Variables.sourcePath+"ic_tag_new.png"
                    }
                }
                Column{
                    spacing:2
                    Text{
                        width:143
                        height:14
                        color:"#555555"
                        font.pixelSize: 14
                        text:qsTr("Facility")+" : "+facility
                    }
                    Text{
                        width:143
                        height:14
                        color:"#555555"
                        font.pixelSize: 14
                        text:qsTr("Error Code")+": "+errorcode
                    }
                }

            }
            Rectangle{
                id:dividerline
                y:71
                width:parent.width
                height:1
                color:"#D9D9D9"
            }
        }
    }

    ListModel{
        id:notificationmodel
    }

    function notiRead(){
        var newAlarmFlag
        newAlarmCount=0

        notificationmodel.clear()
        // var resultData = appModel.readAlarmHistoryAllTest()// _date에 따라서 데이터 불러오기
        var resultdata=[
                    {   "index":"0",
                        "occurDate":"12/08/2019",
                        "occurTime":"1:01 AM",
                        "facility":"Hot Water",
                        "alarmCode":"-1",
                        "isRecovered":true

                    },

                    {   "index":"1",
                        "occurDate":"12/08/2019",
                        "occurTime":"1:01 AM",
                        "facility":"Hot Water",
                        "alarmCode":"-1",
                        "isRecovered":true
                    },

                    {   "index":"2",
                        "occurDate":"12/08/2019",
                        "occurTime":"1:01 AM",
                        "facility":"Hot Water",
                        "alarmCode":"-1",
                        "isRecovered":false
                    }
                ]

        var monthString
        var yearString
        var dateString

        var hourString
        var minString
        var ampmString

        for(var item=0;item<resultdata.length;item++){
            monthString=monthmodel.get(resultdata[item]["occurDate"].split("/")[0]-1).index.slice(0,3)
            dateString=Number(resultdata[item]["occurDate"].split("/")[1])
            yearString=resultdata[item]["occurDate"].split("/")[2]

            if(resultdata[item]["isRecovered"]===false){
                newAlarmCount++
            }

            notificationmodel.append({id:resultdata[item]["index"],
                                      occurMonth:monthString,
                                      occurDate:dateString,
                                      occurYear:yearString,
                                      occurTime:resultdata[item]["occurTime"],
                                      facility:resultdata[item]["facility"], //이런건 다국어 지원을 어떻게 할지 ....
                                      errorcode:resultdata[item]["alarmCode"],
                                      isNew:!resultdata[item]["isRecovered"]
                                     }
                                     )

        }


        if(notificationmodel.count===0){
            title.state="A"
            isEmptymodel=true
        }
        else if(notificationmodel.count!==0){
            title.state="B"
            isEmptymodel=false
        }

    }

    PopupToast{
        id:popuptoastComponent
        visible:false
        // textstring:qsTr("Notification has been initialized.")
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
            x:20;y:20
            id:initializeConfirmPopup
            state:"2line"
            textBox:qsTr("All notification data will be reset.\nAre you sure you want to initialize?")
            firstbtnText:qsTr("Cancel")
            secondbtnText:qsTr("Initialize")
            onSigLClick: {
                initilizingConfirmBg.visible=false
                console.log("cancel btn Clicked!")
            }
            onSigRClick: {
                initilizingConfirmBg.visible=false
                console.log("initialize btn Clicked!")
                notificationmodel.clear()//나중에 삭제 해야함 다 지워졌다고 가정
                title.state="A"
                newAlarmCount=0
                isEmptymodel=true
                popuptoastComponent.textstring=qsTr("Notification has been initialized.")
                popuptoastComponent.visible=true
                popuptoastComponent.sigFadeStart()
                console.log("notificationmodel.count:::"+(notificationmodel.count===0))


                // if(!appModel.ddc_clearAlarmHistory()){ //나중에 활성화시키기
                //     popuptoastComponent.textstring=qsTr("Fail! Clear Alar History ")
                // }
                // else{
                //     notiRead()//reroad notice data
                //     popuptoastComponent.textstring=qsTr("Notification has been initialized.")
                //     popuptoastComponent.visible=true
                //     popuptoastComponent.sigFadeStart()
                // }
            }
        }
    }

    Monthmodel{
        id:monthmodel
    }
    Ampmmodel{
        id:ampmmodel
    }

    Component.onCompleted: {
        notiRead()
    }
}
