import QtQuick 2.7
import "../Global"
import "../Common"
//mold안에 보여줄 content중 heating
Rectangle{
    id:heatingContents

    width:textBoxW+iconW+iconToTextSpacing;
    height:heatingmodel.count*(textBoxH+view.spacing);

    property var themodel

    property real textBoxW: 32
    property real textBoxH: 30

    property real iconToTextSpacing: 6

    property real iconW: 28
    property real iconH: 28

    Column{
        id:view
        spacing:6
        Repeater{
            model:themodel
            IconTextButton{
                id:iconToText
                width:iconWidth+textIcondistance+textBoxWidth
                height: textBoxHeight

                fontcolor:"#555555"
                fontsize:textBoxHeight-2
                iconImageName:iconimagename;
                imagestate: "m"
                textLabel:temp
                textIcondistance: iconToTextSpacing
                iconWidth: iconW;iconHeight: iconWidth
                textBoxWidth:textBoxW;textBoxHeight:textBoxH
            }
        }
    }

    ListModel{id:heatingmodel}

    states:[
        State{
            name:"xxl"
            PropertyChanges{target:heatingContents;iconW:14;iconH:width;textBoxW:17;textBoxH:16;iconYToTextSpacing:4}
        },
        State{
            name:"xl"
            PropertyChanges{target:heatingContents;iconW:28;iconH:width;textBoxW:32;textBoxH:30;iconToTextSpacing:6}
        },
        State{
            name:"l"
            PropertyChanges{target:heatingContents;iconW:28;iconH:width;textBoxW:32;textBoxH:30;iconToTextSpacing:6}
        },
        State{
            name:"m"
            PropertyChanges{target:heatingContents;iconW:14;iconH:width;textBoxW:17;textBoxH:16;iconToTextSpacing:4}
            PropertyChanges {target: view;spacing:0}
        },
        State{
            name:"s"
            PropertyChanges{target:heatingContents;iconW:14;iconH:width;textBoxW:17;textBoxH:16;iconToTextSpacing:4}
            PropertyChanges {target: view;spacing:0}
        },
        State{
            name:"xs"
            PropertyChanges{target:heatingContents;iconW:14;iconH:width;textBoxW:17;textBoxH:16;iconToTextSpacing:4}
            PropertyChanges {target: view;spacing:0}
        }
    ]
}
