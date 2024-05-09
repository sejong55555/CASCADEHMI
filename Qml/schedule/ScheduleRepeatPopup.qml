import QtQuick 2.7
import "../Global"
import "../Common"
Rectangle {
    id:deleteschedule
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#26000000"


    PopupPickerRadio{
        anchors.centerIn: parent
        textfieldText:"Delete Repeating Schedule"
        firstTextField:"Only this schedule"
        secondTextField:"All repeating schedules"
    }
}

