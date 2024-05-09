import QtQuick 2.10
import QtQml 2.0
import QtGraphicalEffects 1.0
import "../Global"
import "../Common"

Rectangle{
    id:root
    width:Variables.sourceWidth;height:Variables.sourceHeight;
    color:"#26000000"

    MouseArea{anchors.fill:parent}

    signal sigCloseClick()
    signal sigAlarmClick()

    signal sigFunctionClick()
    signal sigScheduleClick()
    signal sigEnergyClick()
    signal sigSettingClick()

    Rectangle{
        id:menumold
        width:240;height:272
        Column{
            Rectangle{
                id: menuHeader
                width:240;height:47
                Row{
                    leftPadding: 160;topPadding: 6
                    spacing:2
                    TitleBarButton{width:36;height:width;imagename:"menu_alarm"
                        onSigClick: {
                            sigAlarmClick()
                        }
                    }
                    TitleBarButton{width:36;height:width;imagename:"menu_close"
                        onSigClick: {
                            sigCloseClick()
                        }
                    }
                }
            }
            Rectangle{
                id:headerDivider
                width:240;height:1
                color:"#D9D9D9"
            }

            Repeater{
                id:menuList
                model:["function","schedule","energy","setting"]

                List{
                    iconX:10;
                    iconW:32;iconH:32
                    state:"G"
                    width:240
                    left_1st_Text: modelData.charAt(0).toUpperCase()+modelData.slice(1)
                    icon_source:"menu_list_"+modelData
                    Component.onCompleted:{
                        textBoxLeftPadding=52
                    }
                    onSigClick: {
                        switch(index){
                            case 0:{
                                sigFunctionClick();
                                break;}
                            case 1:{
                                sigScheduleClick();
                                break;}
                            case 2:{
                                sigEnergyClick();
                                break;
                            }
                            case 3:{
                                sigSettingClick();
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    DropShadow {
        id:shadow
        visible: true
        anchors.fill: menumold
        z: -1
        // verticalOffset: 4
        horizontalOffset: 5
        radius: 20
        samples: 1+radius*2
        color: "#222222"
        opacity: 0.3
        source: menumold
    }

}
