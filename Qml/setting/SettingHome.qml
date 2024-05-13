import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"


Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    Column{
        TitleBar{
            left_1st_Text:qsTr("Settings")
            onSigLClickTitleBar: {
                Variables.content="Home"
            }
        }
        Column{
            Repeater{
                model:[qsTr("General Setting"),qsTr("SVC Contents"),qsTr("Installer Settings")]
                List{
                    left_1st_Text: modelData
                    onSigClick: {
                        switch(index){
                            case 0:{
                                genSetting.visible=true
                                genSetting.sigReadSettingDefault()
                                break;
                            }
                            case 0:{break;}
                            case 0:{break;}
                        }

                    }
                }
            }
        }
    }

    GeneralSetttings{
        id:genSetting
        visible:false
    }
}
