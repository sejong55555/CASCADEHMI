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

QString DdcInteface::getValue(QString pointID)
{
    QString result;

    QList<QString> pointIds;
    pointIds << pointID;
    m_controlPointValues = mDdcInstance->ReadPointValues(pointIds);

    if (!m_controlPointValues.isEmpty()) {
        for (ControlPointValue* cpv : m_controlPointValues) {
            qDebug() << "ID:" << cpv->getId() << "Present Value:" << cpv->getPresentValue();
            result = cpv->getPresentValue();
        }
    }

    return result;
}


// QVariantMap DdcInteface::getCircuitTemp(QString runmode)
// {
//     QVariantMap result;

//     qDebug()<<__FUNCTION__<<"runmode ="<<runmode;

//     result["currentTemp"] = getValue(currentTemp);
//     result["resolvedTemp"] =getValue(resolvedTemp);

//     return result;
// }

void DdcInteface::setEcoMode(QString onOff)
{
    //qDebug()<<__FUNCTION__<<"On/Off ="<<onOff;

    writePointValue(ECO_ONOFF_POINTID, onOff);
}

/*
QVariantList DdcInteface::getMonitorInData()
{
    QVariantList resultList;

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


    QVariantMap map;

    map["strInsideTemp"] = getValue(strInsideTemp); // inside temperature
    map["strResolveTemp"] = getValue(strResolveTemp); // resolved inside temperature
    map["strOutsideTemp"] = getValue(strOutsideTemp); // outside temperature.
    map["strInWaterTemp"] = getValue(strInWaterTemp); // input water temperature.
    map["strOutWaterTemp"] = getValue(strOutWaterTemp); // out water temperature.

    QVariantList listCircuitStateList;
    QString firstValue = getValue(listCircuitStates_1st);
    listCircuitStateList.append(firstValue);

    QString secondValue = getValue(listCircuitStates_2nd);
    listCircuitStateList.append(secondValue);

    QString thirdValue = getValue(listCircuitStates_3rd);
    listCircuitStateList.append(thirdValue);
    map[ "listCircuitStates"] = listCircuitStateList;

    QVariantList listTankTempList;
    firstValue = getValue(listTankTemps_1st);
    listTankTempList.append(firstValue);
    secondValue = getValue(listTankTemps_2nd);
    listTankTempList.append(secondValue);
    map["listTankTemps"] = listTankTempList;

    resultList.append(map);

    return resultList;
}
*/

QVariantList DdcInteface::getMonitorOutData()
{
    QVariantList resultList;
    resultList.clear();

    QVariantMap map;
    QString count;
    map["count"] = count = getValue(monitoring_out_count);

    bool conversionOK = false;
    int countValue = count.toInt(&conversionOK);
    if (!conversionOK) {
        qWarning()<<__FUNCTION__<<"Fail, read count, outLet ";
        return resultList;
    }
    map["count"] =countValue;

    QVariantList listTitleList;
    QVariantList listInletList;
    QVariantList listOutletList;
    QVariantList listFlowrateList;
    QVariantList listWaterpressList;

    listTitleList.clear();
    listInletList.clear();
    listOutletList.clear();
    listFlowrateList.clear();
    listWaterpressList.clear();

    QString setValue;
    setValue.clear();

    switch (countValue) {
        case 1:
            map["listTitle"] = getValue(monitoring_out_listTitle_1);
            map["listInlet"] = getValue(monitoring_out_listInlet_1);
            map["listOutlet"] = getValue(monitoring_out_listOutlet_1);
            map["listFlowrate"] = getValue(monitoring_out_listFlowrate_1);
            map["listWaterpress"] = getValue(monitoring_out_listWaterpress_1);
            break;

        case 2:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 3:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 4:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 5:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_5);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_5);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_5);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_5);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_5);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 6:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_5);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_6);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_5);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_6);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_5);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_6);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_5);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_6);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_5);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_6);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 7:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_5);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_6);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_7);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_5);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_6);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_7);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_5);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_6);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_7);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_5);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_6);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_7);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_5);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_6);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_7);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 8:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_5);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_6);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_7);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_8);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_5);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_6);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_7);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_8);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_5);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_6);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_7);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_8);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_5);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_6);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_7);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_8);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_5);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_6);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_7);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_8);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 9:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_5);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_6);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_7);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_8);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_9);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_5);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_6);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_7);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_8);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_9);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_5);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_6);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_7);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_8);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_9);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_5);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_6);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_7);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_8);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_9);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_5);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_6);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_7);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_8);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_9);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        case 10:
            //List title
            setValue = getValue(monitoring_out_listTitle_1);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_2);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_3);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_4);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_5);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_6);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_7);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_8);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_9);
            listTitleList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listTitle_10);
            listTitleList.append(setValue);
            setValue.clear();
            map["listTitle"] = listTitleList;

            //List in Let
            setValue = getValue(monitoring_out_listInlet_1);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_2);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_3);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_4);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_5);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_6);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_7);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_8);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_9);
            listInletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listInlet_10);
            listInletList.append(setValue);
            setValue.clear();
            map["listInlet"] = listInletList;

            //List out Let
            setValue = getValue(monitoring_out_listOutlet_1);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_2);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_3);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_4);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_5);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_6);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_7);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_8);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_9);
            listOutletList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listOutlet_10);
            listOutletList.append(setValue);
            setValue.clear();
            map["listOutlet"] = listOutletList;

            //List in Let
            setValue = getValue(monitoring_out_listFlowrate_1);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_2);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_3);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_4);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_5);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_6);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_7);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_8);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_9);
            listFlowrateList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listFlowrate_10);
            listFlowrateList.append(setValue);
            setValue.clear();
            map["listFlowrate"] = listFlowrateList;

            //List out Let
            setValue = getValue(monitoring_out_listWaterpress_1);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_2);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_3);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_4);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_5);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_6);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_7);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_8);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_9);
            listWaterpressList.append(setValue);
            setValue.clear();
            setValue = getValue(monitoring_out_listWaterpress_10);
            listWaterpressList.append(setValue);
            setValue.clear();
            map["listWaterpress"] = listWaterpressList;
            break;

        default: //
            break;
    }
    resultList.append(map);
    return resultList;
}


