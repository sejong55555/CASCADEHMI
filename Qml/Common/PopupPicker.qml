import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Textmold{
    id:root
    width: 440; height: 232
    radius:15
    color:"#FFFFFF"
    horizontalAlignment:Text.AlignHCenter

    textfieldX: 20; textfieldY: 16; textfieldWidth: 400; textfieldHeight: 18
    textfieldText:"TextTextTextText"

    property bool midline: true

    property var firstmodel
    property var secondmodel
    property var thirdmodel

    property alias firsttextZeroPadding: firstTumbler._textZeroPadding
    property alias firstindexOffset: firstTumbler._indexOffset
    property alias firstprefix: firstTumbler._prefix

    property alias secondtextZeroPadding: secondTumbler._textZeroPadding
    property alias secondindexOffset: secondTumbler._indexOffset
    property alias secondprefix: secondTumbler._prefix

    property alias thirdtextZeroPadding: thirdTumbler._textZeroPadding
    property alias thirdindexOffset: thirdTumbler._indexOffset
    property alias thirdprefix: thirdTumbler._prefix

    property alias _firstText: firstTumbler.selectedindex
    property alias _secondText: secondTumbler.selectedindex
    property alias _thirdText: thirdTumbler.selectedindex

    property int _firstdefaultIndex: 0
    property int _seconddefaultIndex: 0
    property int _thirddefaultIndex: 0

    signal sigCancelClick()
    signal sigOkClick(int _firstText,int _secondText,int _thirdText)
    signal sigSetDefaultIndex(int _setfirstindex,int _setsecondindex,int _setthirdindex)

    Rectangle{
        id:middleBackground
        anchors.left: parent.left; y:80
        width:parent.width; height:50
        color:"#DEE1E5"
    }

    Row {
        id:tumblerRow
        y:49;leftPadding: 129; rightPadding: 130; spacing: 10

        Tumblercolumn{
            id:firstTumbler
            themodel:firstmodel
            _defaultIndex:_firstdefaultIndex
        }

        Item{
            id:double_view
            visible:true
            width:(midline===true)?1:4
            height:(midline===true)?114:22
            anchors.verticalCenter: parent.verticalCenter;
            Rectangle{
                id:middleline1;
                anchors.fill:parent
                color:"#CCCCCC";
                visible:(midline===true)? true : false
            }
            Textmold{
                anchors.fill:parent
                color:"transparent"
                fontsize:22;textfieldText:":"
                shadowEnable:false;
                visible:(midline===true)? false : true
            }
        }

        Tumblercolumn{id:secondTumbler
            themodel:secondmodel
            _defaultIndex:_seconddefaultIndex
        }

        Item{
            id:triple_view
            visible:false
            width:(midline===true)?1:4
            height:(midline===true)?114:22
            anchors.verticalCenter: parent.verticalCenter
            Rectangle{
                id:middleline2;
                anchors.fill:parent
                color:"#CCCCCC";
                visible:(midline===true)? true : false
            }
            Textmold{
                anchors.fill:parent
                color:"transparent"
                fontsize:22;textfieldText:""
                shadowEnable:false;
                visible:(midline===true)? false : true
            }
        }
        Tumblercolumn{
            id:thirdTumbler;
            themodel:thirdmodel
            _defaultIndex:_thirddefaultIndex
            visible:false
        }
    }

    TextButtonRow{
        id:btnrow
        x:97;y:176
        firstbtnText:qsTr("Cancel")
        secondbtnText:qsTr("OK")
        onSigRowLClickIn: {
            sigCancelClick()
        }
        onSigRowRClickIn: {
            // _hourText
            sigOkClick(_firstText,_secondText,_thirdText)
        }

    }

    state:"double"

    states:[
        State{
            name:"double"
            PropertyChanges {target:triple_view;visible:false}
        },
        State{
            name:"triple"
            PropertyChanges {target:tumblerRow;leftPadding:76; rightPadding:76;}
            PropertyChanges {target:triple_view;visible:true}
            PropertyChanges {target: thirdTumbler;visible:true}
        }
    ]

    onSigSetDefaultIndex: {
        firstTumbler.sigDefaultset(_setfirstindex)
        secondTumbler.sigDefaultset(_setsecondindex)
        thirdTumbler.sigDefaultset(_setthirdindex)
    }
}
