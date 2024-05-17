#include "AppModel.h"
#include "AppProperties.h"
#include "DefStrings.h"
#include "Sample.h"
#include "Enums.h"

AppModel* AppModel::m_pInstance = nullptr;
QMutex AppModel::m_Mutex;

class AppModel::AppModelImpl
{
public:
    int             m_ViewMode;
    bool            m_LogMode;

    AppProperties   m_Properies;
    DefStrings      m_Strings;
    Sample          m_Sample;
};

/**
 * @brief Constructor for AppModel
 * @param QObject* parent
 */
AppModel::AppModel(QObject *parent)
    : QObject(parent),
      m_pImpl(QSharedPointer<AppModelImpl>(new AppModelImpl))
{
    m_pImpl->m_ViewMode = 0;
    m_pImpl->m_LogMode = false;
#ifdef ENABLE_DEBUG
    m_pImpl->m_LogMode = true;
#endif
    ddcInf = new DdcInteface();

}

/**
 * @brief Destructor AppModel
 */
AppModel::~AppModel()
{
    if(ddcInf != nullptr)
        delete ddcInf;
}

/**
 * @brief Get global define value
 * @return DefGlobal* global
 */
AppProperties* AppModel::getGlobalDefine() const
{
    VERBOSE();

    return &m_pImpl->m_Properies;
}

/**
 * @brief Get global string for using qt global string format
 * @return DefStrings* string
 */
DefStrings* AppModel::getStringDefine() const
{
    VERBOSE();

  return &m_pImpl->m_Strings;
}

/**
 * @brief On receving language is changed
 */
void AppModel::onLanguageChanged()
{
    VERBOSE();
}

int AppModel::GetTemperature()
{
    return m_pImpl->m_Sample.temperature();
}

void AppModel::SetTemperature(int nTemp)
{
    m_pImpl->m_Sample.setTemperature(nTemp);
    setTempVal(m_pImpl->m_Sample.temperature());
}

bool AppModel::ddc_setDate(QString date)
{
    return ddcInf->setDate(date);
}

bool AppModel::ddc_setTime(QString time)
{
    return ddcInf->setTime(time);
}

QVariantList AppModel::ddc_readPointValues(QList<QString> pointIds)
{
    return ddcInf->readPointValues(pointIds);
}

void AppModel::ddc_writePointValue(QString pointId, QString setValue)
{
    ddcInf->writePointValue(pointId, setValue);
}

void AppModel::ddc_writePointValues(const QVariantMap &setValues)
{
    ddcInf->writePointValues(setValues);
}

QVariantList AppModel::ddc_readAlarmHistoryAll()
{
    return ddcInf->readAlarmHistoryAll();
}

QVariantList AppModel::ddc_readAlarmHistoryMonth(int year, int month)
{
    return ddcInf->readAlarmHistoryMonth(year, month);
}

QVariantList AppModel::ddc_readAlarmHistoryPeriod(QString startDate, QString endDate)
{
    return ddcInf->readAlarmHistoryPeriod(startDate, endDate);
}

bool AppModel::ddc_clearAlarmHistory()
{
    return ddcInf->clearAlarmHistory();
}

int AppModel::ddc_getActiveAlarms()
{
    return ddcInf->getActiveAlarms();
}

QVariantList AppModel::ddc_getSchedules()
{
    return ddcInf->getSchedules();
}

bool AppModel::ddc_addSchedule(const QVariantMap &schedule)
{
    bool bResult = false;
    if(ddcInf->addSchedule(schedule))
    {
        bResult = true;

        if(bResult)
            emit sigScheduleChanged(ENUMS::SCHEDULE_ADD);
    }
    return bResult;
}

bool AppModel::ddc_setSchedule(const QVariantMap &schedule)
{
    bool bResult = false;
    if(ddcInf->setSchedule(schedule))
    {
        bResult = true;

        if(bResult)
            emit sigScheduleChanged(ENUMS::SCHEDULE_EDIT);
    }
    return bResult;
}

