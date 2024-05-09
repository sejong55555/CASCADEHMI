import QtQuick 2.7
import QtGraphicalEffects 1.0
import "../Common"
//실외기 항목  mold
Item {
    id:root
    property real indexText:0
    property string deviceNameText:"Heating"
    property alias deviceComponentUrl:contentItem.source
    property var contentModel
    Rectangle{
        id:background
        width:132;height:186
        color:"#FFFFFF";radius:8
        opacity: 0.8
    }
    DropShadow {
        id:shadow
        visible: true
        anchors.fill: background
        z: background.z-1
        verticalOffset: 2
        radius: 4
        samples: 1+radius*2
        color: "#000000"
        opacity: 0.1
        source: background
    }

    Text{
        id:deviceName
        x:background.x+10;y:background.y+8;
        width:69;height:16;horizontalAlignment: Text.AlignLeft;verticalAlignment: Text.AlignVCenter
        font.pixelSize:height
        color:"#555555"
        text:deviceNameText
        opacity: 0.9
    }

    Rectangle{
        id:contentBox
        color:"lightgreen"
        Loader{
            id:contentItem
            sourceComponent:null
            onLoaded: {
                item.state=root.state
                item.themodel=contentModel
            }
        }
    }

    Text{
        id:indexBox
        x:background.x+90;y:background.y+10;
        width:32;height:16;horizontalAlignment: Text.AlignRight;verticalAlignment: Text.AlignVCenter
        font.pixelSize:height
        color:"#555555"
        text:indexText
        opacity: 0.9
    }

    state:"large"

    states:[
        State{
            name:"xxl"
            PropertyChanges{target:background;width:412;height:186;}
            PropertyChanges{target:deviceName;width:74;height:16;x:background.x+10;y:background.y+8;}
            PropertyChanges{target:indexBox;width:deviceName.width;height:deviceName.height;x:background.x+328;y:deviceName.y;}
            PropertyChanges{target:contentBox;x:background.x+10;y:background.y+34}
        },
        State{
            name:"xl"
            PropertyChanges{target:background;width:202;height:186;}
            PropertyChanges{target:deviceName;width:74;height:16;x:background.x+10;y:background.y+8;}
            PropertyChanges{target:indexBox;width:deviceName.width;height:deviceName.height;x:background.x+118;y:deviceName.y;}
            PropertyChanges{target:contentBox;x:background.x+10;y:background.y+34}
        },
        State{
            name:"l"
            PropertyChanges{target:background;width:132;height:186;}
            PropertyChanges{target:deviceName;width:69;height:16;x:background.x+10;y:background.y+8;}
            PropertyChanges{target:indexBox;width:32;height:deviceName.height;x:background.x+90;y:deviceName.y;}
            PropertyChanges{target:contentBox;x:background.x+10;y:background.y+34}
        },
        State{
            name:"m"
            PropertyChanges{target:background;width:132;height:89;}
            PropertyChanges{target:deviceName;width:46;height:12;x:background.x+6;y:background.y+4;}
            PropertyChanges{target:indexBox;width:12;height:width;x:background.x+114;y:background.y+6;}
            PropertyChanges{target:contentBox;x:background.x+6;y:background.y+19}
        },
        State{
            name:"s"
            PropertyChanges{target:background;width:97;height:89;}
            PropertyChanges{target:deviceName;width:46;height:12;x:background.x+6;y:background.y+4;}
            PropertyChanges{target:indexBox;width:12;height:width;x:background.x+79;y:background.y+6;}
            PropertyChanges{target:contentBox;x:background.x+6;y:background.y+19}
        },
        State{
            name:"xs"
            PropertyChanges{target:background;width:76;height:89;}
            PropertyChanges{target:deviceName;width:46;height:12;x:background.x+6;y:background.y+4;}
            PropertyChanges{target:indexBox;width:12;height:deviceName.height;x:background.x+58;y:background.y+6;}
            PropertyChanges{target:contentBox;x:background.x+6;y:background.y+19}
        }
    ]
}
