

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick 2.7

import QtQuick 2.10

import QtQuick.Controls 2.0
import "../Global"

Rectangle {
    id: rectangle
    width: Variables.sourceWidth
    height: Variables.sourceHeight

    color: "transparent"

    Rectangle {
        id: rectangle1
        x: 56
        y: 74
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[0]=x
            _arrY[0]=y
        }
    }

    Rectangle {
        id: rectangle2
        x: 140
        y: 74
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[1]=x
            _arrY[1]=y
        }
    }

    Rectangle {
        id: rectangle3
        x: 224
        y: 74
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[2]=x
            _arrY[2]=y
        }
    }

    Rectangle {
        id: rectangle4
        x: 308
        y: 74
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[3]=x
            _arrY[3]=y
        }
    }

    Rectangle {
        id: rectangle5
        x: 392
        y: 74
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[4]=x
            _arrY[4]=y
        }
    }

    Rectangle {
        id: rectangle6
        x: 56
        y: 175
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[5]=x
            _arrY[5]=y
        }
    }

    Rectangle {
        id: rectangle7
        x: 140
        y: 175
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[6]=x
            _arrY[6]=y
        }
    }

    Rectangle {
        id: rectangle8
        x: 224
        y: 175
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[7]=x
            _arrY[7]=y
        }
    }

    Rectangle {
        id: rectangle9
        x: 308
        y: 175
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[8]=x
            _arrY[8]=y
        }
    }

    Rectangle {
        id: rectangle10
        x: 392
        y: 175
        width: 76
        height: 89
        color: "transparent"

        Component.onCompleted: {
            _arrX[9]=x
            _arrY[9]=y
        }
    }
}
