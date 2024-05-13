import QtQuick 2.7
import QtQml 2.0
import "../Global"
import "../Common"

Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    signal sigGetwifiSignal()
    // signal sigFailure()

    signal sigGetsignalFromApp()
    // signal sigFailure()

    Column{
        TitleBar{
            id:title
            left_1st_Text: qsTr("Remote Controller Wi-Fi Pairing")
            state:"A"
            onSigLClickTitleBar: {
                root.visible=false
                appconnectloading.animationStop()
                readyloading.animationStop()
                visibleInit()
            }
        }
        Item{
            id:contentmold
            width:Variables.sourceWidth
            height:Variables.sourceHeight-title.height
            Rectangle{
                id:paringmain
                anchors.fill:parent
                visible:true
                Text{
                    x:20
                    y:64
                    width:440
                    height:40
                    color:"#222222"
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("Wi-Fi 사용을 위해 LG ThinQ 앱에서\nWi-Fi를 설정해주세요.")
                }
                TextButton{
                    x:182
                    y:120
                    imagename:"cmd_gray"
                    btntext:qsTr("연결")
                    onSigClick: {
                        paringmain.visible=false
                        appconnecting.visible=true
                        //to do inf에 신호 보냄
                        //성공 신호 받기 iswifi변경 10초 설정 initDone받고
                        //실패 신호 받기
                        appconnectloading.initStart()
                    }
                }

            }

            Rectangle{
                id:appconnecting
                anchors.fill:parent
                visible:false
                SettingInitialize{
                    id:appconnectloading
                    textBoxText:qsTr("연결중")
                    fontsize:18
                    fontcolor:"#696969"
                    colTopPadding:46
                    anchors.fill:parent
                    onSigInitDone: {
                        sigGetsignalFromApp()//성공 신호를 받았다고 가정
                        // sigFailure()
                    }
                }
                Text{
                    x:20
                    y:142
                    width:440
                    height:20
                    font.pixelSize: 20
                    color:"#222222"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("LG ThinQ 앱과 연결중입니다.")
                }
            }

            Rectangle{
                id:ready
                anchors.fill:parent
                visible:false
                SettingInitialize{
                    id:readyloading
                    textBoxText:qsTr("대기중")
                    fontsize:18
                    fontcolor:"#696969"
                    colTopPadding:46
                    anchors.fill:parent
                    onSigInitDone: {
                        sigGetwifiSignal()//연결 성공 신호를 받았다고 가정
                    }
                }
                Text{
                    x:20
                    y:142
                    width:440
                    height:20
                    font.pixelSize: 20
                    color:"#222222"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("LG ThinQ 앱에서 Wi-Fi 설정을 완료해주세요.")
                }
            }
            Rectangle{
                id:success
                anchors.fill:parent
                visible:false
                Image{
                    x:217
                    y:41
                    width:46
                    height:35
                    source: Variables.sourcePath+"ic_wifi_connected.png"
                }
                Text{
                    x:20
                    y:90
                    width:440
                    height:40
                    font.pixelSize: 20
                    color:"#222222"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("Wi-Fi가 연결되어있습니다.\nLG ThinQ 앱에서 제품을 제어할 수 있습니다.")
                }
                TextButton{
                    x:182
                    y:146
                    imagename:"cmd_gray"
                    btntext:qsTr("연결")
                    onSigClick: {
                        success.visible=false
                        ready.visible=true
                        readyloading.initStart()
                    }
                }

            }
            Rectangle{
                id:failure
                anchors.fill:parent
                visible:false
                Image{
                    x:217
                    y:41
                    width:46
                    height:35
                    source: Variables.sourcePath+"ic_wifi_unconnected.png"
                }
                Text{
                    x:20
                    y:90
                    width:440
                    height:40
                    font.pixelSize: 20
                    color:"#222222"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("Wi-Fi 연결에 문제가 있습니다.\n공유기의 상태를 확인해주세요.")
                }
                TextButton{
                    x:182
                    y:146
                    imagename:"cmd_gray"
                    btntext:qsTr("연결")
                    onSigClick: {
                        success.visible=false
                        ready.visible=true
                        readyloading.initStart()
                    }
                }

            }

        }
    }

    property bool isWificonnect:false

    onSigGetsignalFromApp: {
        appconnectloading.visible=false
        ready.visible=true
        readyloading.initStart()
    }

    onSigGetwifiSignal: {
        isWificonnect=true//wifi 연결 상태를 읽어옴 성공이라고 가정
        // isWificonnect=false
        if(isWificonnect){
            success.visible=true
        }
        else if(!isWificonnect){
            failure.visible=true
        }

        ready.visible=false
    }

    function visibleInit(){
        success.visible=false
        failure.visible=false
    }

    Component.onCompleted: {
        isWificonnect=false //to do wifi 상태 read
    }
}
