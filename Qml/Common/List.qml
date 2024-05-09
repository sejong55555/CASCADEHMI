import QtQuick 2.7
import QtQuick 2.10
import QtQml 2.0
import "../Global"

Rectangle {
    id:root
    width:480;height:48;color:"transparent"
    property bool expand1: false
    property bool expand2: false //for expand type

    // color:"#FFFFFF"
    property string imagestate: "n";
    property string imagename: "done"

    property alias textBoxspacing: titleMoldRow.spacing
    property alias textBoxLeftPadding: titleMoldRow.leftPadding
    property alias left_1st_Text:left_1st_Textfield.textfieldText
    property alias left_2nd_Text:left_2nd_Textfield.textfieldText

    property alias left_1st_TextColor: left_1st_Textfield.fontcolor
    property real textOpacity:1
    property alias left_2nd_TextColor: left_2nd_Textfield.fontcolor


    property alias iconX :iconrange.x
    property alias iconY :iconrange.y
    property string icon_source:"circuit_1"
    property alias iconW :iconrange.width
    property alias iconH :iconrange.height

    property alias leftcolW: leftcol.width

    property alias rightItemrangeX :rightItemrange.x
    property alias rightItemrangeY :rightItemrange.y
    property alias rightTextBoxColor: rightItemrange.fontcolor
    property alias rightTextBoxOpacity: rightItemrange.fontOpacity
    property alias rightTextBoxW:rightItemrange.width
    property alias rightTextBoxClip:rightItemrange.textfieldClip

    property alias rightItemsource :componentLoader.sourceComponent
    property string rightItemsourceUrl : componentLoader.source

    property string rightItemtextField: ""
    property string rightIconImage: "schedule_cool"
    property string rightIconText: ""

    property string custumText1:""
    property string custumText2:""
    property bool custumState

    property string radioLtext
    property string radioRtext
    property int radioLBoxW:113
    property int radioRBoxW:104
    property bool radioExclusive

    property alias zth: rightItemrange.z
    property alias mouseEnable: mousearea.enabled

    signal sigClick()

    signal sigradioLClick()
    signal sigradioRClick()

    signal sigradioLOff()
    signal sigradioROff()

    signal sigtoggleOff()
    signal sigtoggleOn()

    signal siginitchecked()
    signal sigTextFieldInit()

    signal sigTextFieldFocus()
    signal sigComponentEnable(bool _enableFlag)

    Column{
        // spacing:14;topPadding: 15//const
        Rectangle{
            id:rowmold;width:root.width;height:root.height-1;
            color:"transparent"

            Image{
                id:iconrange
                x:16;width:30;height:30
                source:Variables.sourcePath+"ic_"+icon_source+".png"
                anchors.verticalCenter: parent.verticalCenter
            }
            Row{
                id:titleMoldRow
                spacing: 20//const
                leftPadding: 20;rightPadding: 20 //default
                anchors.verticalCenter: parent.verticalCenter

                Rectangle{
                    id:leftcol
                    width:440;height:18
                    color:"transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    Textmold {
                        id: left_1st_Textfield
                        fontOpacity:textOpacity
                        width:parent.width
                        height:18
                        textfieldWidth:width
                        textfieldHeight:height
                        color:"transparent"
                        fontsize:18
                        fontcolor:"#222222"
                        shadowEnable:false
                        textfieldText: qsTr("List Title")
                    }
                    Textmold {
                        id: left_2nd_Textfield
                        visible:false
                        y:left_1st_Textfield.height+2 //spacing
                        width:parent.width
                        height:14
                        textfieldWidth:width
                        textfieldHeight:height
                        color:"transparent"
                        fontsize: 14
                        fontcolor: "#555555"
                        shadowEnable:false
                        textfieldText: qsTr("List Title")
                    }
                }

                Textmold{//have to change to item
                    //You can align the x-coordinate of the right item(component) to this x-coordinate
                    id:rightItemrange
                    fontOpacity: textOpacity
                    anchors.verticalCenter: parent.verticalCenter
                    fontsize: 18
                    width:0;height:0;textfieldWidth:width;textfieldHeight:height;
                    color:"transparent";
                    fontcolor:"#555555"
                    horizontalAlignment: Text.AlignRight
                    shadowEnable:false
                    visible: true
                    textfieldText: rightItemtextField
                    Loader {
                        id:componentLoader;
                        visible:(root.state==="B")?false:true;anchors.fill:parent;
                        sourceComponent:null;
                        source:rightItemsourceUrl;
                        onLoaded: {
                            if(root.state==="C"){
                                item._sigtoggleOn.connect(sigtoggleOn)
                                item._sigtoggleOff.connect(sigtoggleOff)
                            }
                            else if(root.state==="D_icon")
                            {
                                item.iconWidth=24
                                item.iconHeight=24
                                item.fontsize=18
                                item.textIcondistance=4
                                item.iconImageName=rightIconImage
                                item.textLabel=rightIconText
                            }

                            else if(root.state==="E"){
                                item.leftRadiotext=radioLtext
                                item.rightRadiotext=radioRtext
                                item.leftRadioBoxW=radioLBoxW
                                item.rightRadioBoxW=radioRBoxW
                                item.btnGroupExclusive=radioExclusive
                                item._sigradioLClick.connect(sigradioLClick)
                                item._sigradioRClick.connect(sigradioRClick)

                                item._sigradioLOff.connect(sigradioLOff)
                                item._sigradioROff.connect(sigradioROff)
                            }

                            else if (root.state==="F"){
                                item.defaultText=custumText1
                                item.activeText=custumText2
                            }
                        }
                    }
                    MouseArea{
                        id:loderClickBlock
                        enabled:textOpacity===1?false:true
                        anchors.fill:parent
                    }
                }
            }

            MouseArea{
                id:mousearea
                anchors.fill:parent
                enabled:textOpacity===1?true:false
                z:componentLoader.z-1
                onClicked:{
                    sigClick()
                }
            }
        }
        Rectangle{
            id:bottomline
            anchors.horizontalCenter: parent.horizontalCenter
            width:expand1===true?440:root.width;height:1;color:"#DEE1E5"
        }
    }

    state:"A"

    //states are for only mold size.
    states: [
        State{
            name:"A"//default
            PropertyChanges {target:root;rightItemsourceUrl:""}
            PropertyChanges {target:rightItemrange;visible:false}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"B"//single btn
            PropertyChanges {target:root;rightItemsourceUrl:""}
            PropertyChanges {target:titleMoldRow;leftPadding:(expand1===true)?44:(expand2===true)?64:20}
            PropertyChanges {target:leftcol;width:(expand1===true)?280:220;}
            PropertyChanges {target:rightItemrange;width:(expand1===true)?116:200;height:18}
            PropertyChanges {target: root; color:(expand1||expand2===true)?"#F3F3F3":"transparent"}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"C"//twice btn
            PropertyChanges {target:root;rightItemsourceUrl:"CToggleButton.qml"}
            PropertyChanges {target:titleMoldRow;leftPadding:(expand1===true)?44:20}
            PropertyChanges {target:leftcol;width:(expand1===true)?359:383;}
            PropertyChanges {target:rightItemrange;width:37;height:20;}
            PropertyChanges {target:root;color:(expand1||expand2===true)?"#F3F3F3":"transparent"}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"D"//toggle
            PropertyChanges {target:root;rightItemsourceUrl:""}
            PropertyChanges {target:leftcol;width:220;height:34}
            PropertyChanges {target:rightItemrange;width:200;height:18}
            PropertyChanges {target:left_2nd_Textfield;visible:true}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"D_icon"
            PropertyChanges {target:root;rightItemsourceUrl:"IconTextButton.qml"}
            PropertyChanges {target:leftcol;width:220;height:34}
            PropertyChanges {target:left_2nd_Textfield;visible:true}
            PropertyChanges {target:rightItemrange;width:58;height:24}
            PropertyChanges {target:titleMoldRow;spacing:162}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"E"
            PropertyChanges {target:root;rightItemsourceUrl:"CRadioRow.qml"}
            PropertyChanges {target:leftcol;width:183;}
            PropertyChanges {target:rightItemrange;width:237;height:32}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"F"
            PropertyChanges {target:root;rightItemsourceUrl:"CTextField.qml"}
            PropertyChanges {target:leftcol;width:180;}
            PropertyChanges {target:rightItemrange;width:240;height:30}
            PropertyChanges {target:iconrange;width:0;height:0;}
        },
        State{
            name:"G"
            PropertyChanges {target:titleMoldRow;spacing:8;leftPadding:54}
            PropertyChanges {target:leftcol;width:406;}
            PropertyChanges {target:rightItemrange;visible:false}
        },
        State{
            name:"H"
            PropertyChanges {target:titleMoldRow;spacing:20;leftPadding:54}
            PropertyChanges {target:leftcol;width:186;}
            PropertyChanges {target:rightItemrange;width:200;height:18;}
        },
        State{
            name:"I"
            PropertyChanges {target:titleMoldRow;leftPadding:60;}
            PropertyChanges {target:leftcol;width:400;height:34}
            PropertyChanges {target:left_2nd_Textfield;visible:true}
            PropertyChanges {target:rightItemrange;visible:false}
        }
    ]

    onSiginitchecked:{
        componentLoader.item._siginitchecked()
    }

    onSigTextFieldFocus:{
        componentLoader.item._sigFocusOff()
    }

    onSigTextFieldInit:{
        componentLoader.item._sigTextFieldInit()
    }

    onSigComponentEnable:{
        componentLoader.item.clickEnable=_enableFlag
    }

    function rightToggleInit(){
        componentLoader.item._sigleftToggleInit()
    }

    function titleToggleInit(toggledefalut){
        componentLoader.item.sigtoggleInit(toggledefalut)
    }

    function toggleDim(dimflag){
        componentLoader.item.imagestate=dimflag
    }
}
