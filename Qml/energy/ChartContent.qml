import QtQuick 2.7
import QtCharts 2.2
import QtQuick.Controls 1.4
import QtQml 2.0
import "../Common"
import "../Global"

Item{
    id:root

    property int _mulValue: 50
    property real _barWidth:0.34
    property real _offset: 18
    property var _themodel: ["1", "2", "3", "4", "5", "6", "7"] //for x asix

    // property var heatSummary //for chart data
    // property var coolSummary
    // property var dhwSummary

    // property var lastyearSummary

    Rectangle{
        id:currentmold
        x:67.5
        y:50
        width:350
        height:108
        color:"transparent"

        ChartView {
            width:350
            height:108
            legend{visible:false}
            backgroundColor: "transparent"
            // plotArea:  Qt.rect(67.5, 51, 350, 108)
            anchors{fill:parent;leftMargin:-10;rightMargin:-10;bottomMargin: -10;topMargin: -10}
            margins{top:0;bottom:0;left:0;right:0}
            StackedBarSeries{
                id: currentYearSeries
                barWidth :_barWidth
                axisX: BarCategoryAxis {
                        visible:false;
                        categories: _themodel
                }
                axisY:ValueAxis {
                    visible :false
                    min: 0
                    max: _mulValue*5 + 10
                }

                //values에 현재 전력 사용량 읽어와서 넣어서 읽기 위함
                BarSet {color:"#E77F5F";    borderColor:"#E77F5F";  label:"DHW only";   values:heatChart}
                BarSet {color:"#0B9FE9";    borderColor:"#0B9FE9";  label:"Cool";   values:coolChart}
                BarSet {color:"#FF9305";    borderColor:"#FF9305";  label:"Heat";   values:dhwChart}
            }
        }
    }

    Rectangle{
        id:lastyeartmold
        x:67.5+_offset
        y:50
        width:350
        height:108
        color:"transparent"
        ChartView{
            width:350
            height:108
            legend{visible:false}
            anchors{fill:parent;leftMargin:-10;rightMargin:-10;bottomMargin: -10;topMargin: -10}
            margins{top:0;bottom:0;left:0;right:0}
            // plotArea:  Qt.rect(67.5+_offset, 51, 350, 108)
            backgroundColor: "transparent"
            BarSeries {
                   id: lastYearSeries
                   barWidth :_barWidth
                   axisX: BarCategoryAxis { visible:false;categories: _themodel }
                   axisY:ValueAxis {
                       visible :false
                       min: 0
                       max: _mulValue*5 + 10
                   }
                   //values에 작년 사용량 읽어와서 넣어서 읽기
                   BarSet { color:"#DEE1E5";borderColor:"#DEE1E5";label: "lastyear"; values: lastyearChart }
            }
        }
    }
}
