#ifndef APPMODEL_H
#define APPMODEL_H

#include <QObject>
#include <QMutex>

#include <QSharedPointer>
#include "HMIGlobal.h"
#include "DdcInteface.h"

class AppProperties;
class DefStrings;
class AppEngine;
class Sample;

class AppModel : public QObject
{
    Q_OBJECT

public:
    static AppModel* instance()
    {
        QMutexLocker locker(&AppModel::m_Mutex);
        if(!m_pInstance) {
            m_pInstance = new AppModel();
        }
        return m_pInstance;
    }

    static void drop()
    {
        QMutexLocker locker(&AppModel::m_Mutex);
        if(m_pInstance != nullptr) {
            delete m_pInstance;
            m_pInstance = nullptr;
        }
    }

public:
    AppProperties* getGlobalDefine() const;
    DefStrings* getStringDefine() const;

    Q_INVOKABLE int     GetTemperature();
    Q_INVOKABLE void    SetTemperature(int nTemp);

    OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(int, tempVal, TempVal)

signals:
    void tempValChanged();
    void sigScheduleChanged(int nActionMode);   //0 : add, 1 : edit, 2 : delete
    void sigGetCircuitTemp(bool result);
    void sigSetEcoMode();
    //void sigGetMonitorInData(bool result);
    void sigGetMonitorOutData(bool result);

public:
    Q_INVOKABLE bool ddc_setDate(QString date);
    Q_INVOKABLE bool ddc_setTime(QString time);
    Q_INVOKABLE QVariantList ddc_readPointValues(QList<QString> pointIds);
    Q_INVOKABLE void ddc_writePointValue(QString pointId, QString setValue);
    Q_INVOKABLE void ddc_writePointValues(const QVariantMap &setValues);

    Q_INVOKABLE QVariantList ddc_readAlarmHistoryAll();
    Q_INVOKABLE QVariantList ddc_readAlarmHistoryMonth(int year, int month);
    Q_INVOKABLE QVariantList ddc_readAlarmHistoryPeriod(QString startDate, QString endDate);
    Q_INVOKABLE bool ddc_clearAlarmHistory();
    Q_INVOKABLE int ddc_getActiveAlarms();

    Q_INVOKABLE QVariantList ddc_getSchedules();
    Q_INVOKABLE bool ddc_addSchedule(const QVariantMap &schedule);
    Q_INVOKABLE bool ddc_setSchedule(const QVariantMap &schedule);
    Q_INVOKABLE bool ddc_deleteSchedule(QString scheduleIdText);

//////////////////////////Monitoring data/////////////////////////////////////
    //Q_INVOKABLE QVariantList getMonitorInData();
    Q_INVOKABLE QVariantList    getMonitorOutData();
    //Q_INVOKABLE QVariant getCircuitTemp(QString strMode);
    Q_INVOKABLE void setEcoMode(QString bMode);

    Q_INVOKABLE void setRunMode(QString runmode);
    Q_INVOKABLE QString getRunMode();

    Q_INVOKABLE void setCircuitTemp(QString value);
    Q_INVOKABLE QString getCircuitTemp();

    Q_INVOKABLE void setHotWaterTemp(QString value);
    Q_INVOKABLE QString getHotWaterTemp();

    Q_INVOKABLE void setIndoorTemp(QString value);
    Q_INVOKABLE QString getIndoorTemp();

    Q_INVOKABLE void setSetTemp(QString value);
    Q_INVOKABLE QString getSetTemp();

    Q_INVOKABLE void setOutsideTemp(QString value);
    Q_INVOKABLE QString getOutsideTemp();

    Q_INVOKABLE void setIndoorInputTemp(QString value);
    Q_INVOKABLE QString getIndoorInputTemp();

    Q_INVOKABLE void setIndoorOutputTemp(QString value);
    Q_INVOKABLE QString getIndoorOutputTemp();

    Q_INVOKABLE void setIndoorHeater(QString value);
    Q_INVOKABLE QString getIndoorHeater();

