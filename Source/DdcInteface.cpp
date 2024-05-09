#include <QGuiApplication>
#include "DdcInteface.h"

DdcInteface::DdcInteface(QObject *parent) : QObject(parent)
{
    if(NULL!=mDdcInstance)
        return;
    mDdcInstance = new DdcClient();

#if(DEBUG_SAVE_LOG)
    inifile = QGuiApplication::applicationDirPath();
    qDebug() << __FUNCTION__ <<" ddc Interface Initialized" << " , build Path =" <<inifile;

    m_saveLog = QSqlDatabase::addDatabase("QSQLITE");
    m_saveLog.setDatabaseName(inifile+"/saveLog.db");

    if(m_saveLog.open()){
        qDebug()<<__FUNCTION__<<"Save log Database open successful";

    }
    else{
        qDebug()<<__FUNCTION__<<"#Database open fail:"<<m_saveLog.lastError();
    }

    QSqlQuery query;
    bool success = query.exec(CREATE_TABLE_SYS_LOG);
    if (!success) {
        qDebug() << "Table creation failed:" << query.lastError().text();
    } else {
        qDebug() << "Table created successfully!";
    }

    success = query.exec(CLEAR_TABLE_SYS_LOG);
    if (!success) {
        qDebug() << "Table clear failed:" << query.lastError().text();
    } else {
        qDebug() << "Table clear successfully!";
    }

#endif

}

DdcInteface::~DdcInteface()
{
    if(mDdcInstance != nullptr)
        delete mDdcInstance;
}

QList<ControlPointValue*> DdcInteface::getControlPointValues() const
{
    return m_controlPointValues;
}

bool DdcInteface::setDate(QString date)
{
#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("setDate", date,"","" );
#endif
    return mDdcInstance->SetDate(date);
}

bool DdcInteface::setTime(QString time)
{
#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("setTime", time,"","" );
#endif
    return mDdcInstance->SetTime(time);
}

QVariantList DdcInteface::readPointValues(QList<QString> pointIds)
{
    QVariantList resultList;

#if(DEBUG_SAVE_LOG)
    QStringList setLogList;
    QStringList saveLogList;

    for(const QString &id : pointIds) {
        setLogList.append(id);
        setLogList.append(" ");
    }

#endif
    m_controlPointValues = mDdcInstance->ReadPointValues(pointIds);

    if (!m_controlPointValues.isEmpty()) {
        for (ControlPointValue* cpv : m_controlPointValues) {
            //qDebug() << "ID:" << cpv->getId() << "Present Value:" << cpv->getPresentValue();

            QVariantMap map;
            map["id"] = cpv->getId();
            map["presentValue"] = cpv->getPresentValue();
            map["correctionValue"] = cpv->getCorrectionValue();
            map["alarmStatus"] = cpv->getAlarmStatus();
            map["outOfService"] = cpv->getOutOfService();

            // Append the map to the resultList
            resultList.append(map);
#if(DEBUG_SAVE_LOG)
            saveLogList.append(cpv->getId());
            saveLogList.append(" ");
            saveLogList.append(cpv->getPresentValue());
            saveLogList.append(", ");
#endif
        }
    }

#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("readPointValues", setLogList.join(""), saveLogList.join(""),"" );
#endif

    return resultList;
}

void DdcInteface::writePointValue(QString pointId, QString setValue)
{
    //qDebug() << __FUNCTION__ << "Point IDs:"<<pointId <<" , setValue ="<<setValue;
    WriteControlPointValue m_wControlPointValue;
    m_wControlPointValue.setId(pointId);
    m_wControlPointValue.setSetValue(setValue);
    mDdcInstance->WritePointValue(&m_wControlPointValue);

#if(DEBUG_SAVE_LOG)
    QStringList saveLogList;
    saveLogList.append(pointId);
    saveLogList.append(" ");
    saveLogList.append(setValue);
    saveLogList.append(", ");
    saveEngineInterfaceLog("writePointValue", saveLogList.join(""),"" , "" );
#endif
}

void DdcInteface::writePointValues(const QVariantMap &setValues)
{
    if (setValues.contains("controlPointValues") && setValues["controlPointValues"].type() == QVariant::List) {
        QVariantList controlPointValuesList = setValues.value("controlPointValues").toList();
        for (const QVariant &controlPointValueVariant : controlPointValuesList) {

            QVariantMap controlPointValueMap = controlPointValueVariant.toMap();
            if (controlPointValueMap.contains("id") && controlPointValueMap.contains("presentValue")) {
                QString id = controlPointValueMap["id"].toString();
                QString presentValue = controlPointValueMap["presentValue"].toString();
                this->writePointValue(id,presentValue);
            }
        }
    }
}

