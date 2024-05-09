pragma Singleton
import QtQuick 2.10
import QtQml 2.0
import QtQuick 2.7
import "../Common"

QtObject {

    readonly property int sourceWidth  :  480
    readonly property int sourceHeight :  272
    // readonly property string sourcePath : "file:///"+applicationdirpath+"../cascadehmi/res/Image/"
    readonly property string sourcePath : "../../res/Image/"

    property string content:"Home"

    readonly property int coolmin:  18
    readonly property int coolmax:  25

    readonly property int heatmin:  22
    readonly property int heatmax:  30

    readonly property int automin:  -5
    readonly property int automax:  5

    readonly property int hotwatermin:  60
    readonly property int hotwatermax:  30


    property int defaultCoolTemp:20
    property int defaultHeatTemp:25
    property int defaultAutoTemp:0
    property int defaultHotTemp:40


    property string locale: "ko_KR"
    // property string locale: "en_US"//inf에서 locale설정 넣어야하는데
    property var globalLocale: Qt.locale()

    // property date globalCurrentDate: new Date()

    // property string globalTodayMonth: globalCurrentDate.getMonth()
    // property string globalTodayYear: globalCurrentDate.getFullYear()
    // property string globalTodayDate: globalCurrentDate.getDate()

    // property string globalDateString : globalCurrentDate.toLocaleDateString(globalLocale,"MMM dd, yyyy")
    // property string globalDateExpandString : globalCurrentDate.toLocaleDateString(globalLocale,"MMM d, yyyy ") + globalCurrentDate.toLocaleTimeString(globalLocale, Locale.ShortFormat,"h:mm AP");

    property date globalCurrentDate
    property string globalTodayMonth
    property string globalTodayYear
    property string globalTodayDate

    property string globalDateString
    property string globalTimeString
    property string globalDateExpandString

    property var globalCurrentDate7:new Date(globalCurrentDate)
    property string globalDateString7

    property string globalTodayMonth7: globalCurrentDate7.getMonth()
    property string globalTodayYear7: globalCurrentDate7.getFullYear()
    property string globalTodayDate7: globalCurrentDate7.getDate()


    property var heatSummary
    property var coolSummary
    property var dhwSummary

    property var lastyearSummary

    property string language:"Español"

    property real tempStep: 0.5//0.5
    property real minimumUnit:0.5
    property string tempUnit: "Celsius"//Fahrenheit

    property bool wifipairing: true

    property bool lockmode: false//*to do 처음 실행시 inf에서 읽어와서 값 대입
    property bool onOffLock: false
    property bool modeLock: true
    property bool dhwLock: false

    property string country: "New York"


    property int screensaverTime:15
    property bool lcdIdle: false
    property bool autoReturnMainScreen: false

    function changeLocale(){
    }


    function padStart(inputString,targetLength){
        var padString='0'
        while(inputString.length<targetLength){
            inputString = padString + inputString;
        }
        return inputString
    }

    function opacityInit(_model,_opacityValue){
        for(var i=0;i < _model.count;i++){
            _model.get(i).Textopacity=_opacityValue
        }
    }

    function currentDateUpdate(_year,_month,_date){

        var globalCurrentDatetemp=new Date(globalCurrentDate)
        globalCurrentDatetemp.setDate(_date)
        globalCurrentDatetemp.setMonth(_month)
        globalCurrentDatetemp.setFullYear(_year)

        globalTodayMonth = globalCurrentDatetemp.getMonth()
        globalTodayYear = globalCurrentDatetemp.getFullYear()
        globalTodayDate = globalCurrentDatetemp.getDate()

        globalCurrentDate = globalCurrentDatetemp

        globalDateString = globalCurrentDate.toLocaleDateString(globalLocale,"MMM d, yyyy")
        globalTimeString = globalCurrentDate.toLocaleTimeString(globalLocale, Locale.ShortFormat,"h:mm AP");
        globalDateExpandString = globalCurrentDate.toLocaleDateString(globalLocale,"MMM d, yyyy ") + globalTimeString

        globalCurrentDate7=new Date(globalCurrentDate)

        globalCurrentDate7.setDate(globalCurrentDate7.getDate() + 7)
        globalDateString7=globalCurrentDate7.toLocaleDateString(globalLocale,"MMM dd, yyyy")
        globalTodayMonth7= globalCurrentDate7.getMonth()
        globalTodayYear7= globalCurrentDate7.getFullYear()
        globalTodayDate7= globalCurrentDate7.getDate()
    }




    Component.onCompleted: {
        globalCurrentDate= new Date() //string date type
        globalTodayMonth = globalCurrentDate.getMonth()
        globalTodayYear = globalCurrentDate.getFullYear()
        globalTodayDate = globalCurrentDate.getDate()

        globalDateString = globalCurrentDate.toLocaleDateString(globalLocale,"MMM d, yyyy")
        globalTimeString = globalCurrentDate.toLocaleTimeString(globalLocale, Locale.ShortFormat,"h:mm AP");
        globalDateExpandString = globalCurrentDate.toLocaleDateString(globalLocale,"MMM d, yyyy ") + globalTimeString

        globalCurrentDate7.setDate(globalCurrentDate7.getDate() + 7)
        globalDateString7=globalCurrentDate7.toLocaleDateString(globalLocale,"MMM dd, yyyy")
        globalTodayMonth7= globalCurrentDate7.getMonth()
        globalTodayYear7= globalCurrentDate7.getFullYear()
        globalTodayDate7= globalCurrentDate7.getDate()
    }
}


