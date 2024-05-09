#include "AppModel.h"
#include "AppProperties.h"
#include "DefStrings.h"
#include "Sample.h"

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
    return ddcInf->addSchedule(schedule);
}

bool AppModel::ddc_setSchedule(const QVariantMap &schedule)
{
    return ddcInf->setSchedule(schedule);
}

bool AppModel::ddc_deleteSchedule(QString scheduleIdText)
{
    return ddcInf->deleteSchedule(scheduleIdText);
}

///////////////////////////////Monitoring data interface////////////////////////////////
/**
 * @brief 실내 모니터링 정보 반환 함수.
 */
QVariantList AppModel::GetMonitorInData()
{
//    Monitoring_in 데이터 구조
//    var varCircuitData = {
//       "strInsideTemp": "30",           // inside temperature
//       "strResolveTemp": "28",          // resolved inside temperature
//       "strOutsideTemp": "32",          // outside temperature.
//       "strInWaterTemp": "30",          // input water temperature.
//       "strOutWaterTemp": "25",         // out water temperature.
//       "listCircuitStates": ["ON", "ON","30"],
//       "listTankTemps": ["888", "555"],
//    };

    QVariantList listData = {0};
    return listData;
}

/**
 * @brief 실외 모니터링 정보 반환 함수.
 */
QVariantList AppModel::GetMonitorOutData()
{
//    Monitoring_out 데이터 구조
//    var varData = { "count"             : 4,
//                    "listTitle"         : ["heater", "DWH", "heater", "DWH"],
//                    "listInlet"         : [10, 20, 30, 40],
//                    "listOutlet"        : [10, 20, 30, 40],
//                    "listFlowrate"      : [10, 20, 30, 40],
//                    "listWaterpress"    : [10, 20, 30, 40]
//    }


    QVariantList listData = {0};
    return listData;
}

/**
 * @brief 실외 모니터링 정보 반환 함수.
 * @param strMode : cool, heat, auto, hot water
 */
QVariantList AppModel::GetCircuitTemp(QString strMode)
{
//    Circuit temp 데이터 구조
//    var varData = { "currentTemp": 21.5,
//                    "resolvedTemp": 20.0 }

    QVariantList listData = {0};
    return listData;
}

/**
 * @brief 에코 모드 설정 함수
 */
void AppModel::SetECOMode(bool bMode)
{
    bMode;
}