QVariantList DdcInteface::readAlarmHistoryAll()
{
    QVariantList resultList;
#if(DEBUG_SAVE_LOG)
    QStringList saveLogList;
#endif

    m_alarmInfo =mDdcInstance->ReadAlarmHistoryAll();

    if (!m_alarmInfo.isEmpty()) {
        for (AlarmInfo* ai : m_alarmInfo) {
            qDebug() << "alarm code:" << ai->getAlarmCode() << " current time:" << ai->getOccurTime() << " current date:"
                     <<ai->getOccurDate() << "recover date:"<<ai->getRecoverDate() << "recover time :"<<ai->getRecoverTime()<<" is recover :"<<ai->getIsRecovered();
            QVariantMap map;
            map["occurDate"] = ai->getOccurDate();
            map["occurTime"] = ai->getOccurTime();
            map["recoverDate"] = ai->getRecoverDate();
            map["recoverTime"] = ai->getRecoverTime();
            map["alarmCode"] = ai->getAlarmCode();
            map["isRecovered"] = ai->getIsRecovered();
            resultList.append(map);

#if(DEBUG_SAVE_LOG)
            saveLogList.append(ai->getAlarmCode());
            saveLogList.append(" ");
            saveLogList.append(ai->getOccurTime());
            saveLogList.append(" ");
            saveLogList.append(ai->getOccurDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getRecoverDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getRecoverTime());
            saveLogList.append(" ");
            ai->getIsRecovered() ? saveLogList.append("true"):saveLogList.append("false");
            saveLogList.append(", ");
#endif
        }
    }

#if(DEBUG_SAVE_LOG)
    qDebug()<<__FUNCTION__;
    saveEngineInterfaceLog("readAlarmHistoryAll", "",saveLogList.join("") , "" );
#endif
    return resultList;
}

QVariantList DdcInteface::readAlarmHistoryMonth(int year, int month)
{
    QVariantList resultList;

#if(DEBUG_SAVE_LOG)
    QStringList saveLogList;
#endif
    m_alarmInfo =mDdcInstance->ReadAlarmHistoryMonth(year, month);

    if (!m_alarmInfo.isEmpty()) {
        for (AlarmInfo* ai : m_alarmInfo) {
            qDebug() << "alarm code:" << ai->getAlarmCode() << " current time:" << ai->getOccurTime() << " current date:"
                     <<ai->getOccurDate() << "recover date:"<<ai->getRecoverDate() << "recover time :"<<ai->getRecoverTime()<<" is recover :"<<ai->getIsRecovered();
            QVariantMap map;
            map["occurDate"] = ai->getOccurDate();
            map["occurTime"] = ai->getOccurTime();
            map["recoverDate"] = ai->getRecoverDate();
            map["recoverTime"] = ai->getRecoverTime();
            map["alarmCode"] = ai->getAlarmCode();
            map["isRecovered"] = ai->getIsRecovered();
            resultList.append(map);

#if(DEBUG_SAVE_LOG)
            saveLogList.append(ai->getAlarmCode());
            saveLogList.append(" ");
            saveLogList.append(ai->getOccurTime());
            saveLogList.append(" ");
            saveLogList.append(ai->getOccurDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getRecoverDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getRecoverTime());
            saveLogList.append(" ");
            ai->getIsRecovered() ? saveLogList.append("true"):saveLogList.append("false");
            saveLogList.append(", ");
#endif
        }
    }

#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("readAlarmHistoryMonth", QString::number(year)+" " +QString::number(month),saveLogList.join("") , "" );
#endif
    return resultList;
}

QVariantList DdcInteface::readAlarmHistoryPeriod(QString startDate, QString endDate)
{
    QVariantList resultList;
#if(DEBUG_SAVE_LOG)
    QStringList saveLogList;
#endif

    m_alarmInfo =mDdcInstance->ReadAlarmHistoryPeriod(startDate, endDate);

    if (!m_alarmInfo.isEmpty()) {
        for (AlarmInfo* ai : m_alarmInfo) {
            qDebug() << "alarm code:" << ai->getAlarmCode() << " current time:" << ai->getOccurTime() << " current date:"
                     <<ai->getOccurDate() << "recover date:"<<ai->getRecoverDate() << "recover time :"<<ai->getRecoverTime()<<" is recover :"<<ai->getIsRecovered();
            QVariantMap map;
            map["occurDate"] = ai->getOccurDate();
            map["occurTime"] = ai->getOccurTime();
            map["recoverDate"] = ai->getRecoverDate();
            map["recoverTime"] = ai->getRecoverTime();
            map["alarmCode"] = ai->getAlarmCode();
            map["isRecovered"] = ai->getIsRecovered();
            resultList.append(map);

#if(DEBUG_SAVE_LOG)
            saveLogList.append(ai->getOccurDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getOccurTime());
            saveLogList.append(" ");
            saveLogList.append(ai->getOccurDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getRecoverDate());
            saveLogList.append(" ");
            saveLogList.append(ai->getRecoverTime());
            saveLogList.append(" ");
            ai->getIsRecovered() ? saveLogList.append("true"):saveLogList.append("false");
            saveLogList.append(", ");
#endif
        }
    }

#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("readAlarmHistoryPeriod", startDate+" " +endDate, saveLogList.join("") , "" );
#endif

    return resultList;
}

