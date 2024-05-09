import QtQuick 2.7
import "../Global"
import "../layout"
import "../Common"
Rectangle {
    id: root
    width:Variables.sourceWidth;height:Variables.sourceHeight

    signal sigDriveClick()
    signal sigHomeClick()
    signal sigInmonitoringClick()

    Image{
        id:backgroundimg
        anchors.fill:parent
        source:Variables.sourcePath+"img_monitoring_outside.png"

        PageTitle{
            id:title
            width:parent.width
            height:38
            lefticonname: "home"
            righticonname: "menu_alarm"
            backgoundOpacity:0.5
            onSigRClickPage: {
                sigDriveClick()
            }
            onSigLClickPage: {
                sigHomeClick()
            }
        }

        TitleBarButton{
            id:arrowbtn
            width:36
            height:width
            x:8
            y:140
            imagename: "arrow_left"
            onSigClick: {
                sigInmonitoringClick()
            }
        }

        TitleBarButton{
            id:monitoringInfo
            width:20
            height:width
            x:446
            y:46
            btnORicon:"ic_"
            imagename:"monitoring"
            onSigClick: {
                if(infoPopup.visible===true){
                    infoPopup.visible=false
                }
                else{
                    infoPopup.visible=true
                }
            }
        }

        Item{
            id:infoPopup
            visible:false
            x:31;y:44

            Rectangle{
                id:popupbg
                z:triangle.z+1
                width:405;height:24
                color:"#222222"
                radius:4
                opacity:0.85
                Row{
                    topPadding:6
                    leftPadding:6
                    spacing:6
                    Repeater{
                        model:iconInfomodel
                        Row{
                            IconTextButton{
                                textBaseline:14
                                width:iconWidth+textBoxWidth+textIcondistance;height:14;
                                iconWidth: 14;iconHeight: 14;iconImageName:qsTr(iconNameList);imagestate:"s"
                                fontsize:12;fontcolor: "#FFFFFF"
                                textIcondistance: 2
                                textBoxWidth:textW;textLabel:qsTr(iconTextList)
                            }
                            Textmold{
                                textBaseline:14
                                width:unitW;height:14;textfieldWidth:width;textfieldHeight:height
                                fontsize:12;fontcolor: "#FFFFFF"
                                textfieldText:iconUnitList
                            }
                        }
                    }
                }
            }
            Rectangle{
                id:triangle
                width: 5;height: 6
                x:404.5;y:10;
                rotation: -270
                color:"transparent"
                opacity: 0.85
                Canvas{
                    anchors.fill:parent
                    onPaint:{
                        var context = getContext("2d");

                        context.beginPath();
                        context.moveTo(2.5,0);
                        context.lineTo(5.0, 6.0);
                        context.lineTo(0, 6.0);
                        context.closePath();

                        context.fillStyle = "#222222";
                        context.fill();
                    }
                }
            }
        }
    }
        Item{
            id:devicelistLayout
            width:412;height:186;
            property string layoutNumber: themodel.count

            property var arrX: new Array
            property var arrY: new Array
            property var modelset

            Repeater{
                model:devicelistLayout.modelset
                OutsideDevice{//create outside device components
                    state:size
                    indexText:index
                    deviceNameText:devicename
                    deviceComponentUrl:devicename==="Heating"?"OutsideHeatingContent.qml":"OutsideHeatingContent.qml"
                    contentModel:info
                    Component.onCompleted: {//set coordinates of device components to layout mold
                        x=devicelistLayout.arrX[index]
                        y=devicelistLayout.arrY[index]
                    }
                }
            }
            Loader{
                id:loader
                z:backgroundimg.z-1 //set layout mold
                source:"../layout/Lay"+devicelistLayout.layoutNumber+".qml"
                onLoaded: {
                    devicelistLayout.arrX = item._arrX
                    devicelistLayout.arrY = item._arrY
                }
            }
        }

    ListModel{
        id:themodel
    }

    //범례를 보여주기 위한 model 상태에 따른 변경 없음
    ListModel{
        id:iconInfomodel
        ListElement{iconNameList:"monitoring_inlet_";iconTextList:"Inlet";iconUnitList:" (°C)";textW:"24";unitW:"24"}
        ListElement{iconNameList:"monitoring_outlet_";iconTextList:"Outlet";iconUnitList:" (°C)";textW:"38";unitW:"21"}
        ListElement{iconNameList:"monitoring_flowrate_";iconTextList:"Flow Rate";iconUnitList:" (L/min)";textW:"53";unitW:"42"}
        ListElement{iconNameList:"monitoring_waterpressure_";iconTextList:"Water Pressure";iconUnitList:"(bar)";textW:"86";unitW:"25"}
    }

    function initModel(_count){ //To initialize themodel with reading data
        var sizeList;
        var elementobj=[];
        // switch (elementobj.length) {
        switch (_count) {
              case 0:{
                  sizeList=[]
                  break;}
              case 1:{
                  sizeList=["xxl"]
                  break;}
              case 2:{
                  sizeList=["xl","xl"]
                  break;}
              case 3:{
                  sizeList=["l","l","l"]
                  break;}
              case 4:{
                  sizeList=["l","l","m","m"]
                  break;}
              case 5:{
                  sizeList=["l","m","m","m","m"]
                  break;}
              case 6:{
                  sizeList=["m","m","m","m","m","m"]
                  break;}
              case 7:{
                  sizeList=["m","m","m","s","s","s","s"]
                  break;}
              case 8:{
                  sizeList=["s","s","s","s","s","s","s","s"]
                  break;}
              case 9:{
                  sizeList=["s","s","s","s","xs","xs","xs","xs","xs"]
                  break;}
              case 10:{
                  sizeList=["xs","xs","xs","xs","xs","xs","xs","xs","xs"]
                  break;}
              default:
                  console.log("there are no outside device.");
                   break;
              }
        return sizeList;

    }

    function monitoringModelRead(){

        var sizelist=initModel(nModelCount)

        for(var item in listTitle) {
            // console.log("Title[" + item + "] : " + deviceListData[item]);
            // console.log("size[" + item + "] : " + sizelist[item]);
            themodel.append({devicename:listTitle[item],size:sizelist[item],
                            info:[{iconimagename:"monitoring_inlet_",temp:listInlet[item].toString()}
                                ,{iconimagename:"monitoring_outlet_",temp:listOutlet[item].toString()}
                                ,{iconimagename:"monitoring_flowrate_",temp:listFlowrate[item].toString()}
                                ,{iconimagename:"monitoring_waterpressure_",temp:listWP[item].toString()}]});

        }
        devicelistLayout.modelset=themodel
    }

    property int nModelCount : 0;
        property variant listTitle: [""];
        property variant listInlet: [0];
        property variant listOutlet: [0];
        property variant listFlowrate: [0];
        property variant listWP: [0];

        //Initialize view data      //code by pms
    Component.onCompleted: {
        var varData = { "count"             : 4,
                        "listTitle"         : ["heater", "DWH", "heater", "DWH"],
                        "listInlet"         : [10, 20, 30, 40],
                        "listOutlet"        : [10, 20, 30, 40],
                        "listFlowrate"      : [10, 20, 30, 40],
                        "listWaterpress"    : [10, 20, 30, 40]
        }

        //인터페이스 연결 코드 - 현재 사용 못함.
//        varData = appModel.GetMonitorOutData();

        nModelCount = varData["count"];
        listTitle = varData["listTitle"];
        listInlet = varData["listInlet"];
        listOutlet = varData["listOutlet"];
        listFlowrate = varData["listFlowrate"];
        listWP = varData["listWaterpress"];

////Debug code - delete after.
//        for(var itemTitle in varData["listTitle"])
//            console.log("Title[" + itemTitle + "] : " + listTitle[itemTitle]);
//        for(var itemInlet in varData["listInlet"])
//            console.log("Inlet[" + itemInlet + "] : " + listInlet[itemInlet]);
//        for(var itemOutlet in varData["listOutlet"])
//            console.log("Outlet[" + itemOutlet + "] : " + listOutlet[itemOutlet]);
//        for(var itemFR in varData["listFlowrate"])
//            console.log("Title[" + itemFR + "] : " + listFlowrate[itemFR]);
//        for(var itemWP in varData["listWaterpress"])
//            console.log("WaterPressure[" + itemFR + "] : " + listWP[itemWP]);

        monitoringModelRead()
    }



    // Component.onCompleted: {

    //     // initModel()
    //     monitoringModelRead()

    // }
}
