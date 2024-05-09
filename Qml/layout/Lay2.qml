
import QtQuick 2.7

import QtQuick 2.10

import QtQuick.Controls 2.0
import "../Global"
Rectangle {
    id: rectangle
    width: Variables.sourceWidth
    height: Variables.sourceHeight

    color: "transparent"

    property var _arrX:new Array
    property var _arrY:new Array

    Rectangle {
        id: rectangle0
        x: 56
        y: 74
        width: 202
        height: 186
         color: "transparent"
        Component.onCompleted: {
            _arrX[0]=x
            _arrY[0]=y
        }
    }

    Rectangle {
        id: rectangle1
        x: 266
        y: 74
        width: 202
        height: 186
        color: "transparent"
        Component.onCompleted: {
            _arrX[1]=x
            _arrY[1]=y
        }
    }
}
