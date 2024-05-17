import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"
import "../notification"
import "../menu"

Item {
    id: root
    anchors.fill:parent

    MonitoringIn{
        id:monitoringIn
        visible:false
        onSigDriveClick:{
            driveMode.visible=!(driveMode.visible)
        }
        onSigHomeClick:{
            monitoringIn.visible=false
            homeCircuit.visible=true
        }
        // onSigCircuitClick: {
        //     monitoringIn.visible=false
        //     homeCircuit.visible=!(homeCircuit.visible)
        // }
        onSigOutmonitoringClick:{
            monitoringIn.visible=false
            monitoringOut.visible=true
        }

        onVisibleChanged: {
            updateValue()
        }
    }

    MonitoringOut{//osea
        id:monitoringOut
        visible:false

        onSigDriveClick:{
            driveMode.visible=!(driveMode.visible)
        }
        onSigHomeClick:{
            monitoringOut.visible=false
            homeCircuit.visible=true
        }
        onSigInmonitoringClick: {
            monitoringOut.visible=false
            monitoringIn.visible=true
        }

        onVisibleChanged: {
            updateValue()
        }
    }

    HomeCircuit{
        id:homeCircuit
        visible:true
        onSigRunmodeClick:{
            if(Variables.lockmode===true){
//                Qt.createObject("PopupToast.qml")
            }
            else{
                runningMode.sigDefaultRunmode(runmodestring)
                runningMode.visible=true
            }
        }
        onSigmonitoringClick:{
            homeCircuit.visible=false
            monitoringIn.visible=true
        }
        onSigMenuClick: {
            menu.visible=true
        }
        //heve to create menu list
    }
    RunningMode{
        id:runningMode
        visible:false
        onSigbackClick:{
            // homeCircuit.visible = true
            runningMode.visible = false
        }
        onSigSendRunmode:{
            runningMode.visible = false
            homeCircuit.runmodestring=sendrunmode
            appModel.setRunMode(homeCircuit.runmodestring)
        }
    }

    Menu{
        id:menu
        visible:false
        onSigAlarmClick: {
            menu.visible=false
            notificationhome.notiRead()
            notificationhome.visible=true
        }
        onSigCloseClick: {
            menu.visible=false
        }
        onSigFunctionClick: {
            Variables.content="Function"
        }
        onSigScheduleClick: {
            Variables.content="Schedule"
        }
        onSigEnergyClick: {
            Variables.content="Energy"
        }
        onSigSettingClick: {
            Variables.content="Setting"
        }
        alarmBtnImageState:notificationhome.newAlarmCount===0? "n" : ""
        alarmBtnImageSource: notificationhome.newAlarmCount > 99? Variables.sourcePath+"btn_menu_alarm_new.png":Variables.sourcePath+"btn_menu_alarm_num.png"

        alarmCountVisible:notificationhome.newAlarmCount > 99? false : true
        alarmImagename:notificationhome.newAlarmCount===0? "menu_alarm" :""
        alarmCountText:notificationhome.newAlarmCount===0? "" : notificationhome.newAlarmCount
    }

    NotificationHome{
        id:notificationhome
        visible:false

    }

    DriveMode{
        id:driveMode
        visible:false
        onSigXClick: {
            visible=false
        }
    }
}
