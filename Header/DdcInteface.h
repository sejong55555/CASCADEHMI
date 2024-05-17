#ifndef DDCINTEFACE_H
#define DDCINTEFACE_H

#include <QObject>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDateTime>

#include "../EngineInterface/ddcClient/ddcclient.h"
#include "pointIdList.h"

#if(DEBUG_SAVE_LOG)
#define INSERT_SYS_LOG          "INSERT INTO tb_system_log(log_time, source, set_value, get_value, the_others)"\
"VALUES ('%1', '%2', '%3', '%4', '%5')"


#define CREATE_TABLE_SYS_LOG    "CREATE TABLE if not exists 'tb_system_log' ( "\
    "	'idx'	INTEGER NOT NULL, "\
    "	'log_time'	datetime, "\
    "	'source'	TEXT, "\
    "	'set_value'	TEXT, "\
    "	'get_value'	TEXT, "\
    "	'the_others'	TEXT, "\
    "	PRIMARY KEY('idx' AUTOINCREMENT) "\
    "); "

#define CLEAR_TABLE_SYS_LOG "DELETE FROM tb_system_log;"
#endif

class DdcInteface: public QObject
{
    Q_OBJECT
public:
    DdcInteface(QObject *parent = 0);
    ~DdcInteface();

    DdcClient *mDdcInstance =nullptr;

    QList<ControlPointValue*> getControlPointValues() const;


public:
    bool setDate(QString date);
    bool setTime(QString time);
    QVariantList readPointValues(QList<QString> pointIds);
    void writePointValue(QString pointId, QString setValue);
    void writePointValues(const QVariantMap &setValues);

    QVariantList readAlarmHistoryAll();
    QVariantList readAlarmHistoryMonth(int year, int month);
    QVariantList readAlarmHistoryPeriod(QString startDate, QString endDate);
    bool clearAlarmHistory();
    int getActiveAlarms();

    QVariantList getSchedules();
    bool addSchedule(const QVariantMap &schedule);
    bool setSchedule(const QVariantMap &schedule);
    bool deleteSchedule(QString scheduleIdText);

    QVariantMap getCircuitTemp(QString runmode);
    void setEcoMode(QString onOff);
    //QVariantList getMonitorInData();
    QVariantList getMonitorOutData();

    void setRunMode(QString runmode);
    QString getRunMode();

    void setCircuitTemp(QString value);
    QString getCircuitTemp();

    void setHotWaterTemp(QString value);
    QString getHotWaterTemp();

    void setIndoorTemp(QString value);
    QString getIndoorTemp();

    void setSetTemp(QString value);
    QString getSetTemp();

    void setOutsideTemp(QString value);
    QString getOutsideTemp();

    void setIndoorInputTemp(QString value);
    QString getIndoorInputTemp();

    void setIndoorOutputTemp(QString value);
    QString getIndoorOutputTemp();

    void setIndoorHeater(QString value);
    QString getIndoorHeater();

    void setIndoorDhwBoost(QString value);
    QString getIndoorDhwBoost();

    void setIndoorBufferTankTemp(QString value);
    QString getIndoorBufferTankTemp();

    void setIndoorTankUpTemp(QString value);
    QString getIndoorTankUpTemp();

    void setIndoorTankBottomTemp(QString value);
    QString getIndoorTankBottomTemp();

    QString getCurrentEnergy();
    QString getTotalEnergy();

    void setSilentMode(QString value);
    QString getSilentMode();

    void setThirdPartyBoilerMode(QString value);
    QString getThirdPartyBoilerMode();

    void setCoolWaterTemperature(QString value);
    QString getCoolWaterTemperature();

    void setHotWaterTemperature(QString value);
    QString getHotWaterTemperature();


    void setLanguage(QString value);
    QString getLanguage();

    void setTemperatureUnit(QString value);
    QString getTemperatureUnit();

    //void setTemperatureMinumUnit(QString value);
    //QString getTemperatureMinumUnit();

    void setTimeZone(QString value);
    QString getTimeZone();

    //bool setDate(QString date);
    //bool setTime(QString time);

    void setTimeFormat(QString value);
    QString getTimeFormate();

    void setScreenSaveTime(QString value);
    QString getScreenSaveTime();

    void setLCDBacklightIdle(QString value);
    QString getLCDBacklightIdle();

    void setAutoRetrunMainScreen(QString value);
    QString getAutoRetrunMainScreen();

    void setGeneralLock(QString value);
    QString getGeneralLock();

    void setModeLock(QString value);
    QString getModeLock();

    void setDHWLock(QString value);
    QString getDHWLock();

    void setWifi_Paring(QString value);
    QString getWifi_Paring();

    void setSystemReboot(QString value);

private:
    QString getValue(QString pointID);

private:
    QList<ControlPointValue*> m_controlPointValues;
    QList<AlarmInfo*> m_alarmInfo;
    QList<Schedule*> m_schedule;
    QList<QString> m_days;
    QList<QString> m_weeklySchedules;
    QList<QString> m_crontabCommands;
#if(DEBUG_SAVE_LOG)
    QSqlDatabase m_saveLog;
    QString inifile;
private:
    bool saveEngineInterfaceLog(QString source, QString set_value, QString get_value, QString the_others);
#endif

};

#endif // DDCINTEFACE_H
