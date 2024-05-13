
import QtQuick 2.7

import QtQuick 2.10

import QtQml 2.0
import "../Global"

Rectangle{
    id:root
    width: Variables.sourceWidth;
    height: Variables.sourceHeight;

    color:"#FFFFFF"

    property string titleName: "Title"

    property var mainModel
    property var subModel

    property string titleState: "F"
    property alias rightItemSource: mainTitle.rightItem_source
    property alias leftIconSource: mainTitle.icon_source

    signal sigrightItemClick()
    signal siglistBarClick(int _index,string _selectedmenu,string _selectediconSource)
    signal sigbackClick()

    MouseArea{anchors.fill:parent}

    Column{
        id: columnLayout
        anchors.fill: parent
        TitleBar{
            id:mainTitle
            left_1st_Text:titleName
            state:titleState
            onSigRClickTitleBar: {
                console.log("ini")
                sigrightItemClick()
            }
            onSigLClickTitleBar: {
                sigbackClick()
            }
        }
        ListView {
            id:mainListview
            clip: true
            width:480;
            height:root.height-mainTitle.height
            z:-1
            model:mainModel
            delegate: mainDelegate
        }
    }

    Component{
        id:mainDelegate

        Rectangle{
            id:colmold
            width:480;
            // height:48/*+exaang 길이를 더해줘야함 이곳에 ! */
            height:listTitle.height+(48*subModel.count)
            Column{
                anchors.fill: parent
                List{
                    id:listTitle
                    left_1st_Text:Listtitle
                    state:statename
                    // rightItemtextField:subText
                    rightItemsource: null
                    Component.onCompleted: {
                        if(state==="H"){
                            icon_source=iconSource;
                            rightItemtextField=subText;

                        }
                        else if(state==="G"){
                            icon_source=iconSource
                        }
                    }
                    onSigClick: {
                        siglistBarClick(index,Listtitle,iconSource)
                    }
                }
                ListView{
                    id:subListview
                    width:480;
                    height:48*subModel.count
                    model:subModel
                    visible:true
                    delegate: subDelegate
                }
            }

            Component.onCompleted: {
                listTitle.rightItemsourceUrl = rightItemsourcename
                if(state==="B"||state==="H"){
                    listTitle.rightItemtextField = subText
                    // console.log(subText)
                }
            }
        }
    }

    Component{
        id:subDelegate
        List{
            id:title
            expand1:true
            left_1st_Text:ExpandTitle;
            // left_2nd_Text:""
            state:statename

            Component.onCompleted: {
                title.rightItemsourceUrl = rightItemsourcename
                if(state==="B"||state==="H"){
                    title.rightItemtextField = subText
                }
            }
        }
    }

    layer.enabled:true
}
