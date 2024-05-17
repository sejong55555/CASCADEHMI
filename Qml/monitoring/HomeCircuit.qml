import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle {
    id: root
    width:Variables.sourceWidth;height:Variables.sourceHeight

//  연산을 위한 변수라서 함수 내에서 선언하여 사용하고 전역 변수에서 삭제. //code by pms
//    property var locale: Qt.locale()
//    property date currentTime: new Date()
    property string timeString

    property string runmodestring:"Cool"//기본 circuit device cool로 설정

    signal sigRunmodeClick(string currentRunmode)
    signal sigMenuClick()
    signal sigmonitoringClick()

    Component.onCompleted: {     //함수 위치 이동 및 처리 변경. //code by pms
        var locale = Qt.locale();
        console.log("Locale date : " + locale);
        var curTime= new Date();
        console.log("Current Time : " + curTime);

        //현재 시간 계산.
        timeString = curTime.toLocaleTimeString(locale, Locale.ShortFormat,"h:mm AP");
        console.log("Current date : " + timeString);
    }

    // 에코 모드 설정 함수. -> 에코 모드 설정을 위해 인터페이스 함수 콜. //code by pms
    function setEcoMode(bMode) {
        var state = bMode ? "ON" : "OFF";
        console.log("ECO mode : " + state);

        //실제 적용 코드 - 현재 사용 불가.
        appModel.setEcoMode(bMode);
    }

    Column{
        PageTitle{
            id:title
            width:parent.width
            height:48
            lefticonname: "title_menu"
            righticonname: "title_plus"
            lefticonSize:32
            righticonSize:40
            leftpadding:20
            bottompadding:4
            iconspacing:372
            onSigRClickPage: {
                sigmonitoringClick()
            }
            onSigLClickPage: {
                sigMenuClick()
            }

            Textmold{
                id:timeBox
                x:200
                y:15
                width:80
                height:18
                textfieldWidth:width
                textfieldHeight:height
                fontsize:18
                fontcolor: "#222222"
                horizontalAlignment: Text.AlignRight
                shadowEnable:false
                textshadowEnable: false
                textfieldText:timeString
            }
        }
        Row{
            spacing:10
            leftPadding:20;rightPadding:20;
            //*to Do CircuitForm를 Loader로 해서 runningmode로 변경 할 수 있게 해야함
            CircuitForm{
                id:circuitcool
                runmode:runmodestring
                maxTemp:runmodestring==="Cool"?Variables.coolmax:runmodestring==="Heat"?Variables.heatmax:Variables.automax
                minTemp:runmodestring==="Cool"?Variables.coolmin:runmodestring==="Heat"?Variables.heatmin:Variables.automin
                currentTempiconImage:"water2"

                // onSetTempChanged:{
                //     appModel.setCircuitTemp(setTemp)//osea temp
                // }
            }

            CircuitForm{
                id:hotwater
                currentTempiconImage:"watertemp"
                runmode:"Hot water"
                maxTemp:Variables.hotwatermax
                minTemp:Variables.hotwatermin
                textfieldText:qsTr("Hot water")

                // onSetTempChanged:{
                //     appModel.setHotWaterTemp(setTemp) //osea temp
                // }
            }
        }
        Rectangle{
            id:bottomRow
            width:root.width;height:36
            Row{
                leftPadding:20;topPadding:8
                IconTemp{
                    width:219;height:20;
                    textfieldX: 106;textfieldY:2
                    textfieldWidth: 32;textfieldHeight:16;fontsize:16;
                    textfieldText: runmodestring
                    // "Cool"
                    iconWidth:20;iconImageName:runmodestring.charAt(0).toLowerCase()+runmodestring.slice(1)
                    textshadowEnable: false;shadowEnable: false
                    iconX:82;iconY:0
                    mouseEnable:true
                    onSigClick: {
                        color="#D8D8D8"
                    }
                    onSigReleased:{
                        color="transparent"
                        sigRunmodeClick(runmodestring)
                    }
                }
                Rectangle{
                    id:midline
                    width:2;height:20;
                    color:"#D9D9D9"
                }
                IconTemp{
                    width:219
                    height:20

                    textfieldX:108
                    textfieldY:2
                    textfieldWidth: 32
                    textfieldHeight:16
                    fontsize:16
                    textfieldText: qsTr("OFF")

                    iconWidth:20;
                    iconImageName:"eco"

                    textshadowEnable: false
                    shadowEnable: false

                    iconX:84
                    iconY:0
                    mouseEnable:true
                    onSigClick: {
                        color="#D8D8D8"
                    }
                    onSigReleased:{
                        color="transparent"
                        var bMode = false;      // true : ON, false : OFF
                        if(textfieldText==="OFF"){
                            textfieldText = qsTr("ON")
                            bMode = true;
                        }
                        else{
                            textfieldText = qsTr("OFF")
                            bMode = false;
                        }

                        root.setEcoMode(bMode);
                    }
                }
            }
        }
    }
}
