import QtQuick 2.7
import QtQml 2.0
import "../Common"
import "../Global"

Rectangle{
    id:root
    width:Variables.sourceWidth
    height:Variables.sourceHeight
    color:"#FFFFFF"

    signal sigReadDateSetting()

    Column{
        TitleBar{
            id:title
            left_1st_Text:"Date & Time"
            onSigLClickTitleBar: {
                sigReadSettingDefault()
                root.visible=false
            }
        }
        ListView{
            id:view
            width:Variables.sourceWidth
            height:Variables.sourceHeight-title.height
            model:listmodel
            delegate:List{
                    left_1st_Text:model.listName
                    rightItemtextField:model.subText
                    state:model.statename
                    onSigClick: {
                        switch(index){
                        case 0:{
                            //time zone설정 visible
                            break;
                        }
                        case 1:{
                            datePopupbg.visible=true
                            break;
                        }

                        case 2:{
                            break;
                        }

                        case 3:{
                            break;
                        }

                        }
                    }

            }
        }
    }


    Rectangle{
        id:datePopupbg
        color:"#26000000"
        width:Variables.sourceWidth
        height:Variables.sourceHeight
        visible:false
        MouseArea{anchors.fill:parent}
        PopupPicker{
            id:datePicker
            textfieldText: "Date"
            anchors.centerIn: parent
            state:"triple"
            secondtextZeroPadding:1;thirdtextZeroPadding:2;

            _firstdefaultIndex:Variables.globalTodayMonth
            _seconddefaultIndex:Variables.globalTodayDate-1
            _thirddefaultIndex:Variables.globalTodayYear.slice(2)

            firstmodel:monthmodel;secondmodel:31;thirdmodel:100

            secondindexOffset:true
            thirdprefix: "20"

            onSigCancelClick: {
                datePopupbg.visible=false
            }
            onSigOkClick: {
                datePopupbg.visible=false
                Variables.currentDateUpdate(thirdprefix+_thirdText,_firstText,_secondText+1)
                sigReadDateSetting()
            }
        }
    }

    ListModel{
        id:monthmodel
        ListElement{index:"January"}
        ListElement{index:"February"}
        ListElement{index:"March"}
        ListElement{index:"April"}
        ListElement{index:"May"}
        ListElement{index:"June"}
        ListElement{index:"July"}
        ListElement{index:"August"}
        ListElement{index:"September"}
        ListElement{index:"October"}
        ListElement{index:"November"}
        ListElement{index:"December"}
    }


    ListModel{
        id:listmodel//*to do time zone설정 date Time, tiem format등 설정
        ListElement{listName:"Time Zone";statename:"B";subText:""}
        ListElement{listName:"Date";statename:"B";subText:""}
        ListElement{listName:"Time";statename:"B";subText:""}
        ListElement{listName:"Time Format";statename:"B";subText:""}
    }

    Component.onCompleted: {
        listmodel.get(0).subText=Variables.country;
        listmodel.get(1).subText=Variables.globalDateString;
        listmodel.get(2).subText=Variables.globalTimeString;
        listmodel.get(3).subText="AM/PM" //*to do format형식 표현을 어떻게 하는걸 말하는거지
    }

    onSigReadDateSetting: {
        listmodel.get(0).subText=Variables.country;
        listmodel.get(1).subText=Variables.globalDateString;
        listmodel.get(2).subText=Variables.globalTimeString;
        listmodel.get(3).subText="AM/PM"
    }



}
