import QtQuick 2.7
import QtGraphicalEffects 1.0
Rectangle {
    id: root
    width:220
    height:18
    color:"transparent"

    property alias textfieldWidth: textfield.width
    property alias textfieldHeight: textfield.height

    property alias textfieldX: textfield.x
    property alias textfieldY: textfield.y

    property string textfieldText: ""

    property alias textfieldClip: textfield.clip
    property alias textBaseline: textfield.baselineOffset
    property real fontspacing:0
    property alias fontcolor: textfield.color
    property int fontsize: 18
    property real fontOpacity:1

    property alias verticalAlignment:  textfield.verticalAlignment
    property alias horizontalAlignment:  textfield.horizontalAlignment

    property int wrapEnum: 0
    property real linespace: 4

    property alias shadowEnable: shadow.visible
    property alias shadowColor: shadow.color
    property alias shadowOpacity: shadow.opacity
    property alias shadowRadius: shadow.radius
    property alias shadowVerticalOffset :shadow.verticalOffset

    property alias textshadowEnable: textshadow.visible
    property alias textshadowColor: textshadow.color
    property alias textshadowOpacity: textshadow.opacity
    property alias textshadowRadius: textshadow.radius
    property alias textshadowVerticalOffset :textshadow.verticalOffset

    Text{
        id: textfield
        //default set
        width: 160
        height: 18
        clip:true
        opacity: fontOpacity
        text: textfieldText
        wrapMode: wrapEnum
        font.pixelSize: fontsize
        font.letterSpacing: fontspacing
        color:"#222222"
        lineHeightMode: Text.FixedHeight
        lineHeight: fontsize + linespace
        verticalAlignment:  Text.AlignVCenter
        horizontalAlignment:  Text.AlignLeft
    }

    DropShadow {
        id:shadow
        visible: true
        anchors.fill: root
        z: -1
        verticalOffset: 4
        radius: 44
        samples: 1+radius*2
        color: "#000000"
        opacity: 0.25
        source: root
    }

    DropShadow {
        id:textshadow
        visible: false
        anchors.fill: textfield
        z: -1
        verticalOffset: 2
        radius:2
        samples: 1+radius*2
        color: "#000000"
        opacity: 0.2
        source: textfield
    }

    function setTextfield(textline){
        textfield.text = textline;
    }

    function textFieldAlign(){
        textfield.anchors.centerIn = root;
    }
}


