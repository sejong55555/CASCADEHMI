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
    Q_INVOKABLE QVariantList    GetMonitorInData();
    Q_INVOKABLE QVariantList    GetMonitorOutData();
    Q_INVOKABLE QVariantList    GetCircuitTemp(QString strMode);
    Q_INVOKABLE void            SetECOMode(bool bMode);

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


public:
    Q_PROPERTY(QString DUMMY_DATA_FOR_LANGUAGE_RELOAD READ DUMMY_DATA_FOR_LANGUAGE_RELOAD  NOTIFY languageChanged)
    QString DUMMY_DATA_FOR_LANGUAGE_RELOAD() const{return "";}
};

#endif // APPMODEL_H
