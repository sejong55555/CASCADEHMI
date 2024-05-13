import QtQuick 2.7
import QtQuick 2.10
import QtQml 2.0
import "../Global"

Rectangle {
    id:root
    width:480;height:52;color:"#FFFFFF"

    property string imagename:"add"
    property string imagestate: "n";
//    property string imagename_L: "more";property string imagename_R: "more"
    property string icon_source:"circuit_1"


    property alias left_1st_Text:titleText.textfieldText
    //for aligning the x-coordinates of the icon and right Item
    property alias iconX :iconrange.x
    property alias iconY :iconrange.y

    property alias rightItemrangeX :rightItemrange.x
    property alias rightItemrangeY :rightItemrange.y

    property alias rightItem_source :componentLoader.sourceComponent
    property alias rightItemsourceUrl :componentLoader.source

    property alias rightItemrangeVisible: rightItemrange.visible

    signal sigLClickTitleBar()
    signal sigRClickTitleBar()

    signal sigRowRClick()
    signal sigRowLClick()

    Column{
        id:titleMoldCol
        spacing: 8;topPadding: 10//const
        Row{
            id:titleMoldRow
            spacing: 8//const
            leftPadding: 16;rightPadding: 10 //default

            TitleBarButton{
                id:returnArrow
                width:32;height:32
                imagename: "back"
                onSigClick: {
                    sigLClickTitleBar()
                }
            }
//             Image{
//                 id:returnArrow
//                 // property bool forcolor : true
//                 width:32;height:32

//                 source:Variables.sourcePath+"btn_back_"+imagestate+".png"
//                 anchors.verticalCenter: parent.verticalCenter
//                 // Rectangle{anchors.fill:parent;color:returnArrow.forcolor===true?"pink":"#555555";opacity:0.8}
//                 MouseArea{
//                     anchors.fill:parent
//                     onPressed: {
// //                        returnArrow.forcolor=false
//                         sigLClick()
//                     }
//                     onReleased: {
// //                        returnArrow.forcolor=true
//                     }
//                 }
//             }
            Image{
                //You can align the x-coordinate of the icon to this x-coordinate
                id:iconrange
                width:0;height:0;
                source:Variables.sourcePath+"ic_"+icon_source+".png"
                anchors.verticalCenter: parent.verticalCenter
            }
            Textmold{
                id:titleText
                //textfield W,H have to be changed depending on the states.
                width:408;height:18;
                textfieldWidth:width;textfieldHeight:height;fontsize: 18
                color:"transparent"
                anchors.verticalCenter: parent.verticalCenter
                textfieldText:"Title"
                shadowEnable:false
                textshadowEnable: false
            }

        }

        Rectangle{
            id:bottomline
            width:root.width;height:2;color:"#DEE1E5"
        }
    }

    Rectangle{
       //You can align the x-coordinate of the right item(component) to this x-coordinate
        id:rightItemrange
//            anchors.verticalCenter: parent.verticalCenter
        width:0;height:0;
        // color:"green"
        visible:true

        Loader {
            id:componentLoader;
            anchors.fill:parent;
            asynchronous: true
            sourceComponent:null;
            source:"";
            onLoaded: {
                if(root.state==="C"){
                    item.textBtnType=false
                    item.firstTitleBarimageName="delete"
                    item.secondTitleBarimageName="done"
                    item.rowspacing=10
                    item.sigRowLClickIn.connect(sigRowLClick)
                    item.sigRowRClickIn.connect(sigRowRClick)
                }
                else if(root.state==="B"){
                    item.imagename=imagename
                    item.sigClick.connect(sigRClickTitleBar)
                }
                else if(root.state==="D"){
                }
                else if(root.state==="F"){
                    item.sigClick.connect(sigRClickTitleBar)
                }
                else if(root.state==="G"){
                    item.sigClickSwitch.connect(sigRClickTitleBar)
                }
                else{
                    item.imagename=imagename
                }
            }

            // Connections{
            //     id:connection
            //     target:componentLoader.item
            //     onSigClick:{
            //         sigRClickTitleBar()
            //     }
            // Connections {
            //     id:connection
            //     target:componentLoader.item
            //     onSigClick:{
            //         sigRClickTitleBar()
            //     }
                // onSigRowLClickIn:{
                //     sigRowLClick()
                // }
                // onSigRowRClickIn:{
                //     sigRowRClick()
                // }
            // }
            // }
        }
    }
    state:"A"

    //states are for only mold size.
    states: [
        State{
            name:"A"//default
            PropertyChanges {target:titleMoldRow;rightPadding:16}
            PropertyChanges {target:rightItemrange;visible:false}
        },
        State{
            name:"B"//single btn
            PropertyChanges {target:root;rightItemsourceUrl:"TitleBarButton.qml";imagename:"more"}
            PropertyChanges {target:rightItemrange;width:32;height:32;x:root.x+438;y:root.y+10}
            PropertyChanges {target:titleText;width:372;}
            // PropertyChanges {target: componentLoader;source:"TitleBarButton.qml";}
        },
        State{
            name:"C"//twice btn
            PropertyChanges {target:root;rightItemsourceUrl:"TextButtonRow.qml";imagename:"more"}
            PropertyChanges {target:rightItemrange;width:122;height:30;x:root.x+348;y:root.y+11}
            PropertyChanges {target:titleText;width:282;}
        },
        State{
            name:"D"//toggle
            PropertyChanges {target:rightItemrange;width:37;height:20;x:root.x+433;y:root.y+16}
            PropertyChanges {target:titleText;width:367;}
        },
        State{
            name:"E"
            PropertyChanges {target:root;rightItemsourceUrl:"TextButton.qml";}
            PropertyChanges {target:rightItemrange;width:90;height:30;x:root.x+380;y:root.y+11}
            PropertyChanges {target:titleText;width:314;}
        },
        State{
            name:"F"
            PropertyChanges {target:root;rightItemsourceUrl:"TitleBarButton.qml";imagename:"add"}
            PropertyChanges {target:iconrange;width:30;height:30;}
            PropertyChanges {target:rightItemrange;width:56;height:30;x:root.x+414;y:root.y+11}
            PropertyChanges {target:titleText;width:300;height:18;}
        },
        State{
            name:"G"
            PropertyChanges {target:root;rightItemsourceUrl:"TitleBarSwitchButton.qml";imagename:"switch"}
            PropertyChanges {target:rightItemrange;width:104;height:30;x:root.x+366;y:root.y+11}
            PropertyChanges {target:titleText;width:302;height:18;}
        }
    ]
}