void DdcInteface::setRunMode(QString runmode)
{    
    writePointValue(running_mode, runmode);
}

QString DdcInteface::getRunMode()
{
    QString result;
    result = getValue(running_mode);
    return result;
}

void DdcInteface::setCircuitTemp(QString value)
{
    writePointValue(circuit_temp, value);
}

QString DdcInteface::getCircuitTemp()
{
    QString result;
    result = getValue(circuit_temp);
    return result;
}

void DdcInteface::setHotWaterTemp(QString value)
{
    writePointValue(hotwater_temp, value);
}

QString DdcInteface::getHotWaterTemp()
{
    QString result;
    result = getValue(hotwater_temp);
    return result;
}


void DdcInteface::setIndoorTemp(QString value)
{
    writePointValue(indoor_temp, value);
}

QString DdcInteface::getIndoorTemp()
{
    QString result;
    result = getValue(indoor_temp);
    return result;
}

void DdcInteface::setSetTemp(QString value)
{
    writePointValue(set_temp, value);
}

QString DdcInteface::getSetTemp()
{
    QString result;
    result = getValue(set_temp);
    return result;
}

void DdcInteface::setOutsideTemp(QString value)
{
    writePointValue(outside_temp, value);
}

QString DdcInteface::getOutsideTemp()
{
    QString result;
    result = getValue(outside_temp);
    return result;
}

void DdcInteface::setIndoorInputTemp(QString value)
{
    writePointValue(indoor_input_temp, value);
}

QString DdcInteface::getIndoorInputTemp()
{
    QString result;
    result = getValue(indoor_input_temp);
    return result;
}

void DdcInteface::setIndoorOutputTemp(QString value)
{
    writePointValue(indoor_output_temp, value);
}

QString DdcInteface::getIndoorOutputTemp()
{
    QString result;
    result = getValue(indoor_output_temp);
    return result;
}


void DdcInteface::setIndoorHeater(QString value)
{
    //qDebug()<<__FUNCTION__<<"##  value ="<<value;
    writePointValue(indoor_heater, value);
}

QString DdcInteface::getIndoorHeater()
{
    QString result;
    result = getValue(indoor_heater);
    //qDebug()<<__FUNCTION__<<"@@ value ="<<result;
    return result;
}

void DdcInteface::setIndoorDhwBoost(QString value)
{
    writePointValue(indoor_dhw_boost, value);
}

QString DdcInteface::getIndoorDhwBoost()
{
    QString result;
    result = getValue(indoor_dhw_boost);
    return result;
}

void DdcInteface::setIndoorBufferTankTemp(QString value)
{
    writePointValue(indoor_buffer_tank_temp, value);
}

QString DdcInteface::getIndoorBufferTankTemp()
{
    QString result;
    result = getValue(indoor_buffer_tank_temp);
    return result;
}

void DdcInteface::setIndoorTankUpTemp(QString value)
{
    writePointValue(indoor_tank_up_temp, value);
}

QString DdcInteface::getIndoorTankUpTemp()
{
    QString result;
    result = getValue(indoor_tank_up_temp);
    return result;
}

void DdcInteface::setIndoorTankBottomTemp(QString value)
{
    writePointValue(indoor_tank_bottom_temp, value);
}

