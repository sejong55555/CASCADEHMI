import QtQuick 2.7
import QtQml 2.0

import "../Global"
import "../Common"

Rectangle {
    id:root
    width:Variables.sourceWidth;height:Variables.sourceHeight
    color:"#FFFFFF"

    property var colName :["",qsTr("Heat"),qsTr("Cool"),qsTr("DHW"),qsTr("Total")]
    property var rowName :[qsTr("Today"),qsTr("Month"),qsTr("Year")]

    property var summaryToday
    property var summaryMonth
    property var summaryYear

    property bool isPower: true

    signal sigBackClickSummay()

    function summaryRead(){
        summaryToday=[]
        summaryMonth=[]
        summaryYear=[]

        var resultData

        // var resultData = appModel.getSummaryPowerData();
        // var resultData = appModel.getSummaryCalData();

        if(isPower===true){
            resultData={
                "summaryToday":[12,13,14,39]
                ,"summaryMonth":[93,153,142,388]
                ,"summaryYear":[42,63,74,179]
            }
            summaryToday=resultData["summaryToday"]
            summaryMonth=resultData["summaryMonth"]
            summaryYear=resultData["summaryYear"]
        }

        else if(isPower===false){
            resultData={
                "summaryToday":[100,100,100,300]
                ,"summaryMonth":[293,253,242,788]
                ,"summaryYear":[342,363,374,1079]
            }

            summaryToday=resultData["summaryToday"]
            summaryMonth=resultData["summaryMonth"]
            summaryYear=resultData["summaryYear"]

        }


    }

    Column{
        width:Variables.sourceWidtt;height:Variables.sourceHeight

        TitleBar{
            id:title
            left_1st_Text:qsTr("Summary")
            state:"G"
            onSigLClickTitleBar:{
                sigBackClickSummay()
            }

            onSigRClickTitleBar: {
                isPower=!isPower
                summaryRead()
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

    Column{
        id:datamold
        leftPadding:112
        topPadding:117
        spacing:25
        Row{
            id:todayRow
            spacing:9
            Repeater{
                model:summaryToday
                Text{
                    width:79
                    height:16
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:modelData
                    color:"#222222"
                }
            }
        }

        Row{
            id:monthRow
            spacing:9
            Repeater{
                model:summaryMonth
                Text{
                    width:79
                    height:16
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:modelData
                    color:"#222222"
                }
            }
        }

        Row{
            id:yearRow
            spacing:9
            Repeater{
                model:summaryYear
                Text{
                    width:79
                    height:16
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:modelData
                    color:"#222222"
                }
            }
        }

    }

    Text{
        id:unitBox
        width:80
        height:14
        x:380
        y:240
        font.pixelSize: 14
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:"#222222"
        text:isPower===true? "*Unit : kWh" : "*Unit : Hours"
    }



    Component.onCompleted: {
        summaryRead()
    }

}

