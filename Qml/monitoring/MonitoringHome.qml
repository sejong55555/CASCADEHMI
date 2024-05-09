import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"
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
    }

    MonitoringOut{
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
        }
    }

    Menu{
        id:menu
        visible:false
        onSigAlarmClick: {
            menu.visible=false
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
    }

    DriveMode{
        id:driveMode
        visible:false
        onSigXClick: {
            visible=false
        }
    }
}