QString DdcInteface::getIndoorTankBottomTemp()
{
    QString result;
    result = getValue(indoor_tank_bottom_temp);
    return result;
}

QString DdcInteface::getCurrentEnergy()
{
    QString result;
    result = getValue(energy_current);
    return result;
}

QString DdcInteface::getTotalEnergy()
{
    QString result;
    result = getValue(energy_total);
    return result;
}

void DdcInteface::setSilentMode(QString value)
{
    writePointValue(silent_mode, value);
}

QString DdcInteface::getSilentMode()
{
    QString result;
    result = getValue(silent_mode);
    return result;
}

void DdcInteface::setThirdPartyBoilerMode(QString value)
{
    writePointValue(third_party_boiler_mode, value);
}

QString DdcInteface::getThirdPartyBoilerMode()
{
    QString result;
    result = getValue(third_party_boiler_mode);
    return result;
}

void DdcInteface::setCoolWaterTemperature(QString value)
{
    writePointValue(cool_water_temp, value);
}

QString DdcInteface::getCoolWaterTemperature()
{
    QString result;
    result = getValue(cool_water_temp);
    return result;
}

void DdcInteface::setHotWaterTemperature(QString value)
{
    writePointValue(hot_water_temp, value);
}

QString DdcInteface::getHotWaterTemperature()
{
    QString result;
    result = getValue(hot_water_temp);
    return result;
}


void DdcInteface::setLanguage(QString value)
{
    writePointValue(general_setting_language, value);
}

QString DdcInteface::getLanguage()
{
    QString result;
    result = getValue(general_setting_language);
    return result;
}

void DdcInteface::setTemperatureUnit(QString value)
{
    writePointValue(general_setting_temperautre_unit, value);
}

QString DdcInteface::getTemperatureUnit()
{
    QString result;
    result = getValue(general_setting_temperautre_unit);
    return result;
}

//void DdcInteface::setTemperatureMinumUnit(QString value)
//{
//    writePointValue(general_setting_temperautre_minimum, value);
//}

//QString DdcInteface::getTemperatureMinumUnit()
//{
//    QString result;
//    result = getValue(general_setting_temperautre_minimum);
//   return result;
//}

void DdcInteface::setTimeZone(QString value)
{
    writePointValue(general_setting_timezone, value);
}

QString DdcInteface::getTimeZone()
{
    QString result;
    result = getValue(general_setting_timezone);
    return result;
}

//bool setDate(QString date);
//bool setTime(QString time);

void DdcInteface::setTimeFormat(QString value)
{
    writePointValue(general_setting_timeformat, value);
}

QString DdcInteface::getTimeFormate()
{
    QString result;
    result = getValue(general_setting_timeformat);
    return result;
}

void DdcInteface::setScreenSaveTime(QString value)
{
    writePointValue(general_setting_screenSave_timer, value);
}

QString DdcInteface::getScreenSaveTime()
{
    QString result;
    result = getValue(general_setting_screenSave_timer);
    return result;
}

void DdcInteface::setLCDBacklightIdle(QString value)
{
    writePointValue(general_setting_screenSave_lcdbacklight_idle, value);
}

QString DdcInteface::getLCDBacklightIdle()
{
    QString result;
    result = getValue(general_setting_screenSave_lcdbacklight_idle);
    return result;
}

void DdcInteface::setAutoRetrunMainScreen(QString value)
{
    writePointValue(general_setting_screenSave_auto_return_main_screen, value);
}

QString DdcInteface::getAutoRetrunMainScreen()
{
    QString result;
    result = getValue(general_setting_screenSave_auto_return_main_screen);
    return result;
}

void DdcInteface::setGeneralLock(QString value)
{
    writePointValue(general_setting_lock_onoff, value);
}

QString DdcInteface::getGeneralLock()
{
    QString result;
    result = getValue(general_setting_lock_onoff);
    return result;
}

void DdcInteface::setModeLock(QString value)
{
    writePointValue(general_setting_mode_lock, value);
}

QString DdcInteface::getModeLock()
{
    QString result;
    result = getValue(general_setting_mode_lock);
    return result;
}

void DdcInteface::setDHWLock(QString value)
{
    writePointValue(general_setting_dhw_lock, value);
}

QString DdcInteface::getDHWLock()
{
    QString result;
    result = getValue(general_setting_dhw_lock);
    return result;
}

void DdcInteface::setWifi_Paring(QString value)
{
    writePointValue(general_setting_wifi_paring, value);
}

QString DdcInteface::getWifi_Paring()
{
    QString result;
    result = getValue(general_setting_wifi_paring);
    return result;
}

void DdcInteface::setSystemReboot(QString value)
{
    writePointValue(general_setting_system_reboot, value);
}

