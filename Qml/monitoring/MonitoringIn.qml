import QtQuick 2.7
import QtQml 2.0
import QtGraphicalEffects 1.0
import "../Global"
import "../Common"
Rectangle {
    id: root
    width:Variables.sourceWidth;height:Variables.sourceHeight

    //주황색 박스
    property string circuitInsideText: "30" // 보이는 현재 실내온도를 불러와서 보여줌
    property string circuitSetInsideText: "28"// 보이는 실내 설정온도
    property string outsideTempText: "30" //외부 온도를 불러와서 보여줌

    //주황색 박스 아래
    property string inleText: "30"// 입수온도를 불러와서 보여줌
    property string outletText: "28"// 출수온도를 불러와서 보여줌

    //회색 선 아래
//    property string heaterText: "ON"// 왼쪽 아래에 있는 heater/dhw/buffertank의 각 상태를 불러와서 보여줌
//    property string dhwBoostText: "ON"
//    property string bufferTankText: "30"

    //0 : Heater, 1 : DHW Boost, 2 : Buffer Tank
    property variant listStates: ["ON", "ON", "30"]

    //tank 그림
//    property string toptankText: "888" //탱크 상/하단 온도를 불러와서 보여줌
//    property string bottomtankText: "888"

    property variant listTankTemps: [654, 456]

    //Circuit state labels
    readonly property variant items: { '0': "Heater", '1': "DHW Boost", '2': "Buffer Tank" }

    signal sigDriveClick()
    signal sigHomeClick()
    signal sigCircuitClick()
    signal sigOutmonitoringClick()

    //Iniitalize view data  //code by pms
    Component.onCompleted: {
        var varCircuitData = {
           "strInsideTemp": "30",           // inside temperature
           "strResolveTemp": "28",          // resolved inside temperature
           "strOutsideTemp": "32",          // outside temperature.
           "strInWaterTemp": "30",          // input water temperature.
           "strOutWaterTemp": "25",         // out water temperature.
           "listCircuitStates": ["ON", "ON","30"],
           "listTankTemps": ["888", "555"],
        };

        //인터페이스 연결 코드 - 현재 사용 못함.
//        varCircuitData = appModel.GetMonitorInData();

        //Serialize data.
        circuitInsideText = varCircuitData["strInsideTemp"];
        console.log("Inside temp        : " + circuitInsideText);
        circuitSetInsideText = varCircuitData["strResolveTemp"];
        console.log("Resolved temp      : " + circuitSetInsideText);
        outsideTempText = varCircuitData["strOutsideTemp"];
        console.log("Outside temp       : " + outsideTempText);
        inleText = varCircuitData["strInWaterTemp"];
        console.log("Input water temp   : " + outsideTempText);
        outletText = varCircuitData["strOutWaterTemp"];
        console.log("Output water temp  : " + outsideTempText);
        listStates = varCircuitData["listCircuitStates"];
        for(var itemState in listStates)
            console.log("Circuit state  : " + listStates[itemState]);
        listTankTemps = varCircuitData["listTankTemps"];
        for(var itemTank in listTankTemps)
            console.log("Tank temps     : " + listTankTemps[itemTank]);

    }


    Image{
        id:backgroundimg
        anchors.fill:parent
        source:Variables.sourcePath+"img_monitoring_inside.png"

        PageTitle{
            id:title
            width:parent.width
            height:38
            lefticonname: "home"
            righticonname: "menu_alarm"
            backgoundOpacity:0.5
            onSigRClickPage:{
                sigDriveClick()
            }
            onSigLClickPage:{
                sigHomeClick()
            }
        }

        Rectangle{
            id:content
            color:"transparent"
            width:parent.width
            height:root.height-title.height
            y:title.height

            Textmold{
                id:circuit
                x:14;y:14
                width:210
                height:70
                radius:5
                color:"#F47937";shadowColor:"#F47937";shadowOpacity:0.3;shadowRadius:5;shadowVerticalOffset:3
                fontsize: 16;fontcolor: "#FFFFFF"
                textfieldWidth:76;textfieldHeight:16;textfieldX:8;textfieldY:7
                textfieldText: qsTr("Circuit")
                IconTemp{
                    id:insideTemp
                    width:86;height:33
                    x:8;y:33
                    textfieldX:28;textfieldWidth: 58;textfieldHeight:insideTemp.height;
                    fontsize: 28; fontcolor: "#FFFFFF"
                    textfieldText:circuitInsideText+"°"
                    verticalAlignment:Text.AlignTop
                    iconWidth:24
                    iconY: 5
                    iconImageName: "temp"
                }
                IconTemp{
                    id:setinsideTemp
                    width:86;height:33
                    x:100;y:33
                    textfieldX:28;textfieldWidth: 58;textfieldHeight:insideTemp.height
                    fontsize: 28; fontcolor: "#FFFFFF"
                    textfieldText:circuitSetInsideText+"°"
                    verticalAlignment:Text.AlignTop
                    iconWidth:24;iconY: 5
                    iconImageName: "temp_settemp_x20"
                }

                MouseArea{
                    anchors.fill:parent
                    onReleased: {
                        sigCircuitClick()
                    }
                }
            }

            IconTemp{
                id:outsideTemp
                width:61;height:28
                x:411;y:14
                textfieldX:22;textfieldWidth: 39;textfieldHeight:outsideTemp.height
                fontsize: 24; fontcolor: "#696969"
                textfieldText:outsideTempText+"°"
                verticalAlignment:Text.AlignTop
                iconWidth:20;iconY: 4
                iconImageName: "temp_outside"
            }

            TitleBarButton{
                id:arrowbtn
                x:436;y:103
                width:36;height:width
                imagename: "arrow_right"
                onSigClick: {
                    sigOutmonitoringClick()
                }
            }

            Rectangle{
                id:inleNoutlet
                IconTemp{
                    id:inle
                    width:iconWidth+39+4;height:28
                    x:22;y:96
                    textfieldX:28;textfieldWidth: 39;textfieldHeight:28
                    fontsize: 24; fontcolor: "#222222"
                    textfieldText:inleText+"°"
                    verticalAlignment:Text.AlignTop
                    iconWidth:24;iconY: 2
                    iconImageName: "monitoring_inle"
                }
                IconTemp{
                    id:outlet
                    width:iconWidth+39+4
                    height:28
                    x:111
                    y:96
                    textfieldX:28
                    textfieldWidth:39
                    textfieldHeight:28
                    fontsize:24
                    fontcolor:"#222222"
                    textfieldText:outletText+"°"
                    verticalAlignment:Text.AlignTop
                    iconWidth:24
                    iconY: 2
                    iconImageName: "monitoring_outlet"
                }
            }

            Rectangle{
                id:etc
                x:14;y:135.5
                width:180;height:96.5
                color:"transparent"
                Rectangle{id:midLine;width:180;height:2;color:"#CED3DB";}

                Column{
                    topPadding: 10.5
                    spacing: 12
                    Repeater{
                        model:3
                        Rectangle{
                            color:"transparent"
                            width:180;height:16
                            Image{
                                id:indexPoint
                                width:3
                                height:3
                                anchors.verticalCenter:parent.verticalCenter
                                source: Variables.sourcePath+"ic_monitoring_state.png"
                            }
                            Textmold{
                                id:dhwBoost;
                                x:7;
                                width:90;height:16;
                                fontsize:16;fontcolor:"#222222";
                                //처리 변경 //code by pms
//                                textfieldText:index===1?"DHW Boost":index===2?"Buffer Tnak":""
                                textfieldText: {
                                    console.log(items[index]);
                                    if(index!==0){qsTr(items[index])}
                                    else{qsTr("")}

                                }
                                Image{
                                    width:index===0?24:0
                                    height:index===0?24:0
                                    anchors.verticalCenter:parent.verticalCenter
                                    source: Variables.sourcePath+"ic_sub_heater_1_off.png"}}
                            Textmold{
                                id:bufferTnak;
                                x:53+90+7;
                                width:28.57;height:16;
                                fontsize:16;fontcolor:"#555555";
                                //처리 변경 //code by pms
//                                textfieldText:index===2?bufferTankText+"°":index===1?dhwBoostText:heaterText}
                                textfieldText: {
                                    console.log(listStates[index]);
                                    qsTr(listStates[index]);
                                }
                            }
                        }
                    }
                }
            }

            Textmold{x:222;y:96;width:65;height:14;textfieldWidth:width;textfieldHeight:height;fontsize:14;fontcolor:"#444444";textfieldText:"IDU"}
            Textmold{x:301;y:96;width:65;height:14;textfieldWidth:width;textfieldHeight:height;fontsize:14;fontcolor:"#444444";textfieldText:"Tank"}

            Rectangle{
                width:174;height:112;
                x:218;y:115;color:"transparent"
                Image{
                    id:iduNtank
                    anchors.fill:parent
                    source: Variables.sourcePath+"monitoring_tank_idu.png"
                }
                Item{
                    x:98;y:31
                    Textmold{
                        id:toptank;
                        width:33;height:16;
                        textfieldWidth:width;textfieldHeight:height;
                        fontsize:16;fontcolor:"#444444";
//                        textfieldText:toptankText+"°"
                        textfieldText: {
                            console.log("Tank top side temp : " + listTankTemps[0])
                            listTankTemps[0] + "°";
                        }
                    }
                    Rectangle{
                        id:midlinetank;
                        y:toptank.height+6;
                        width:28;height:1;
                        color:"#000000";opacity:0.08}
                    Textmold{
                        id:bottomtank;
                        y:toptank.height+13;
                        width:33;height:16;
                        textfieldWidth:width;textfieldHeight:height;
                        fontsize:16;fontcolor:"#444444";
//                        textfieldText: bottomtankText+"°"
                        textfieldText: {
                            console.log("Tank bottom side temp : " + listTankTemps[1]);
                            listTankTemps[1] + "°";
                        }
                    }
                }
            }

            Image{
                id:monitoring_heat
                x:406;y:177
                width:64;height:50;
                source:Variables.sourcePath+"monitoring_heat.png"

            }
        }
    }
}
