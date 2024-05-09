import QtQuick 2.7

Item {
    id:root
    property alias firstbtnText: firstbtn.btntext
    property alias secondbtnText: secondbtn.btntext

    property alias firstbtnW: firstbtn.width
    property alias firstbtnH: firstbtn.height

    property alias secondbtnW: secondbtn.width
    property alias secondbtnH: secondbtn.height

    property alias firstimageName:firstbtn.imagename
    property alias secondimageName:secondbtn.imagename

    property alias firstfontcolor:firstbtn.fontcolor
    property alias secondfontcolor:secondbtn.fontcolor

    property alias firstTitleBarimageName:firstTitlebtn.imagename
    property alias secondTitleBarimageName:secondTitlebtn.imagename

    property alias rowspacing: btnrow.spacing
    property alias rowleftPadding:btnrow.leftPadding
    property alias rowtopPadding:btnrow.topPadding
    property bool textBtnType: true // or "image"

    signal sigClick()
    signal sigRowRClickIn()
    signal sigRowLClickIn()

    Row{
        id:btnrow
        anchors.fill:parent
        spacing:15
        TextButton{id:firstbtn;imagename:"cmd_gray";btntext:"Text";visible:textBtnType
            onSigClick:{
                sigRowLClickIn()
            }
        }
        TextButton{id:secondbtn;imagename:"cmd_orange";btntext:"Text";visible:textBtnType
            onSigClick:{
                sigRowRClickIn()
            }
        }
        TitleBarButton{id:firstTitlebtn;visible:(!textBtnType)
            onSigClick:{
                sigRowLClickIn()
            }
        }
        TitleBarButton{id:secondTitlebtn;visible:(!textBtnType)
            onSigClick:{
                sigRowRClickIn()
            }
        }
    }
}