bool DdcInteface::clearAlarmHistory()
{
#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("clearAlarmHistory", "", "" , "" );
#endif
    return mDdcInstance->ClearAlarmHistory();
}

int DdcInteface::getActiveAlarms()
{
#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("getActiveAlarms", "",  QString::number(mDdcInstance->GetActiveAlarms()) , "" );
#endif
    return mDdcInstance->GetActiveAlarms();
}

QVariantList DdcInteface::getSchedules()
{
    //return m_schedule = mDdcInstance->GetSchedules();
    QVariantList resultList;
    m_schedule = mDdcInstance->GetSchedules();

    if(!m_schedule.isEmpty()){

        for (Schedule* cpv : m_schedule) {
            QVariantMap map;
            map["isUse"] = cpv->getIsUse();
            map["isSpecial"] = cpv->getIsSpecial();
            map["time"] = cpv->getTime();
            map["id"] = cpv->getId();
            map["name"] = cpv->getName();
            map["timeText"] = cpv->getTimeText();

            QVariantList daysList;
            for (const QString &day : cpv->getDays()) {
                daysList.append(day);
            }
            map["days"] = daysList;

            QVariantList weekScheduleList;
            for (const QString &weekSchedule : cpv->getWeeklySchedules()) {
                weekScheduleList.append(weekSchedule);
            }
            map["weeklySchedules"] = weekScheduleList;


            QVariantList crontabCommandsList;
            for (const QString &crontabCommand : cpv->getCrontabCommands()) {
                crontabCommandsList.append(crontabCommand);
            }
            map["crontabCommands"] = crontabCommandsList;

            QVariantList controlPointValuesList;
            for (ControlPointValue* controlPointValue : cpv->getControlPointValues()) {
                QVariantMap controlPointValueMap;
                controlPointValueMap["alarmStatus"] = controlPointValue->getAlarmStatus();
                controlPointValueMap["outOfService"] = controlPointValue->getOutOfService();
                controlPointValueMap["correctionValue"] = controlPointValue->getCorrectionValue();
                controlPointValueMap["id"] = controlPointValue->getId();
                controlPointValueMap["presentValue"] = controlPointValue->getPresentValue();
                controlPointValuesList.append(controlPointValueMap);
            }
            map["controlPointValues"] = controlPointValuesList;

            // Append the map to the resultList
            resultList.append(map);
        }
    }

#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("getSchedules", "", "" , "" );
#endif
    return resultList;
}

bool DdcInteface::addSchedule(const QVariantMap &schedule)
{
    if (schedule.isEmpty()) {
        qDebug() << "Error: Empty QVariantMap received for schedule.";
        return false;
    }

    Schedule m_schedule;
    if(schedule.contains("id"))
        m_schedule.setId(schedule.value("id").toString());

    if(schedule.contains("name"))
        m_schedule.setName(schedule.value("name").toString());

    if(schedule.contains("time"))
        m_schedule.setTimeText(schedule.value("time").toString());

    if(schedule.contains("isUse"))
        m_schedule.setIsUse(schedule.value("isUse").toBool());

    if(schedule.contains("isSpecial"))
        m_schedule.setIsSpecial(schedule.value("isSpecial").toBool());

    if(schedule.contains("day")){
        QVariantList dayList = schedule.value("day").toList();
        foreach(const QVariant &value, dayList) {
            m_schedule.AppendDay(value.toString());
        }
    }

    if(schedule.contains("weeklySchedules")){
        QVariantList weeklyList = schedule.value("weeklySchedules").toList();
        foreach(const QVariant &value, weeklyList) {
            //qDebug()<<__FUNCTION__<<".... : " <<value.toString();
            m_schedule.AppendWeeklySchedule(value.toString());
        }
    }

    if(schedule.contains("crontabCommands"))
        m_schedule.AppendCrontabCommands(schedule.value("crontabCommands").toString());

    if (schedule.contains("controlPointValues") && schedule["controlPointValues"].type() == QVariant::List) {
        QVariantList controlPointValuesList = schedule.value("controlPointValues").toList();
        for (const QVariant &controlPointValueVariant : controlPointValuesList) {
            QVariantMap controlPointValueMap = controlPointValueVariant.toMap();
            if (controlPointValueMap.contains("id") && controlPointValueMap.contains("presentValue")) {
                QString id = controlPointValueMap["id"].toString();
                QString presentValue = controlPointValueMap["presentValue"].toString();
                ControlPointValue *pointValue = new ControlPointValue(this);
                pointValue->setId(id);
                pointValue->setPresentValue(presentValue);
                m_schedule.AppendControlPointValue(pointValue);
            }
        }
    }

#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("addSchedule", "", "" , "" );
#endif

    return mDdcInstance->AddSchedule(&m_schedule);
}

