import QtQuick 2.7
import QtQuick 2.10
import QtQml 2.0
import "../Global"
import "../Common"
Rectangle{
    id:root
    width: Variables.sourceWidth;
    height: Variables.sourceHeight;

    color:"#FFFFFF"

    property alias titleName:title.left_1st_Text
    property alias titlestate:title.state

    property string _popuptoastText

    property var themodel
    property bool modelEmpty: true
    property string backgroundText: "Tap ‘+’ button to add schedule."

    property alias rightItemSource: title.rightItem_source
    property alias titleIconSource: title.icon_source
    property alias rightItemClickEnable: title.rightItemrangeVisible

    signal sigrightItemClick()
    signal siglistBarClick(int _index,string _selectedmenu,string _selectediconSource)
    signal sigbackClick()

    Column{
        id: columnLayout
        anchors.fill: parent
        TitleBar{
            id:title
            left_1st_Text:"Schedule list"
            state:"F"
            onSigRClickTitleBar: {
                sigrightItemClick()
            }
            onSigLClickTitleBar: {
                sigbackClick()
            }
        }

        ListView {
            id:mainListview
            clip: true
            width:480;
            height:root.height-title.height
            z:-1
            model:themodel
            //temp model
            // model:circuitmodel
            delegate:listdelegate
        }
    }
        Text{
            id:emptybackground
            visible:modelEmpty
            y:152
            anchors.horizontalCenter: parent.horizontalCenter
            width:440;height:20
            font.pixelSize:20
            color:"#222222"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text:backgroundText
        }

        // PopupToast{
        //     id:popuptoastComponent
        //     visible:false
        //     state:"1line"
        //     textstring:_popuptoastText
        //     onSigFadeDone: {
        //         popuptoastComponent.visible=false
        //     }
        // }

    Component{
        id:listdelegate
        List{
            property string dddTemp: startDay===""?"":" / "
            property string dddTemp2: startDay===""?"":"~"
            state:runningMode==="off"||runningMode==="on"||runningMode==="temp"?"D":"D_icon"
            height:52
            left_1st_Text:hour+":"+min+" AM/PM"
            left_2nd_Text:repeat+dddTemp+startDay+dddTemp2+endDay
            rightItemsourceUrl:"IconTextButton.qml"
            rightItemtextField:runningMode==="off"?"OFF":runningMode==="on"?"ON":runningMode==="temp"?temp+" ̊":""
            rightIconText:temp+" ̊"
            rightIconImage:runningMode==="off"||runningMode==="on"?"":"schedule_"+runningMode
            // Component.onCompleted: {
            //    console.log(rightIconImage)
            // }
        }
    }

    ListModel{
        //daliy나 list나 같은 model을 읽어옴 +버튼 누를 때 같은 모델에 add,
        //model을 임의로 넣어줌 schedule in startDay~endDay 요일만 비교해서 Daily에 넣어줘도되는데...
        id:circuitmodel

        ListElement{repeat:"WeekDay";startDay:"";endDay:"";hour:"08";min:"00";runningMode:"cool";temp:"26"}
        ListElement{repeat:"Mon Wed Fri";startDay:"Mar 01";endDay:"Jun 01";hour:"06";min:"00";runningMode:"off";temp:""}
        ListElement{repeat:"Mon Wed Fri";startDay:"";endDay:"";hour:"08";min:"00";runningMode:"heat";temp:"24"}
        ListElement{repeat:"WeekDay";startDay:"";endDay:"";hour:"10";min:"00";runningMode:"temp";temp:"21"}
    }

    ListModel{
        id:hotwatermodel

        ListElement{repeat:"WeekDay";startDay:"";endDay:"";hour:"08";min:"00";runningMode:"cool";temp:"26"}
        ListElement{repeat:"Mon Wed Fri";startDay:"Mar 01";endDay:"Jun 01";hour:"06";min:"00";runningMode:"off";temp:""}
        ListElement{repeat:"Mon Wed Fri";startDay:"";endDay:"";hour:"08";min:"00";runningMode:"heat";temp:"24"}
        ListElement{repeat:"WeekDay";startDay:"";endDay:"";hour:"10";min:"00";runningMode:"temp";temp:"21"}
    }

    ListModel{
        id:dhwheatermodel

        ListElement{repeat:"WeekDay";startDay:"";endDay:"";hour:"08";min:"00";runningMode:"cool";temp:"26"}
        ListElement{repeat:"Mon Wed Fri";startDay:"Mar 01";endDay:"Jun 01";hour:"06";min:"00";runningMode:"off";temp:""}
        ListElement{repeat:"Mon Wed Fri";startDay:"";endDay:"";hour:"08";min:"00";runningMode:"heat";temp:"24"}
        ListElement{repeat:"WeekDay";startDay:"";endDay:"";hour:"10";min:"00";runningMode:"temp";temp:"21"}
    }

    ListModel{
        id:dhwrecirculationmodel
    }

    Component.onCompleted: {
        // themodel=modelRead2(titleIconSource)
        if(themodel.count!==0){
            modelEmpty=false
        }
    }

    function modelRead2(name){
        //To do:날짜 입력부분 추가해서 읽어야함
        var _themodel
        _themodel=(name==="circuit_1")?circuitmodel:(name==="circuit_hotwater")?hotwatermodel:(name==="circuit_DHW_heater")?dhwheatermodel:dhwrecirculationmodel
        return _themodel
    }
}