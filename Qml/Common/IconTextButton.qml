import QtQuick 2.7
import "../Global"

Item{

    id:root
    width:100;height:36

    property alias topSpacing: rowmold.topPadding
    property alias leftSpacing: rowmold.leftPadding

    property alias textBoxWidth: textBox.width
    property alias textBoxHeight: textBox.height
    property alias textLabel: textBox.text
    property alias textBoxClip: textBox.clip

    property alias fontsize: textBox.font.pixelSize
    property alias fontcolor: textBox.color
    property alias textBaseline: textBox.baselineOffset

    property alias verticalAlignment:  textBox.verticalAlignment;
    property alias horizontalAlignment:  textBox.horizontalAlignment

    property string iconImageName: "water2"
    property string imagestate: ""

    property alias iconWidth: iconImage.width
    property alias iconHeight: iconImage.height

    property alias textIcondistance: rowmold.spacing

    property alias backgroundColor: background.color

     property string btnORicon:"ic_"

    signal sigClick()
    signal sigReleased()

    property alias mouseEnable: mousearea.enabled

    Rectangle{
        id:background
        color:"transparent"
        anchors.fill:parent
        anchors.centerIn: root
        Row{
            id:rowmold
            leftPadding:0;topPadding:0;
            spacing:10
            anchors.verticalCenter: parent.verticalCenter

            Image{
                id:iconImage
                width:36;height:iconImage.width;
                anchors.verticalCenter: parent.verticalCenter
                source: Variables.sourcePath+btnORicon+iconImageName+imagestate+".png"
            }
            Text{
                id:textBox
                width:36;height:24;
                anchors.verticalCenter: parent.verticalCenter
                text:"default";
                color:"#222222";
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                clip:true
            }
        }

        MouseArea{
            id:mousearea
            anchors.fill:parent
            enabled: false
            onPressed: {
                sigClick()
            }
            onReleased: {
                sigReleased()
            }
        }
    }
}
