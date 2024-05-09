
import QtQuick 2.7
import QtQuick 2.10
import QtQuick.Controls 2.0
import "../Global"
RadioButton {
    id:root
    width:32;height:32
    property string imagestate: "n"
    property string imagename: "radio"
    property string toggle: (root.checked===true)? "on" : "off"
    property alias indicatorImageW: indicatorImage.width
    property alias indicatorImageH: indicatorImage.height

    enabled: true
//    checked: true
    indicator: Image{
        id:indicatorImage
        width: 32; height: 32;
        source:Variables.sourcePath+"btn_"+imagename+"_"+toggle+"_"+imagestate+".png"
    }
}