bool AppModel::ddc_deleteSchedule(QString scheduleIdText)
{
    bool bResult = false;
    if(ddcInf->deleteSchedule(scheduleIdText))
    {
        bResult = true;

        if(bResult)
            emit sigScheduleChanged(ENUMS::SCHEDULE_DELETE);
    }
    return bResult;
}

///////////////////////////////Monitoring data interface////////////////////////////////
/**
 * @brief 실내 모니터링 정보 반환 함수.
 */
/*
QVariantList AppModel::getMonitorInData()
{
    QVariantList  result = ddcInf->getMonitorInData();

    if (result.isEmpty()) {
        emit sigGetMonitorInData(false);
    } else {
        emit sigGetMonitorInData(true);
    }
    return  result;
}
*/

/**
 * @brief 실외 모니터링 정보 반환 함수.
 */
QVariantList AppModel::getMonitorOutData()
{
    QVariantList  result =  ddcInf->getMonitorOutData();

    if (result.isEmpty()) {
        emit sigGetMonitorOutData(false);
    } else {
        emit sigGetMonitorOutData(true);
    }

    return  result;
}

// QVariant AppModel::getCircuitTemp(QString strMode)
// {
//     QVariant  result = ddcInf->getCircuitTemp(strMode);

//     if (result.isNull() || !result.isValid()) {
//         emit sigGetCircuitTemp(false);
//     } else {
//         emit sigGetCircuitTemp(true);
//     }
//     return  result;
// }

/**
 * @brief 에코 모드 설정 함수
 */
void AppModel::setEcoMode(QString bMode)
{
    ddcInf->setEcoMode(bMode);
    emit sigSetEcoMode();
}

void AppModel::setRunMode(QString runmode)
{
    ddcInf->setRunMode(runmode);
}

QString AppModel::getRunMode()
{
    return ddcInf->getRunMode();
}

void AppModel::setCircuitTemp(QString value)
{
    ddcInf->setCircuitTemp(value);
}

QString AppModel::getCircuitTemp()
{
    return ddcInf->getCircuitTemp();
}

void AppModel::setHotWaterTemp(QString value)
{
    ddcInf->setHotWaterTemp(value);
}

QString AppModel::getHotWaterTemp()
{
    return ddcInf->getHotWaterTemp();
}


void AppModel::setIndoorTemp(QString value)
{
    ddcInf->setIndoorTemp(value);
}

QString AppModel::getIndoorTemp()
{
    return ddcInf->getIndoorTemp();
}

void AppModel::setSetTemp(QString value)
{
    ddcInf->setSetTemp(value);
}

QString AppModel::getSetTemp()
{
    return ddcInf->getSetTemp();
}

void AppModel::setOutsideTemp(QString value)
{
    ddcInf->setOutsideTemp(value);
}

QString AppModel::getOutsideTemp()
{
    return ddcInf->getOutsideTemp();
}

void AppModel::setIndoorInputTemp(QString value)
{
    ddcInf->setIndoorInputTemp(value);
}

QString AppModel::getIndoorInputTemp()
{
    return ddcInf->getIndoorInputTemp();
}

void AppModel::setIndoorOutputTemp(QString value)
{
    ddcInf->setIndoorOutputTemp(value);
}

QString AppModel::getIndoorOutputTemp()
{
    return ddcInf->getIndoorOutputTemp();
}

void AppModel::setIndoorHeater(QString value)
{
    ddcInf->setIndoorHeater(value);
}

QString AppModel::getIndoorHeater()
{
    return ddcInf->getIndoorHeater();
}

void AppModel::setIndoorDhwBoost(QString value)
{
    ddcInf->setIndoorDhwBoost(value);
}

QString AppModel::getIndoorDhwBoost()
{
    return ddcInf->getIndoorDhwBoost();
}

void AppModel::setIndoorBufferTankTemp(QString value)
{
    ddcInf->setIndoorBufferTankTemp(value);
}

QString AppModel::getIndoorBufferTankTemp()
{
    return ddcInf->getIndoorBufferTankTemp();
}


void AppModel::setIndoorTankUpTemp(QString value)
{
    ddcInf->setIndoorTankUpTemp(value);
}

