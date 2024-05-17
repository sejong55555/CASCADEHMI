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
    // property var themodelTemp
    property bool modelEmpty: true
    property string backgroundText: qsTr("Tap ‘+’ button to add schedule.")

    property alias rightItemSource: title.rightItem_source
    property alias titleIconSource: title.icon_source
    property alias rightItemClickEnable: title.rightItemrangeVisible

    signal sigrightItemClick()
    signal sigeditClickList(int _index,string _selectedmenu,string _selectediconSource)
    signal sigbackClick()

    Column{
        id: columnLayout
        anchors.fill: parent
        TitleBar{
            id:title
            left_1st_Text:qsTr("Schedule list")
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

    Component{
        id:listdelegate

        List{
            property string deviderText: isEveryWeek===true?"":" / "
            property string deviderText2: isEveryWeek===true?"":"~"

            property var _startYear: startDate.split("/")[2]
            property var _startMonth: startDate.split("/")[0]
            property var _startDate: startDate.split("/")[1]

            property var _endYear: endDate.split("/")[2]
            property var _endMonth: endDate.split("/")[0]
            property var _endDate: endDate.split("/")[1]

            state:runningMode==="off"||runningMode==="on"||runningMode==="temp"?"D":"D_icon"
            height:52
            left_1st_Text:hour+":"+min+" "+ampmmodel.get(ampm).index
            left_2nd_Text:days+deviderText+monthmodel.get(_startMonth).index.slice(0,3)+" "+_startDate+deviderText2+monthmodel.get(_endMonth).index.slice(0,3)+" "+_endDate
            rightItemsourceUrl:"IconTextButton.qml"
            rightItemtextField:runningMode==="off"?"OFF":runningMode==="on"?"ON":runningMode==="temp"?temp+" ̊":""
            rightIconText:temp+" ̊"
            rightIconImage:runningMode==="off"||runningMode==="on"?"":"schedule_"+runningMode

            onSigClick: {
                editSchedule.seteditSchedule(hour,min,ampm,runningMode,temp,days,isUse,isEveryWeek,isPeriod,startDate,endDate,id,name)
                editSchedule.visible=true
            }
        }
    }

    Component.onCompleted: {
        if(themodel.count!==0){
            modelEmpty=false
        }
    }
}
