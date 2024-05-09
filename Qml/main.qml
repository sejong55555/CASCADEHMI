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

    function showView() { //loader로 하니까 schedule load시 좀 느린 것 같음....
        var url="setting/SettingHome.qml"
        if(Variables.content==="Home"){
            url="monitoring/MonitoringHome.qml";
        }

        else if(Variables.content==="Function"){
            url="monitoring/MonitoringHome.qml";
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

        //var url = "HMIMain.qml";
        return url;
    }
}