QString AppModel::getIndoorTankUpTemp()
{
    return ddcInf->getIndoorTankUpTemp();
}

void AppModel::setIndoorTankBottomTemp(QString value)
{
    ddcInf->setIndoorTankBottomTemp(value);
}

QString AppModel::getIndoorTankBottomTemp()
{
    return ddcInf->getIndoorTankBottomTemp();
}

QString AppModel::getCurrentEnergy()
{
    return ddcInf->getCurrentEnergy();
}

QString AppModel::getTotalEnergy()
{
    return ddcInf->getTotalEnergy();
}

void AppModel::setSilentMode(QString value)
{
    ddcInf->setSilentMode(value);
}

QString AppModel::getSilentMode()
{
    return ddcInf->getSilentMode();
}

void AppModel::setThirdPartyBoilerMode(QString value)
{
    ddcInf->setThirdPartyBoilerMode(value);
}

QString AppModel::getThirdPartyBoilerMode()
{
    return ddcInf->getThirdPartyBoilerMode();
}

void AppModel::setCoolWaterTemperature(QString value)
{
    ddcInf->setCoolWaterTemperature(value);
}

QString AppModel::getCoolWaterTemperature()
{
    return ddcInf->getCoolWaterTemperature();
}

void AppModel::setHotWaterTemperature(QString value)
{
    ddcInf->setHotWaterTemperature(value);
}

QString AppModel::getHotWaterTemperature()
{
    return ddcInf->getHotWaterTemperature();
}

void AppModel::setLanguage(QString value)
{
    ddcInf->setLanguage(value);
}

QString AppModel::getLanguage()
{
    return ddcInf->getLanguage();
}

void AppModel::setTemperatureUnit(QString value)
{
    ddcInf->setTemperatureUnit(value);
}

QString AppModel::getTemperatureUnit()
{
    return ddcInf->getTemperatureUnit();
}

//void AppModel::setTemperatureMinumUnit(QString value)
//{
//    ddcInf->setTemperatureMinumUnit(value);
//}

//QString AppModel::getTemperatureMinumUnit()
//{
//    return ddcInf->getTemperatureMinumUnit();
//}

void AppModel::setTimeZone(QString value)
{
    ddcInf->setTimeZone(value);
}

QString AppModel::getTimeZone()
{
    return ddcInf->getTimeZone();
}

void AppModel::setTimeFormat(QString value)
{
    ddcInf->setTimeFormat(value);
}

QString AppModel::getTimeFormate()
{
    return ddcInf->getTimeFormate();
}

void AppModel::setScreenSaveTime(QString value)
{
    ddcInf->setScreenSaveTime(value);
}

QString AppModel::getScreenSaveTime()
{
    return ddcInf->getScreenSaveTime();
}

void AppModel::setLCDBacklightIdle(QString value)
{
    ddcInf->setLCDBacklightIdle(value);
}

QString AppModel::getLCDBacklightIdle()
{
    return ddcInf->getLCDBacklightIdle();
}

void AppModel::setAutoRetrunMainScreen(QString value)
{
    ddcInf->setAutoRetrunMainScreen(value);
}

QString AppModel::getAutoRetrunMainScreen()
{
    return ddcInf->getAutoRetrunMainScreen();
}

void AppModel::setGeneralLock(QString value)
{
    ddcInf->setGeneralLock(value);
}

QString AppModel::getGeneralLock()
{
    return ddcInf->getGeneralLock();
}

void AppModel::setModeLock(QString value)
{
    ddcInf->setModeLock(value);
}

QString AppModel::getModeLock()
{
    return ddcInf->getModeLock();
}

void AppModel::setDHWLock(QString value)
{
    ddcInf->setDHWLock(value);
}

QString AppModel::getDHWLock()
{
    return ddcInf->getDHWLock();
}

void AppModel::setWifi_Paring(QString value)
{
    ddcInf->setWifi_Paring(value);
}

QString AppModel::getWifi_Paring()
{
    return ddcInf->getWifi_Paring();
}

void AppModel::setSystemReboot(QString value)
{
    ddcInf->setSystemReboot(value);
}
