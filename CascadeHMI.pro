QT += core qml quick sql widgets
# quickcontrols2 charts
CONFIG += c++11 app_bundle

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS ENABLE_DEBUG MOCK_TEST DEBUG_SAVE_LOG

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

INC_DIR = ./Header
SRC_DIR = ./Source
ENGINE_DIR = ./EngineInterface/ddcClient

INCLUDEPATH += . \
            $$INC_DIR
#            \
           # $$INC_DIR/common \
#            $$INC_DIR/Settings \
#            $$INC_DIR/serial \
#            $$INC_DIR/bt

SOURCES += \
        $$SRC_DIR/AppEngine.cpp \
        $$SRC_DIR/main.cpp \
        $$SRC_DIR/AppModel.cpp \
        $$SRC_DIR/DdcInteface.cpp \
        $$ENGINE_DIR/ddcclient.cpp \
        $$ENGINE_DIR/alarminfo.cpp \
        $$ENGINE_DIR/controlpointvalue.cpp \
        $$ENGINE_DIR/schedule.cpp \
        $$ENGINE_DIR/writecontrolpointvalue.cpp \
        Source/Sample.cpp

HEADERS += \
    $$INC_DIR/AppEngine.h \
    $$INC_DIR/Enums.h \
    $$INC_DIR/HMIGlobal.h \
    $$INC_DIR/AppProperties.h \
    $$INC_DIR/AppModel.h \
    $$INC_DIR/DefStrings.h \
    $$INC_DIR/DdcInteface.h \
    $$ENGINE_DIR/ddcclient.h \
    Header/Sample.h \
    $$ENGINE_DIR/alarminfo.h \
    $$ENGINE_DIR/controlpointvalue.h \
    $$ENGINE_DIR/schedule.h \
    $$ENGINE_DIR/writecontrolpointvalue.h

RESOURCES += qml.qrc \
    images.qrc \
    lang.qrc

TRANSLATIONS += \
    res/CascadeHMI_ko_KR.ts

CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
#타겟 디바이스 실행 경로 설정 - 장비의 경로에 맞춰서 변경할 것.
#target.path = /opt/EFIDashBoard/bin/
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Qml/EngineInterfacTest.qml \
    Qml/HMIMain.qml \
    Qml/main.qml \
    res/CascadeHMI_ko_KR.ts



