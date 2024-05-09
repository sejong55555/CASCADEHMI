import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"

Textmold {
    id: root
    width:215;height:188;radius:6
    //*to do runmode auto, heat색상표 받아야함
    color:(runmode==="Cool")?"#4D85DB":(runmode==="Hot water"||runmode==="Heat")?"#F47937":(runmode==="Auto")?"#9253EB":"#919FB5"

    property string runmode:"Cool" //박스 색상과 아래쪽 runmode 표시를 위함, 설정할 circuit device
    property string currentTempiconImage: "water2"

    property bool onNoff: true
    property string precolor

    property real currentTemp: 21.5//아래 현재 온도
    // property real maxTemp:23//가운데 온도 설정 최대값
    // property real minTemp:0//가운데 온도 설정 최소값
    property real maxTemp:runmode==="Cool"?Variables.coolmax:runmode==="Heat"?Variables.heatmax:Variables.automax
    property real minTemp:runmode==="Cool"?Variables.coolmin:runmode==="Heat"?Variables.heatmin:Variables.automin

    property real tempStep: Variables.tempStep //defult :1 (can 0.5) 설정 온도 올라가는 범위 스텝

    //가운데 보이는 설정온도
    property real setTemp:(runmode==="Cool")?Variables.defaultCoolTemp:(runmode==="Heat")?Variables.defaultHeatTemp:(runmode==="Auto")?Variables.defaultAutoTemp:Variables.defaultHotTemp
    property string naturalTempText
    property string pointTempText

    signal sigdeviceOff()

    textfieldWidth:195;textfieldHeight:16; fontsize:16; fontcolor:"#FFFFFF"
    textfieldX:10; textfieldY:16
    textfieldText: qsTr("Circuit")
    horizontalAlignment: Text.AlignHCenter
    shadowEnable:false

    Item{
        id:outmold
        UpDownButton{
            x:147;y:66
            onSigupClick: {
                setTemp+=tempStep
                if(setTemp<minTemp){
                    setTemp=minTemp
                }
                else if(setTemp>maxTemp){
                    setTemp=maxTemp
                }
            }
            onSigdownClick: {
                setTemp-=tempStep
                if(setTemp<minTemp){
                    setTemp=minTemp
                }
                else if(setTemp>maxTemp){
                    setTemp=maxTemp
                }
            }
        }

        IconTemp{
            id:currentstate
            x:71
            y:154
            width:textfieldX+textfieldWidth
            height:24
            iconWidth:20;iconHeight:20;iconY:4
            textfieldWidth:48;textfieldHeight:24;
            textfieldX: iconWidth+4;
            fontcolor: "#FFFFFF";fontsize: 20
            shadowEnable: false;textshadowEnable: false
            iconImageName:currentTempiconImage
            textfieldText:currentTemp+"°";
        }
        Textmold{
            id:naturalTempTextmold
            x:40
            y:59
            width:68
            height:70;
            textfieldWidth:68;textfieldHeight:70;fontspacing: -2
            fontcolor:"#FFFFFF";fontsize: 60;
            shadowEnable: false
            textshadowEnable: true
            horizontalAlignment:Text.AlignHCenter
            textfieldText: naturalTempText
        }
        Textmold{
            id:pointTempTextmold
            x:108
            y:81
            width:29
            height:42
            textfieldWidth:29;textfieldHeight:42;fontspacing: -2
            fontcolor:"#FFFFFF";fontsize:36;
            shadowEnable: false
            textshadowEnable: true
            horizontalAlignment:Text.AlignHCenter
            textfieldText: "."+pointTempText

        }
        Textmold{
            id:tempSymbolText
            width:11;height:42;x:126;y:64
            textfieldWidth:11;textfieldHeight:42
            fontcolor:"#FFFFFF"
            fontsize: 36
            textfieldText: "°"
            shadowEnable: false
            textshadowEnable: true
            horizontalAlignment:Text.AlignHCenter
        }
    }

    Textmold{
        id:offtextmold
        visible:false
        width:120;height:40;x:47;y:74
        horizontalAlignment: Text.AlignHCenter
        textfieldWidth:120;textfieldHeight:40;textfieldText:"OFF"; fontsize: 40;fontcolor:"#222222"
        shadowEnable: false;textshadowEnable: false
    }

    TitleBarButton{
        id:powersymbol

        width:28;height:width
        x:179;y:152
        imagename:"power"
        onSigClick: {
            if(onNoff===true){
                precolor = runmode;runmode=""
                onNoff = false
                offtextmold.visible=true
                outmold.visible=false

                //*to do off했을 때 engine으로 off신호 보내는 함수 call
                sigdeviceOff()
            }
            else{
                runmode = precolor
                onNoff = true
                offtextmold.visible = false
                outmold.visible = true

                //*to do on했을 때 현재 온도 가져오고 engine으로 신호를 setTemp 데이터 보내서 특정 함수 call해야한다.
            }
        }
    }

    // Component.onCompleted: {
    //     naturalTempText = setTemp.toString().split(".")[0]
    //     pointTempText = setTemp.toString().split(".")[1] || '0'
    //     //engine에서 현재 온도 가져오는 함수로 current Temp 설정해야함.
    // }

    //Initialize view data.         //code by pms
    Component.onCompleted: {
        var varData = { "currentTemp": 21.5,
                        "resolvedTemp": 20.0 }

        //실제 코드 : 현재 사용 못함.
//         varData = appModel.GetCircuitTemp(runmode);

        currentTemp = varData["currentTemp"];
        setTemp = varData["resolvedTemp"];

        naturalTempText = setTemp.toString().split(".")[0]
        pointTempText = setTemp.toString().split(".")[1] || '0'
    }

    onSetTempChanged: {
        naturalTempText = setTemp.toString().split(".")[0]
        pointTempText = setTemp.toString().split(".")[1] || '0'
        //engine으로 신호 보내는 부분 함수??있어야함
    }

    onRunmodeChanged: {
        if(runmode==="Cool"){
            setTemp=Variables.defaultCoolTemp
        }
        else if(runmode==="Heat"){
            setTemp=Variables.defaultHeatTemp
        }
        else if(runmode==="Auto"){
            setTemp=Variables.defaultAutoTemp
        }
        else{
            setTemp=Variables.defaultHotTemp
        }
    }
}
