import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtCharts 2.0
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle {
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    property string selectSource :Variables.sourcePath+"img_bar_sel.png"
    property int mulValue:50
    property var themodel: weekmodelaxis

    property bool isPower: true

    property var weekmodelaxis:["1", "2", "3", "4", "5", "6", "7"]

    property var monthmodelaxis: ["1st","2nd","3rd","4th","5th"]
    property var yearmodelaxis: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

    property string axisXText:"(Day)"

    signal sigBackClickUsage()


//temp dummy data
    property variant periodList: {"0":"week","1":"month","2":"year"}
    property string energyPeriod: periodList["0"]
    property string dateRange

    property var heatChart
    property var coolChart
    property var dhwChart

    property var lastyearChart
    property var thisyearChart

    function usageRead(_energyPeriod,_energyDateRange){
        if (_energyDateRange === undefined) {
            _energyDateRange = Variables.globalTodayMonth+ "/" +Variables.globalTodayDate + "/" + Variables.globalTodayYear
        }
        heatChart=[]
        coolChart=[]
        dhwChart=[]

        var resultData

        // var resultData = appModel.getChartCalData(_energyPeriod,_energyDateRange); //ex. period:week일 때 date 05/16/24를 인자로 보내면 05/16기준으로 일주일의 power를 읽어옴
        // var resultData = appModel.getChartPowerData(_energyPeriod,_energyDateRange); //calories 정보를 읽어오기 위함

        if(isPower===true){//전력 버튼이 on일 때
            // var resultData = appModel.getChartCalData(_energyPeriod,_energyDateRange); //ex. period:week일 때 date 05/16/24를 인자로 보내면 05/16기준으로 일주일의 power를 읽어옴
            resultData={
                "heatChart":[30, 50, 80, 130, 50, 180, 40]
                ,"coolChart":[50, 100, 20, 40, 100, 70, 70]
                ,"dhwChart":[20, 20, 30, 40, 50, 60, 100]
                ,"lastyearChart":[20, 20, 30, 40, 50, 60, 100]

            }
            heatChart = resultData["heatChart"]
            coolChart = resultData["coolChart"]
            dhwChart = resultData["dhwChart"]

            lastyearChart = resultData["lastyearChart"]
        }

        else if(isPower===false){//칼로리 버튼이 on일 때
            // var resultData = appModel.getChartPowerData(_energyPeriod,_energyDateRange); //calories 정보를 읽어오기 위함
            resultData={
                "thisyearChart":[30, 50, 80, 130, 50, 180, 40]
                ,"lastyearChart":[50, 100, 20, 40, 100, 70, 70]
            }
            heatChart=resultData["thisyearChart"]
            lastyearChart = resultData["lastyearChart"]

        }
    }

    Column{
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        TitleBar{
            id:title
            left_1st_Text:qsTr("Usage Graph")
            state:"G"
            onSigLClickTitleBar:{
                sigBackClickUsage()
            }
            onSigRClickTitleBar: {
                calorieInfo.visible=!calorieInfo.visible
                powerInfo.visible=!powerInfo.visible
                isPower=!isPower
                usageRead(energyPeriod,dateRange)
            }
        }
        TabView {
            id: frame
            width:Variables.sourceWidth;height:220
            onCurrentIndexChanged: {
                if(currentIndex===0){
                    mulValue=50
                    themodel=weekmodelaxis
                    energyPeriod=periodList["0"]
                    usageRead(energyPeriod,dateRange)
                }
                else if(currentIndex===1){
                    mulValue=150
                    themodel=monthmodelaxis
                    energyPeriod=periodList["1"]
                    usageRead(energyPeriod,dateRange)
                }
                else if(currentIndex===2){
                    mulValue=250
                    themodel=yearmodelaxis
                    energyPeriod=periodList["2"]
                    usageRead(energyPeriod,dateRange)
                }
            }
            Tab {
                title: "Week"
                ChartContent{
                    id:weekchart
                    _mulValue:50
                    _themodel:weekmodelaxis
                }
            }

            Tab {
                title: "Month"
                ChartContent{
                    id:monthchart
                    _mulValue:150
                    _themodel:monthmodelaxis
                    _barWidth:0.242
                    _offset:18
                }
            }
            Tab {
                title: "Year"
                ChartContent{
                    id:yearchart
                    _mulValue:250
                    _themodel:yearmodelaxis
                    _barWidth:0.343
                    _offset:11
                }
            }
            style: TabViewStyle {
                frameOverlap: 0
                tabsAlignment:Qt.AlignHCenter

                tab: Rectangle {
                    color: "transparent"
                    property bool sourceFlag : styleData.selected ? true : false
                    Image{
                        y:30
                        width:144;
                        height:3
                        visible:sourceFlag===true?true:false
                        source:selectSource
                    }
                    implicitWidth: 144
                    implicitHeight: 33
                    Text {
                        id: text
                        font.bold: styleData.selected ?true:false
                        anchors.centerIn: parent
                        text: styleData.title
                        color: "#222222"
                    }
                }
                frame: Rectangle { color: "transparent" }
            }
        }
    }
    Item{
        id:asixXY
        width:parent.width
        height:parent.height
        Rectangle{x:58;y:136;width:1;height:108;color:"#DEE1E5"}
        Rectangle{x:59;y:243;width:401;height:1;color:"#DEE1E5"}

        Text{
            id:asixYtextBox
            width:mulValue===50?39:mulValue===150?38:0
            height:12
            x:421
            y:248
            horizontalAlignment: Text.AlignRight
            text:mulValue===50?"(Day)":mulValue===150?"(Week)":"";
            font.pixelSize:12
            color:"#555555"
        }
        Text{
            id:asixXtextBox
            width:32
            height:12
            x:20
            y:118
            text:"(kWh)"
            font.pixelSize: 12
            color:"#555555"
        }
        Column{
            spacing:12
            leftPadding:20
            topPadding: 136
            Repeater{
                model:5
                Text{
                    id:textYBox
                    width:32
                    height:12
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 12
                    color:"#555555"
                    text:(4-modelData)*mulValue
                }
            }
        }
        Row{
            leftPadding:mulValue===50?91:mulValue===150?90:67
            topPadding: 248
            spacing:mulValue===50?30:mulValue===150?54:9
            Repeater{
                model:themodel
                Text{
                    width:mulValue===250?24:20
                    height:12
                    text:modelData
                    color:"#555555"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Row {
            width: 368+32
            height:16
            z:-1
            topPadding: 158
            leftPadding: 60
            Rectangle{
                width:368
                height:1
                Canvas {
                    //*to do border solid 변경
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.strokeStyle = "#4D32373E";
                        ctx.lineWidth = 1;
                        ctx.createPattern("#4D32373E",Qt.SolidPattern)
                        // ctx.setLineDash(3, 1);
                        ctx.beginPath();
                        ctx.moveTo(0, 0);
                        ctx.lineTo(368, 0);
                        ctx.stroke();
                    }
                }
            }
            Image{
                width:32
                height:16
                y:-height/2
                source:Variables.sourcePath+"bg_graph_guide.png"
                Text{
                    width:28
                    height:16
                    anchors.centerIn: parent
                    font.pixelSize: 12
                    text:mulValue===50?"160":mulValue===150?"460":"760";
                    color:"#FFFFFF"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }


        Column{
            id:calorieInfo
            leftPadding: 400
            topPadding: 95
            visible:false
            Repeater{
                model:[{name:qsTr("This Year"),icSource:"graph_heat"},{name:qsTr("last Year"),icSource:"graph_lastyear"}]
                IconTemp{
                    iconWidth:12
                    iconHeight: 12
                    iconY:0

                    textfieldX:iconWidth+8
                    textfieldWidth:50
                    textfieldHeight:12
                    fontsize:12

                    shadowEnable:false

                    iconImageName:modelData.icSource
                    textfieldText:modelData.name

                }
            }
        }

        Item{
            id:powerInfo
            property bool powerInfoFlag:false

            TitleBarButton{
                width:18
                height:width
                x:442
                y:97
                btnORicon:"ic_"
                imagename:"info_graph"

                onSigClick:{
                    powerInfo.powerInfoFlag=!powerInfo.powerInfoFlag
                }
            }
            Rectangle{
                width:92
                height:94
                x:378
                y:119
                radius:4
                visible:powerInfo.powerInfoFlag
                opacity:0.85
                color:"#000000"                

                Column{
                    spacing:8
                    leftPadding:10
                    topPadding:10
                    Repeater{
                        model:[{name:"Heat",colorName:"#FF9305"},{name:"Cool",colorName:"#0B9FE9"},{name:"DHW only",colorName:"#E77F5F"},{name:"Last Year",colorName:"#DEE1E5"}]
                        Row{
                            spacing:8
                            Rectangle{
                                width:12
                                height:12
                                color:modelData.colorName}
                            Text{
                                width:52
                                height:12
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                color:"#FFFFFF"
                                text:modelData.name
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        usageRead(energyPeriod,dateRange)
    }
}
