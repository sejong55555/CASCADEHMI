import QtQuick 2.7
import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQml 2.0
import "../Global"

Item {
    id: root
    property alias columnx:tumblerlist.x
    property alias columny:tumblerlist.y
    property string prestate: ""

    property string imagestateUp:"n"
    property string imagestateDown:"n"

    property int _textZeroPadding: 2
    // property var themodel: [{name: "Text", subtitle: ""},{name: "Text", subtitle: ""},{name: "Text", subtitle: ""},{name: "Text", subtitle: ""}]
    property var themodel

    property int selectedindex
    property int _defaultIndex: 0

    property bool _indexOffset:false
    property string _prefix:""

    signal sigDefaultset(string _date)


    width:80;height:114

    Column{
        id: tumblerlist
        spacing: 14
        topPadding:0;bottomPadding:0
        Rectangle{
            id: upbtn
            width:80;height:31
            anchors.horizontalCenter: parent.horizontalCenter
            Image{
                width:12;height:6
                source: Variables.sourcePath+"General_popup_up_"+imagestateUp+".png"
                anchors.horizontalCenter: parent.horizontalCenter;anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {tumblerview.currentIndex = tumblerview.currentIndex+1}
                onPressed: {
                    prestate = imagestateUp
                    imagestateUp = "p"
                }
                onReleased: {
                    imagestateUp = prestate
                    // sigClick()
                }
            }
        }
        Tumbler {
            id:tumblerview
            width:root.width; height: 22;
            focus: true
            model: themodel
            delegate: pathdelegate
            visibleItemCount: 1
            wrap: false
            onCurrentIndexChanged:{
                selectedindex=tumblerview.currentIndex
            }

        }
        Rectangle{
            id: downbtn
            width:80;height:31
            anchors.horizontalCenter: parent.horizontalCenter
            Image{
                width:12;height:6
                source: Variables.sourcePath+"General_popup_down_"+imagestateDown+".png"
                anchors.horizontalCenter: parent.horizontalCenter;anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    tumblerview.currentIndex = tumblerview.currentIndex-1
                }

                onPressed: {
                    prestate = imagestateDown
                    imagestateDown = "p"
                }
                onReleased: {
                    imagestateDown = prestate
                    // sigClick()
                }
            }
        }
    }

    Component{
        id:pathdelegate
        Textmold{
            id:pathdelegateText
            width: 80; height: 22
            textfieldWidth: width
            textfieldHeight: height
            clip:false
            fontsize: 22
            fontcolor: "#222222"
            // textfieldText: _indexOffset===true&&_prefix===""?(index+1).toString().padStart(_textZeroPadding, '0'):_prefix+index.toString().padStart(_textZeroPadding, '0')
            textfieldText: _indexOffset===true&&_prefix===""?Variables.padStart((index+1).toString(),_textZeroPadding):_prefix+Variables.padStart(index.toString(),_textZeroPadding)
            // textfieldText: _indexOffset===true&&_prefix===""?(index+1).toString():_prefix+index.toString()
            verticalAlignment:  Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            textshadowEnable:false;shadowEnable:false

            Component.onCompleted: {
                textFieldAlign()
            }
            // horizontalAlignment:  Text.AlignHCenter
        }
    }

    Component.onCompleted: {
        tumblerview.currentIndex=_defaultIndex
    }

    onSigDefaultset:{
        tumblerview.currentIndex=_date
    }


}
