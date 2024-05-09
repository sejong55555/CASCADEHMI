#ifndef ENUMS_H
#define ENUMS_H

#include <QObject>

class ENUMS : public QObject
{
    Q_OBJECT
//    Q_ENUMS(ENUM_VIEWMODE)
//    Q_ENUMS(ENUM_CONFIGMODE)
    Q_ENUMS(ENUM_OS)
//    Q_ENUMS(ENUM_UNIT)

public:
    enum ENUM_OS {
        E_OS_LINUX = 0,
        E_OS_WIN,
        E_OS_MAC,
        E_OS_IPHONE
    };

//    enum ENUM_VIEWMODE {
//        E_VIEW_MAIN,
//        E_VIEW_MENU,
//        E_VIEW_PFD,
//        E_VIEW_HSI,
//        E_VIEW_CONF,
//        E_VIEW_IPAD
//    };

//    enum ENUM_CONFIGMODE {
//        E_CONFIG_DEVICEINFO,
//        E_CONFIG_ALTITUDE,
//        E_CONFIG_AIRDATA,
//        E_CONFIG_AIRSPEED,
//        E_CONFIG_MEGNETOMETER,
//        E_CONFIG_BACKLIGHT,
//        E_CONFIG_DISPLAY,
//        E_CONFIG_BATTERY,
//        E_CONFIG_GPS,
//        E_CONFIG_UNIT,
//        E_CONFIG_RS232,
//        E_CONFIG_BLUETOOTH,
//        E_CONFIG_EXIT,
//        E_CONFIG_MAIN
//    };

//    enum ENUM_UNIT {
//        E_UNIT_DEFAULT,
//        E_UNIT_FEET,
//        E_UNIT_METER,
//        E_UNIT_METERPERSEC,
//        E_UNIT_METERPERMIN,
//        E_UNIT_KMPERHOUR,
//        E_UNIT_MILEPERHOUR,
//        E_UNIT_KNOT,
//        E_UNIT_FEETPERSEC,
//        E_UNIT_FEETPERMIN,
//        E_UNIT_INCH,
//        E_UNIT_MILLIBAR,
//        E_UNIT_HPASCAL
//    };
};
#endif // ENUMS_H
