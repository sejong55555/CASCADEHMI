import QtQuick 2.7
import QtQuick.Controls 2.1
ScrollBar {
    id:root
    property real barwidth: 3
    property real barheight: 7.5
    property string barcolor: "#999999"
    snapMode:ScrollBar.SnapAlways
    background: Rectangle {
        id:bgscrollBar
        implicitWidth: barwidth
        implicitHeight: barheight
        opacity:0
        color: barcolor
    }
    contentItem: Rectangle {
        id:handlescrollBar
        implicitWidth: barwidth
        implicitHeight: barheight
        radius: 15
        color: barcolor
    }
}