    Q_INVOKABLE void setIndoorDhwBoost(QString value);
    Q_INVOKABLE QString getIndoorDhwBoost();

    Q_INVOKABLE void setIndoorBufferTankTemp(QString value);
    Q_INVOKABLE QString getIndoorBufferTankTemp();

    Q_INVOKABLE void setIndoorTankUpTemp(QString value);
    Q_INVOKABLE QString getIndoorTankUpTemp();

    Q_INVOKABLE void setIndoorTankBottomTemp(QString value);
    Q_INVOKABLE QString getIndoorTankBottomTemp();

    Q_INVOKABLE QString getCurrentEnergy();
    Q_INVOKABLE QString getTotalEnergy();

    Q_INVOKABLE void setSilentMode(QString value);
    Q_INVOKABLE QString getSilentMode();

    Q_INVOKABLE void setThirdPartyBoilerMode(QString value);
    Q_INVOKABLE QString getThirdPartyBoilerMode();

    Q_INVOKABLE void setCoolWaterTemperature(QString value);
    Q_INVOKABLE QString getCoolWaterTemperature();

    Q_INVOKABLE void setHotWaterTemperature(QString value);
    Q_INVOKABLE QString getHotWaterTemperature();


    Q_INVOKABLE void setLanguage(QString value);
    Q_INVOKABLE QString getLanguage();

    Q_INVOKABLE void setTemperatureUnit(QString value);
    Q_INVOKABLE QString getTemperatureUnit();

    //Q_INVOKABLE void setTemperatureMinumUnit(QString value);
    //Q_INVOKABLE QString getTemperatureMinumUnit();

    Q_INVOKABLE void setTimeZone(QString value);
    Q_INVOKABLE QString getTimeZone();

    //bool setDate(QString date);
    //bool setTime(QString time);

    Q_INVOKABLE void setTimeFormat(QString value);
    Q_INVOKABLE QString getTimeFormate();

    Q_INVOKABLE void setScreenSaveTime(QString value);
    Q_INVOKABLE QString getScreenSaveTime();

    Q_INVOKABLE void setLCDBacklightIdle(QString value);
    Q_INVOKABLE QString getLCDBacklightIdle();

    Q_INVOKABLE void setAutoRetrunMainScreen(QString value);
    Q_INVOKABLE QString getAutoRetrunMainScreen();

    Q_INVOKABLE void setGeneralLock(QString value);
    Q_INVOKABLE QString getGeneralLock();

    Q_INVOKABLE void setModeLock(QString value);
    Q_INVOKABLE QString getModeLock();

    Q_INVOKABLE void setDHWLock(QString value);
    Q_INVOKABLE QString getDHWLock();

    Q_INVOKABLE void setWifi_Paring(QString value);
    Q_INVOKABLE QString getWifi_Paring();

    Q_INVOKABLE void setSystemReboot(QString value);

private:
    static QMutex m_Mutex;
    static AppModel *m_pInstance;

    class AppModelImpl;
    QSharedPointer<AppModelImpl> m_pImpl;
    DdcInteface *ddcInf;

    explicit AppModel(QObject *parent = nullptr);
    virtual ~AppModel();

    void initSignalSlot();

private slots:
    void onLanguageChanged();



//signals:
    OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(int, viewMode, ViewMode)
    signals: void viewModeChanged();
    OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(int, language, Language)
    signals: void languageChanged();
//    OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(bool, logMode, LogMode)
//    signals: void logModeChanged();
//    //Edit code
//    OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(QString, brightness, Brightness)
//    signals: void brightnessChanged();
//    OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(QString, menuHeading, MenuHeading)
//    signals: void menuHeadingChanged();

public:
    Q_PROPERTY(QString DUMMY_DATA_FOR_LANGUAGE_RELOAD READ DUMMY_DATA_FOR_LANGUAGE_RELOAD  NOTIFY languageChanged)
    QString DUMMY_DATA_FOR_LANGUAGE_RELOAD() const{return "";}
};

#endif // APPMODEL_H