bool DdcInteface::setSchedule(const QVariantMap &schedule)
{
    if (schedule.isEmpty()) {
        qDebug() << "Error: Empty QVariantMap received for schedule.";
        return false;
    }

    Schedule m_schedule;

    if(schedule.contains("id"))
        m_schedule.setId(schedule.value("id").toString());

    if(schedule.contains("name"))
        m_schedule.setName(schedule.value("name").toString());

    if(schedule.contains("time"))
        m_schedule.setTimeText(schedule.value("time").toString());

    if(schedule.contains("isUse"))
        m_schedule.setIsUse(schedule.value("isUse").toBool());

    if(schedule.contains("isSpecial"))
        m_schedule.setIsSpecial(schedule.value("isSpecial").toBool());

    if(schedule.contains("day")){
        QVariantList dayList = schedule.value("day").toList();
        foreach(const QVariant &value, dayList) {
            m_schedule.AppendDay(value.toString());
        }
    }

    if(schedule.contains("weeklySchedules")){
        QVariantList weeklyList = schedule.value("weeklySchedules").toList();
        foreach(const QVariant &value, weeklyList) {
            //qDebug()<<__FUNCTION__<<".... : " <<value.toString();
            m_schedule.AppendWeeklySchedule(value.toString());
        }
    }

    if(schedule.contains("crontabCommands"))
        m_schedule.AppendCrontabCommands(schedule.value("crontabCommands").toString());

    if (schedule.contains("controlPointValues") && schedule["controlPointValues"].type() == QVariant::List) {
        QVariantList controlPointValuesList = schedule.value("controlPointValues").toList();
        for (const QVariant &controlPointValueVariant : controlPointValuesList) {
            QVariantMap controlPointValueMap = controlPointValueVariant.toMap();
            if (controlPointValueMap.contains("id") && controlPointValueMap.contains("presentValue")) {
                QString id = controlPointValueMap["id"].toString();
                QString presentValue = controlPointValueMap["presentValue"].toString();
                ControlPointValue *pointValue = new ControlPointValue(this);
                pointValue->setId(id);
                pointValue->setPresentValue(presentValue);
                m_schedule.AppendControlPointValue(pointValue);
            }
        }
    }

#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("setSchedule", "", "" , "" );
#endif

    return mDdcInstance->SetSchedule(&m_schedule);
}

bool DdcInteface::deleteSchedule(QString scheduleIdText)
{
#if(DEBUG_SAVE_LOG)
    saveEngineInterfaceLog("deleteSchedule", scheduleIdText, " ", " ");
#endif
    return mDdcInstance->DeleteSchedule(scheduleIdText);
}

#if(DEBUG_SAVE_LOG)
bool DdcInteface::saveEngineInterfaceLog(QString source, QString set_value, QString get_value, QString the_others)
{
    bool isSuccess = false;

    m_saveLog = QSqlDatabase::addDatabase("QSQLITE");
    m_saveLog.setDatabaseName(inifile+"/saveLog.db");

    if(m_saveLog.open()){
        qDebug()<<__FUNCTION__<<"Save log Database open successful";

    }
    else{
        qDebug()<<__FUNCTION__<<"#Database open fail:"<<m_saveLog.lastError();
    }

    QDateTime timestamp = QDateTime::currentDateTime();
    QString mDebugTime = timestamp.toString("yyyy-MM-dd hh:mm:ss");

    QString query ="";
    query =QString(INSERT_SYS_LOG).arg(mDebugTime).arg(source).arg(set_value).arg(get_value).arg(the_others);

    QSqlQuery qry;
    qry.prepare(query);

    if(qry.exec()){
        //qDebug()<<__FUNCTION__<<"#exec() successful";
        isSuccess = true;
    }
    else{
        qWarning() << "[executeSqlQuery]" << "#exec() fail";
        qWarning() << "[executeSqlQuery]" << "#query : " << query;
        qWarning() << "[executeSqlQuery]" << "#last Error:" << qry.lastError();
        isSuccess = false;
    }
    return isSuccess;
}

#endif
