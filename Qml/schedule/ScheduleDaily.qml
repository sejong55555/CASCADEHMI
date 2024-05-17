import QtQuick 2.7
import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle{
    id:root
    width: Variables.sourceWidth;height: Variables.sourceHeight
    property alias titleIconSource: title.icon_source

    property string _popuptoastText

    property var themodel

    property var locale: Qt.locale()
    property date currentDate: new Date(Variables.globalCurrentDate)
    property string dateString

    property bool detailVisible: false
    property var _detailModel

    property string imagestateTemp: "_n"

    property string _hour: ""
    property string _min: ""
    property string _ampm: ""
    // property string _repeat: ""

    property bool _isUse
    property bool _isPeriod
    property bool _isEveryWeek

    property string _startDate: ""
    property string _endDate: ""

    property string _runmode: ""
    property string _temp: ""

    property var _days
    property real _currentIndex

    property string _id
    property string _name

    signal sigrightItemClickDaily()
    signal sigbackClickDaily()
    signal sigeditClickDaily()

    Column{
        id: columnLayout
        TitleBar{
            id:title
            left_1st_Text:qsTr("Daily Schedule")
            state:"F"
            // rightItem_source: TitleBarButton{}

            onSigRClickTitleBar: {
                sigrightItemClickDaily()
            }
            onSigLClickTitleBar: {
                sigbackClickDaily()
            }
        }

        Rectangle{
            id:contentmold
            width:root.width;height:root.height-title.height;
            Column{
                id:col2
                width:root.width;height:root.height-title.height;
                Row{
                    width:parent.width;height:44
                    topPadding: 5;leftPadding: 136
                    spacing:15
                    TitleBarButton{
                        id:leftbtn;
                        width:32;height:32;
                        imagename: "schedule_next_left";
                        onSigClick:{
                            //*to do datestring에 따라서 schedule 불러와야함
                            var tempDate = new Date(currentDate)
                            tempDate.setDate(tempDate.getDate() - 1)
                            currentDate = tempDate
                            dateString = currentDate.toLocaleDateString(locale,"ddd, MMM dd, yyyy"); //data참조해서 db에서 scheduler가져와야함 ~
                        }
                    }
                    Textmold{
                        id:datemold
                        width:115;height:16
                        y:8
                        textfieldWidth:width;textfieldHeight:16
                        textfieldClip:false
                        fontsize: 16
                        textfieldText:dateString
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        shadowEnable: false
                        textshadowEnable: false
                        Component.onCompleted: {
                            textFieldAlign()
                        }
                    }
                    TitleBarButton{
                        id:rightbtn;
                        width:32;height:32;
                        imagename: "schedule_next_right"
                        onSigClick:{
                            var tempDate = new Date(currentDate)
                            tempDate.setDate(tempDate.getDate() + 1)
                            currentDate = tempDate
                            dateString = currentDate.toLocaleDateString(locale,"ddd, MMM dd, yyyy"); //data참조해서 db에서 scheduler가져와야함 ~
                            //modelread() data 정보 보내기 edit set 까지
                        }
                    }
                }
                Column{
                    id:timemold
                    width:contentmold.width;height:69;
                    spacing:22
                    ListView{
                        id:clock
                        width:contentmold.width;height:14
                        leftMargin: 14;rightMargin: 14;
                        spacing:16
                        orientation:Qt.Horizontal
                        model:9
                        delegate:Textmold{
                            id:textDelegate
                            property string tempText
                            width:36;height:14;fontsize:14;fontcolor:"#999999"
                            textfieldWidth:36;textfieldHeight:14;
                            textfieldText:textDelegate.tempText
                            // textfieldText:(index*3).toString().padStart(2, '0')
                            shadowEnable: false
                            textshadowEnable: false
                            horizontalAlignment:Text.AlignHCenter
                            Component.onCompleted: {
                                if((index*3).toString().length<2){
                                    textDelegate.tempText="0"+(index*3).toString()
                                    textfieldText=textDelegate.tempText
                                }
                                else{
                                    textDelegate.tempText=(index*3).toString()
                                    textfieldText=textDelegate.tempText
                                }
                                // console.log((index*3).toString().padStart(2, '0'));
                            }
                        }
                    }
                    Image{
                        id:timeline
                        width:432;height:4;
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                        }
                        source:Variables.sourcePath+"img_schedule_timeline.png"
                        ListView{
                            id:iconline
                            y:-16
                            width:432+32;height:32;
                            model:themodel
                            delegate: titleIconSource==="circuit_1"?scheduleicon:indexImage

                            Component.onCompleted: {
                                iconline.currentIndex=-1
                            }
                        }
                    }
                }

                Row{
                    id:descriptionDefault
                    leftPadding: 144;topPadding:29
                    spacing:6
                    Image{
                        id:infoIcon
                        width:14;height:width
                        source:Variables.sourcePath+"ic_schedule_notice.png"
                    }
                    Text{
                        id:infoText
                        width:173;height:14
                        color:"#555555"
                        font.pixelSize: 14
                        font.letterSpacing:-0.39
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text:themodel.count===0?qsTr("Tap ‘+’ button to add schedule."):qsTr("Tab the timeline to edit schedule.")//when model data conut 0
                    }
                }
            }
        }
    }
    Rectangle{
        id: detailmold
        color:"#F3F3F3"
        y:165
        visible:detailVisible
        width: Variables.sourceWidth;height:108

        // SwipeView{
        ListView{
            id:detailView
            clip:true
            width:480;height:107
            cacheBuffer :1
            snapMode :ListView.SnapOneItem
            orientation: ListView.Horizontal
            model: _detailModel
            delegate: Item{
                id:delegate
                width:480;height:107
                property string daysText
                property string split
                IconTextButton{
                    id:iconTextBox
                    y:7
                    btnORicon:runningMode==="off"||runningMode==="on"?"btn_":"ic_"
                    imagestate:runningMode==="off"||runningMode==="on"?"_n":""
                    width:iconWidth+textIcondistance+textBoxWidth;height:iconHeight
                    leftSpacing:183
                    iconWidth:24;iconHeight:iconWidth
                    textBoxWidth:37;textBoxHeight:18;fontsize:18
                    textIcondistance:4
                    horizontalAlignment:Text.AlignHCenter
                    iconImageName:"schedule_"+runningMode
                    textLabel:qsTr(runningMode.charAt(0).toUpperCase()+runningMode.slice(1));
                }
                Text{
                    width:44;height:21
                    x:252;y:9
                    font.pixelSize: 18
                    color:"#222222"
                    text:temp===""?"":temp+"°"
                }
                Text{
                    id:dateBox
                    width:250;height:14
                    font.pixelSize:14
                    x:115;y:35
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:hour+":"+min +" "+ampm+split+daysText
                }
                Component.onCompleted: {
                // days list 추가 한 후에 read
                    // daysText=getRepeatText(days)
                    daysText=days
                    if(daysText!=""){split=", "}
                    else{split=""}
                }
            }
            // }
            onCurrentIndexChanged: {
                _hour = _detailModel.get(currentIndex).hour
                _min = _detailModel.get(currentIndex).min
                _runmode = _detailModel.get(currentIndex).runningMode
                _temp = _detailModel.get(currentIndex).temp
                _ampm = _detailModel.get(currentIndex).ampm
                _isUse = _detailModel.get(currentIndex).isUse

                _id = _detailModel.get(currentIndex).id
                _name = _detailModel.get(currentIndex).name

                _startDate = _detailModel.get(currentIndex).startDate
                _endDate = _detailModel.get(currentIndex).endDate
                _days = _detailModel.get(currentIndex).days
                _isPeriod = _detailModel.get(currentIndex).isPeriod
                _isEveryWeek = _detailModel.get(currentIndex).isEveryWeek

                _currentIndex = currentIndex

                editSchedule.seteditSchedule(_hour,_min,_ampm,_runmode,_temp,_days,_isUse,_isEveryWeek,_isPeriod,_startDate,_endDate,_id,_name)
            }
        }
        TextButtonRow{
            x:117;y:61
            firstbtnText:qsTr("Delete")
            secondbtnText:qsTr("Edit")
            firstimageName:"schedule_gray";firstfontcolor:"#FFFFFF"
            secondimageName:"cmd_orange"
            onSigRowLClickIn: {
                deletePopup.visible=true
            }

            onSigRowRClickIn: {
                editSchedule.seteditSchedule(_hour,_min,_ampm,_runmode,_temp,_days,_isUse,_isEveryWeek,_isPeriod,_startDate,_endDate,_id,_name)
                sigeditClickDaily()
            }
        }
        Row{
            leftPadding:16;
            topPadding:37;
            spacing:384
            TitleBarButton{
                id:leftarrowbtn;
                width:32;height:width;
                imagename:"schedule_left";
                onSigClick: {
                    detailView.decrementCurrentIndex()
                }
            }
            TitleBarButton{
                id:rightarrowbtn;
                width:32;height:width;
                imagename:"schedule_right"
                onSigClick: {detailView.incrementCurrentIndex()}
            }
        }
    }

    Component{
        id:scheduleicon
        Image{
            property string _imagestate: ListView.isCurrentItem?"_s":"_d"
            source:Variables.sourcePath+"btn_schedule_"+detail.get(0).runningMode+_imagestate+".png"
            width:32;height:width
            x:time*18-16;
            anchors.verticalCenter: parent.verticalCenter
            Text{
                id:tempTextBox
                visible:detail.get(0).runningMode==="temp"?true:false
                color:"#FFFFFF"
                text:detail.get(0).temp+"°"
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    detailVisible = true;
                    _detailModel = detail
                    iconline.currentIndex=index
                }
            }
        }
    }

    Component{
        id:indexImage
        Rectangle{
            width:32;height: width;radius:30;
            color:ListView.isCurrentItem?"gray":"#CFCFCF"
            border.color: "#222222"
            border.width: ListView.isCurrentItem?2:0
            x:time*18-16;
            anchors.verticalCenter: parent.verticalCenter
            Text{
                anchors.fill:parent
                color:"#FFFFFF"
                text:index
                anchors.centerIn: parent.Center
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    detailVisible=true;
                    _detailModel = detail
                    iconline.currentIndex=index
                }
            }
        }
    }

    Component.onCompleted: {
        dateString=""
        dateString=Variables.globalCurrentDate.toLocaleDateString(Variables.globalLocale,"ddd, MMM dd, yyyy")
        // dateString = currentDate.toLocaleDateString(locale,"ddd, MMM dd, yyyy");
    }

    onDateStringChanged: {
        //data db 해당 날짜로 읽어오고 model변경 날짜도 argument로 들어가야함
        //themodel=modelRead(titleIconSource)
    }
}
