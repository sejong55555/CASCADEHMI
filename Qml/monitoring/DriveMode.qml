import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"
Item{
    id:root
    width:Variables.sourceWidth;height:Variables.sourceHeight

    property bool lownosie: true //*to Do Global로 빼놓고 읽어와서 해야할지
    property bool antifreeze: false

    signal sigXClick()

    Rectangle{
        id:bg
        anchors.fill:parent
        color:"#DDDDDD"
        opacity: 0.8//should check opacity ori 0.4
    }

    Column{
        topPadding: 40
        leftPadding:28
        spacing:20
        Textmold{
            opacity: 1
            width:root.width;height:16;textfieldWidth: width;textfieldHeight: height
            fontsize: 16
            textfieldText:lownosie===true?qsTr("Low noise in operation"):qsTr("Low noise not in operation")
            shadowEnable:false;textshadowEnable:false
        }
        Textmold{
            opacity: 1
            width:root.width;height:16;textfieldWidth: width;textfieldHeight: height
            fontsize: 16
            textfieldText:antifreeze===true?qsTr("Antifreeze in operation"):qsTr("Antifreeze not in operation")
            shadowEnable:false;textshadowEnable:false
        }
    }

    TitleBarButton{
        id: xsymbol
        x:428;y:8
        width:32;height:width
        imagename:"title_close"
        onSigClick: {
            sigXClick()
        }
    }
}
