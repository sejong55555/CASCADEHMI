import QtQuick 2.7
import QtQuick.Controls 1.4
import QtCharts 2.0
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle {
    id:root
    width:Variables.sourceWidth;height:Variables.sourceHeight

    property string currentusage:"40"//현재 사용량 읽어와서 보여주기 위함
    property string totalusage:"1000"//사용자가 설정한 전체용량 보여주기 위함

    property int usagePercentage: totalusage===""?"":(currentusage/totalusage)*100
    property string currentPercentageText: qsTr("현재 순시")

    property string currentText: qsTr("현재")
    property string totalText: qsTr("전체")
    MouseArea{anchors.fill:parent}

    //현재 사용량과 설정되어있는 전체 사용량 불러와서 보여주기 위한 signal
    // signal sigReadusage(string _currentusage,string _totalusage)

    // onSigReadusage:{
    //     currentusage=_currentusage
    //     totalusage=_totalusage
    // }

    Component.onCompleted: {
        // sigReadusage("400","1000")
        var data = {"curUsage": "210",
                    "totUsage": "1542"}

        //실제 요청 : 현재 사용 못함.
        //         data= appModel.GetEnergy();

        currentusage = data["curUsage"];
        totalusage = data["totUsage"];
    }

    Column{
        id:contentcol
        anchors.fill: parent
        TitleBar{
            id:title
            z:graphcontent.z+1
            state:"B"
            left_1st_Text:"Energy"
            onSigLClickTitleBar: {
                Variables.content="Home"
            }
        }
        Rectangle{
            id:graphcontent
            width:root.width;height:158
            color:"transparent"

            Column{
                leftPadding: 40
                topPadding:24
                spacing:5
                Rectangle{
                    id:graphImage
                    width:180;height:90;
                    color:"transparent"
                    ChartView {
                        id: chart
                        z:selectmenubtn.z+1
                        // legend.visible: false
                        legend{visible:false}
                        width:180;height:90
                        antialiasing: true
                        backgroundRoundness: 0
                        backgroundColor: "transparent"
                        anchors{fill:parent;leftMargin:-10;rightMargin:-10;bottomMargin: -10;topMargin: -100}
                        margins{top:0;bottom:0;left:0;right:0}

                        // plotArea: Qt.rect(-90,-90,360,180)

                        PieSeries {
                            id: pieSeries
                            size:1
                            holeSize:0.5
                            startAngle: -90
                            endAngle: 90
                            verticalPosition: 1
                            PieSlice { label: "usagepercent"; value: usagePercentage; color:"#FF9305";borderColor: "#FF9305"}
                            PieSlice { label: "empty"; value: 100-usagePercentage;color:"#EEEEEE";borderColor: "#EEEEEE"}
                        }
                    }
                    Row{
                        topPadding:62
                        leftPadding:62
                        spacing:0
                        Text{
                            width:34;height:33;
                            color:"#222222"
                            text:usagePercentage
                            visible: totalusage===""?false:true
                            font.pixelSize: 28
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text{
                            width:21;height:33;
                            color:"#222222"
                            visible: totalusage===""?false:true
                            text:"%"
                            font.pixelSize: 28
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
                Text{
                    width:graphImage.width;height:14
                    text:currentPercentageText
                    visible: totalusage===""?false:true
                    color:"#777777"
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Column{
                leftPadding: 278;topPadding:41;spacing:totalusage===""?16:8
                Row{
                    id:currentRow
                    spacing:20
                    Text{
                        width:30;height:18;y:10
                        text:currentText
                        color:"#777777"
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    Row{
                        spacing:8
                        Text{
                            width:70;height:30
                            font.pixelSize: 30
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text:currentusage
                            color:"#FF9305"
                        }
                        Text{
                            width:26;height:18;y:10
                            text:"kW"
                            color:"#777777"
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Row{
                    id:totalRow
                    spacing:20
                    Text{
                        width:30;height:18;y:totalusage===""?2:10
                        text:totalText
                        color:"#777777"
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    Row{
                        spacing:8
                        Text{
                            id:totalusageTextBox
                            width:70;height:totalusage===""?20:30
                            font.pixelSize: totalusage===""?20:30
                            // font.pixelSize: 30
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            font.underline: true
                            text:totalusage===""?qsTr("입력 필요"):totalusage
                            color:"#222222"
                            MouseArea{
                                anchors.fill:parent
                                onClicked: {
                                    totalusageSet.visible=true
                                    totalusageSet.setUsage=totalusage
                                }
                            }
                        }
                        Text{
                            width:26;height:18;y:totalusage===""?2:10
                            text:"kW"
                            color:"#777777"
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
        Rectangle{
            id:selectmenubtn
            width:root.width;height:62
            z:-1
            color:"#EFF0F2"
            TextButtonRow{
                firstbtnW:200;secondbtnW:200
                firstbtnText:"Usage Graph";firstimageName:"graph_gray"
                secondbtnText:"Summary";secondimageName:"graph_gray"
                rowleftPadding:30
                rowtopPadding:13
                rowspacing:20
                onSigRowLClickIn: {
                    usageGraph.visible=true
                }
                onSigRowRClickIn: {
                    summary.visible=true
                }
            }
        }
    }

    EnergyInput{
        id:totalusageSet
        visible:false
        onSigBackClickInputEnergy: {
            totalusageSet.visible=false
        }
        onSigDoneClickInputEnergy: {
            totalusageSet.visible=false
            totalusage=_setTotalusage//input 텍스트 필드에 보여질 현재 저장된 전체 사용량 정보 보냄
        }
    }

    UsageGraph{
        id:usageGraph
        visible:false
        onSigBackClickUsage:{
            visible=false
        }
    }

    Summary{
        id:summary
        visible:false
        onSigBackClickSummay: {
            visible=false
        }
    }
}
