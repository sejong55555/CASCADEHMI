import QtQuick 2.7
import QtQuick.Window 2.10
import EnumHMI 1.0
import "Global"

Window {
    id: idWindow
    visible: true
    width: {
        if(APP_PLATFORM === EnumHMI.E_OS_LINUX)
            idGlobal.DEF_DEVICE_WIDTH
        else
            idGlobal.DEF_IPAD_WIDTH
    }
    height: {
        if(APP_PLATFORM === EnumHMI.E_OS_LINUX)
            idGlobal.DEF_DEVICE_HEIGHT
        else
            idGlobal.DEF_IPAD_HEIGHT
    }

//    property int viewMode: appModel.viewMode
    Loader {
        id: idMain
        // anchors.fill: parent
        x: 0
        y: 0
        source: showView()
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

    function showView() { //loader로 하니까 schedule load시 좀 느린 것 같음....
        var url="notification/Notification.qml"
        // var url="setting/InstallerSettingHome.qml"
        if(Variables.content==="Home"){
            url="monitoring/MonitoringHome.qml";
        }
        else if(Variables.content==="Notification"){
            url="notification/NotificationHome.qml";
        }

        else if(Variables.content==="Function"){
            url="function/FunctionHome.qml";
        }

        else if(Variables.content==="Schedule"){
            url="schedule/ScheduleHome.qml";
        }

        else if(Variables.content==="Energy"){
            url="energy/EnergyHome.qml";
        }

        else if(Variables.content==="Setting"){
            url="setting/SettingHome.qml";
        }

        return url;
    }
}
