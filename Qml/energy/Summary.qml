import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle {
    id:root
    width:Variables.sourceWidth;height:Variables.sourceHeight
    color:"#FFFFFF"

    property var colName :["","Heat","Cool","DHW","Total"]
    property var rowName :["Today","Month","Year"]

    property var listToday:[12,13,14,15]
    property var listMonth:[93,153,142,135]
    property var listYear:[42,63,74,65]

    signal sigBackClickSummay()

    Column{
        width:Variables.sourceWidtt;height:Variables.sourceHeight

        TitleBar{
            id:title
            left_1st_Text:qsTr("Summary")
            state:"G"
            onSigLClickTitleBar:{
                sigBackClickSummay()
            }
        }

        Row{
            topPadding: 12
            leftPadding:20
            spacing:1
            Repeater{
                model:colName
                Rectangle{
                    width:87;height:41
                    color:"#66DEE1E5"
                    Text{
                        // Rectangle{anchors.fill:parent;color:"transparent";opacity:0.4}
                        anchors.centerIn: parent
                        width:79;height:16
                        font.pixelSize: 16
                        color:"#222222"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text:modelData
                    }
                }
            }
        }

        Column{
            topPadding:1
            leftPadding:20;
            spacing:1
            Repeater{
                model:rowName
                Rectangle{
                    width:87;height:40
                    Text{
                        anchors.centerIn: parent
                        width:79;height:16
                        font.pixelSize: 16
                        color:"#222222"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text:modelData
                    }
                }
            }
        }
    }

    Item{
        id:tableLine
        x:20;y:64

        Row{
            leftPadding: 87
            spacing:87
            Repeater{
                model:4
                Rectangle{
                    width:1;height:163
                    color:"#DEE1E5"
                }
            }
        }
        Column{
            topPadding: 40
            spacing:40
            Repeater{
                model:4
                Rectangle{
                    width:440;height:1
                    color:"#DEE1E5"
                }
            }

        }
    }

    // Column{
    //     width:Variables.sourceWidtt;height:Variables.sourceHeight
    //     spacing:12

    //     TitleBar{
    //         id:title
    //         left_1st_Text:qsTr("Summary")
    //         state:"G"
    //         onSigLClick:{
    //             sigBackClickUsage()
    //         }
    //     }

    //     Rectangle{
    //         id:tablebg
    //         x:20;
    //         width:439;height:164
    //         color:"#DEE1E5"

    //     }
    // }
}

