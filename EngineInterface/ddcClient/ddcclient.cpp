#include "ddcclient.h"
#include <QtSql>
#include <string>

#include <QGuiApplication>

#define TIMEOUT_SYSTEM_MANAGER  120
#define DEFAULT_START_DATE  "20230101"
#define DEFAULT_END_DATE    "20371231"

DdcClient::DdcClient(QObject *parent) : QObject(parent)
{
#ifndef MOCK_TEST
    int ret = POINT_attach();
    if(0 != ret)
    {
        qWarning("Point Attach failed.\n");
    }
#endif
    QSqlDatabase::addDatabase("QSQLITE");
    qDebug() << "SQLite added.";

    SCHEDULE_DB_PATH = QGuiApplication::applicationDirPath()+"/schedule_setting.db";
    qDebug() <<"Scheduel DB Path ="<<SCHEDULE_DB_PATH;

    ALARM_DB_PATH = QGuiApplication::applicationDirPath()+"/alarm.db";
    qDebug() <<"Scheduel DB Path ="<<ALARM_DB_PATH;

}

bool DdcClient::SetDateTime(QString date, QString time)
{
    bool bResult = true;
    QString setDateTime;
    setDateTime = QString("date -s \"%1 %2\"").arg(date, time);
    int result = system(setDateTime.toStdString().c_str());
    if(result == -1)
    {
        qDebug() << "Failed to change date time.";
        bResult = false;
    }

    result = system("/sbin/hwclock -w");
    if(result == -1)
    {
        qDebug() << "Failed to sync hardware clock.";
        bResult = false;
    }
    qDebug() << "setDateTime >> " << bResult;
    return bResult;
}

bool DdcClient::SetDate(QString &date)
{
    QTime curTime = QTime::currentTime();
    return this->SetDateTime(date, curTime.toString("hh:mm:ss"));
}

bool DdcClient::SetTime(QString &time)
{
    QDateTime current = QDateTime::currentDateTime();
    return this->SetDateTime(current.toString("yyyy-MM-dd"), time);
}

QList<ControlPointValue*> DdcClient::ReadPointValues(QList<QString> pointIds)
{
    QList<ControlPointValue*> controlPointValues;
#ifndef MOCK_TEST
    int nReturnValue = 0;
    POINT_READ_ARGUMENT	stPointargument;
    POINT_DATA stpointdata;
    bool bStatus = false;


    foreach(QString idText, pointIds)
    {
        int pointId = idText.toInt(&bStatus, 16);
        if(bStatus == false)
        {
            qDebug() << "Error: In ReadPointValues toInt error ID : " << idText;
            continue;
        }
        ControlPointValue *pPointValue = new ControlPointValue;
        pPointValue->setId(idText);

        stPointargument.key_type = POINT_KEY_IDENTIFIER;
        stPointargument.key.point_id = pointId;
        stpointdata.pd_type = POINT_DATATYPE_STRING;
        stPointargument.property_identifier = POINT_PROPERTY_PRESENT_VALUE;
        nReturnValue = POINT_read_property(stPointargument, &stpointdata);
        if (0 == nReturnValue)
        {
            pPointValue->setPresentValue(stpointdata.pd.s_val);
            stpointdata.pd_type = POINT_DATATYPE_UNSIGNED;
            stPointargument.property_identifier = POINT_PROPERTY_ALARM_STATE;
            nReturnValue = POINT_read_property(stPointargument, &stpointdata);
            if (0 != nReturnValue)
            {
                pPointValue->setAlarmStatus(-1);
            }
            else
            {
                pPointValue->setAlarmStatus(stpointdata.pd.u_val);
            }
            stPointargument.property_identifier = POINT_PROPERTY_OUT_OF_SERVICE;
            nReturnValue = POINT_read_property(stPointargument, &stpointdata);
            if (0 != nReturnValue)
            {
                pPointValue->setOutOfService(-1);
            }
            else
            {
                pPointValue->setOutOfService(stpointdata.pd.u_val);
            }
            stpointdata.pd_type = POINT_DATATYPE_REAL;
            stPointargument.property_identifier = POINT_PROPERTY_CORRECT_VALUE;
            nReturnValue = POINT_read_property(stPointargument, &stpointdata);
            if (0 != nReturnValue)
            {
                pPointValue->setCorrectionValue(-9999.9999);
            }
            else
            {
                pPointValue->setCorrectionValue(stpointdata.pd.r_val);
            }
        }
        controlPointValues.append(pPointValue);
    }
#else
    //temporary test -->
    bool bStatus = false;
    int valueCounter = 1;
    foreach(QString idText, pointIds)
    {
        ControlPointValue *pPointValue = new ControlPointValue;
        pPointValue->setId(idText);
        pPointValue->setPresentValue(QString::number(valueCounter));
        pPointValue->setAlarmStatus(valueCounter);
        pPointValue->setOutOfService(valueCounter);
        pPointValue->setCorrectionValue(valueCounter);
        controlPointValues.append(pPointValue);
        valueCounter++;
    }
#endif
    return controlPointValues;
}

bool DdcClient::WritePointValue(WriteControlPointValue *writePointValue)
{
    QList<WriteControlPointValue*> writePointValues;
    writePointValues.append(writePointValue);

    return this->WritePointValues(writePointValues);
}

bool DdcClient::WritePointValues(QList<WriteControlPointValue*> writePointValues)
{
    bool result = false;
#ifndef MOCK_TEST
    POINT_ID	pointid;
    POINT_WRITE_ARGUMENT stPointargument;
    int nResult = 0;
    int nReturnValue = 0;
    bool bStatus = false;

    foreach(WriteControlPointValue *pPointValue, writePointValues)
    {
        pointid = pPointValue->getId().toInt(&bStatus,16);
        if(bStatus == false)
        {
            qDebug() << "Error: In WritePointValue toInt error id : " << pPointValue->getId();
            continue;
        }
        stPointargument.key_type = POINT_KEY_IDENTIFIER;
        stPointargument.key.point_id = pointid;
        stPointargument.property_identifier = POINT_PROPERTY_OUT_OF_SERVICE;
        stPointargument.property_value.pd_type = POINT_DATATYPE_STRING;
        sprintf(stPointargument.property_value.pd.s_val, "%s", "");
        nResult = POINT_write_property(stPointargument);
        if(0 != nResult)
        {
            nReturnValue++;
        }
        stPointargument.property_identifier = POINT_PROPERTY_PRESENT_VALUE;
        sprintf(stPointargument.property_value.pd.s_val, "%s", (const char*)pPointValue->getSetValue().toStdString().c_str());
        stPointargument.priority = 9;
        stPointargument.affect = POINT_AFFECT_USER;
        nResult = POINT_write_property(stPointargument);
        if(0 != nResult)
        {
            nReturnValue++;
        }
    }
    if(nReturnValue > 0)
        result = false;
    else result = true;
#else
    //tempoary test -->
    foreach(WriteControlPointValue *pPointValue, writePointValues)
    {
        qDebug() << "Point ID : " << pPointValue->getId();
        qDebug() << "Point value : " << pPointValue->getSetValue().toStdString().c_str();
    }

#endif
    return result;
}

QList<AlarmInfo*> DdcClient::ReadAlarmHistoryAll()
{
    QList<AlarmInfo*> alarmInfos;
    QSqlDatabase db = QSqlDatabase::database();
    db.setDatabaseName(ALARM_DB_PATH);

    if(db.open())
    {
        qDebug() << "ReadAlarmHistoryAll() Database: connection ok.";
    }
    else
    {
        qDebug() << "Error: ReadAlarmHistoryAll() connection with database failed.";
    }

    QSqlQuery query;
    query.prepare(GET_ALARM_HISTORY_ALL_SQL);
    if(query.exec())
    {
        while(query.next())
        {
            if(query.value(5).toString() == "CPU") // except cpu alarm
                continue;

            AlarmInfo *pAlarmInfo = new AlarmInfo;
            pAlarmInfo->SetAlarmValue(query.value(3).toString());
            pAlarmInfo->SetOccurDateTime(query.value(4).toString());
            pAlarmInfo->setIsRecovered(query.value(6).toInt() == 1);
            pAlarmInfo->SetRecoverDateTime(query.value(7).toString());

            alarmInfos.append(pAlarmInfo);
        }
    }
    else
    {
       qDebug() << "Error: query exec failed.";
    }

    db.close();

    return alarmInfos;
}

QList<AlarmInfo*> DdcClient::ReadAlarmHistoryMonth(int year, int month)
{
    QList<AlarmInfo*> alarmInfos;
    QSqlDatabase db = QSqlDatabase::database();

    db.setDatabaseName(ALARM_DB_PATH);

    if(db.open())
    {
        qDebug() << "ReadAlarmHistoryMonth() Database: connection ok.";

    }
    else
    {
        qDebug() << "Error: ReadAlarmHistoryMonth() connection with database failed.";
    }

    int year1 = (month == 12) ? year : year + 1;
    int month1 = (month == 12) ? month + 1 : 1;


    QString sqlText;
    sqlText.sprintf(GET_ALARM_HISTORY_MONTH_SQL, year, month, year1, month1);

    QSqlQuery query;
    query.prepare(sqlText);
    if(query.exec())
    {
        while(query.next())
        {
            if(query.value(5).toString() == "CPU") // except cpu alarm
                continue;

            AlarmInfo *pAlarmInfo = new AlarmInfo;
            pAlarmInfo->SetAlarmValue(query.value(3).toString());
            pAlarmInfo->SetOccurDateTime(query.value(4).toString());
            pAlarmInfo->setIsRecovered(query.value(6).toInt() == 1);
            pAlarmInfo->SetRecoverDateTime(query.value(7).toString());

            alarmInfos.append(pAlarmInfo);
        }
    }
    else
    {
       qDebug() << "Error: query exec failed.";
    }

    db.close();

    return alarmInfos;
}

QList<AlarmInfo*> DdcClient::ReadAlarmHistoryPeriod(QString startDate, QString endDate)
{
    QList<AlarmInfo*> alarmInfos;
    QSqlDatabase db = QSqlDatabase::database();
    db.setDatabaseName(ALARM_DB_PATH);

    if(db.open())
    {
        qDebug() << "ReadAlarmHistoryPeriod() Database: connection ok.";
    }
    else
    {
       qDebug() << "Error: ReadAlarmHistoryPeriod() connection with database failed.";
    }


    QString sqlText = QString(GET_ALARM_HISTORY_PERIOD_SQL).arg(startDate, endDate);

    QSqlQuery query;
    query.prepare(sqlText);
    if(query.exec())
    {
        while(query.next())
        {
            if(query.value(5).toString() == "CPU") // except cpu alarm
                continue;

            AlarmInfo *pAlarmInfo = new AlarmInfo;
            pAlarmInfo->SetAlarmValue(query.value(3).toString());
            pAlarmInfo->SetOccurDateTime(query.value(4).toString());
            pAlarmInfo->setIsRecovered(query.value(6).toInt() == 1);
            pAlarmInfo->SetRecoverDateTime(query.value(7).toString());

            alarmInfos.append(pAlarmInfo);
        }
    }
    else
    {
       qDebug() << "Error: query exec failed.";
    }

    db.close();

    return alarmInfos;
}

bool DdcClient::ClearAlarmHistory()
{
    bool result = true;
    QSqlDatabase db = QSqlDatabase::database();

    db.setDatabaseName(ALARM_DB_PATH);

    if(db.open())
    {
        qDebug() << "ClearAlarmHistory() Database: connection ok.";

    }
    else
    {
        qDebug() << "Error: ClearAlarmHistory() connection with database failed.";
        return false;
    }

    QString commAlarmValue = "";
    QString mainModuleErrorCode = "";
    QList<QString> pointIds;
    pointIds.append(COMM_ALARM_POINT_ID);

    QList<ControlPointValue*> pointValues = this->ReadPointValues(pointIds);
    if(pointValues.count() > 0)
    {
        if(pointValues.at(0)->getAlarmStatus() > 0)
        {
            commAlarmValue = pointValues.at(0)->getPresentValue();
        }
    }

    pointIds.clear();
    pointIds.append(MAIN_MODULE_ERROR_CODE_POINT_ID);

    pointValues = this->ReadPointValues(pointIds);
    if(pointValues.count() > 0)
    {
        if(pointValues.at(0)->getAlarmStatus() > 0)
        {
            mainModuleErrorCode = pointValues.at(0)->getPresentValue();
        }
    }


    QSqlQuery query;
    query.prepare(DELETE_ALL_ALARM_HISTORY);

    if(query.exec() == false)
    {
        result = false;
        qDebug() << "Error: alarm history delete all query exec failed.";
    }

    QDateTime nowDateTime = QDateTime::currentDateTime();
    QString date = nowDateTime.toString("yyyy-MM-dd hh:mm:ss");
    QString queryText = "";

    if(mainModuleErrorCode != "")
    {
        queryText.sprintf("INSERT INTO INFO(point_id,alarm_status,alarm_type,point_value,time_stamp, point_name,RELEASE_FLAG, TIME_STAMP_RELEASE, NORMAL_VALUE_STRING) VALUES('%s','%d','%d','%s','%s', '%s', '%d', '%s', '%s');",
                          MAIN_MODULE_ERROR_CODE_POINT_ID,
                          1,
                          1,
                          (const char*)mainModuleErrorCode.toStdString().c_str(),
                          (const char*)date.toStdString().c_str(),
                          "mainModule_I001_MainModuleErrorCode",
                          0,
                          "-",
                          "n < 1.000000");
        QSqlQuery query1;
        query1.prepare(queryText);

        if(query1.exec() == false)
        {
            result = false;
            qDebug() << "Error: alarm history insert query exec failed.";
        }
    }

    if(commAlarmValue != "")
    {
        queryText = "";
        queryText.sprintf("INSERT INTO INFO(point_id,alarm_status,alarm_type,point_value,time_stamp, point_name,RELEASE_FLAG, TIME_STAMP_RELEASE, NORMAL_VALUE_STRING) VALUES('%s','%d','%d','%s','%s', '%s', '%d', '%s', '%s');",
                          COMM_ALARM_POINT_ID,
                          1,
                          1,
                          (const char*)commAlarmValue.toStdString().c_str(),
                          (const char*)date.toStdString().c_str(),
                          "COMM ALARM",
                          0,
                          "-",
                          "n < 1.000000");

        QSqlQuery query2;
        query2.prepare(queryText);

        if(query2.exec() == false)
        {
            result = false;
            qDebug() << "Error: alarm history insert query exec failed.";
        }
    }

    db.close();
    return result;
}

int DdcClient::GetActiveAlarms()
{
    int activeAlarm = 0;
    // error code control point check
    QList<QString> pointIds;
    pointIds.append(COMM_ALARM_POINT_ID);

    QList<ControlPointValue*> pointValues = this->ReadPointValues(pointIds);
    if(pointValues.count() > 0)
    {
        if(pointValues.at(0)->getAlarmStatus() > 0)
        {
            // comm alarm
            activeAlarm = 1;
        }
    }

    if(activeAlarm == 0)       // except comm alarm.
    {
        pointIds.clear();
        pointIds.append(MAIN_MODULE_ERROR_CODE_POINT_ID);

        pointValues = this->ReadPointValues(pointIds);
        if(pointValues.count() > 0)
        {
            if(pointValues.at(0)->getAlarmStatus() > 0)
            {
                // device alarm
                activeAlarm = 1;
            }
        }
    }

    return activeAlarm;
}

bool DdcClient::ApplySchedule()
{
    //int nResult = PROCESS_send_signal(PROCESS_get_name_by_list(PROCESS_SCHEDULE_SERVICE), SIGUSR1, TIMEOUT_SYSTEM_MANAGER);
    int nResult=0; //temporary
    qDebug() << "ApplySchedule() nResult : " << nResult;
    if(nResult != 0)
    {

        return false;
    }

    return true;
}

bool DdcClient::AddScheduleImpl(Schedule *schedule, QString startDate, QString endDate)
{
    bool result = true;

    QSqlDatabase db = QSqlDatabase::database();
    db.setDatabaseName(SCHEDULE_DB_PATH);

    if(db.open())
    {
        qDebug() << "AddScheduleImpl() Database: connection ok.";
    }
    else
    {
        qDebug() << "Error: AddScheduleImpl() connection with database failed.";
        return false;
    }


    qDebug() << "Schedule Id : " << schedule->getId();

    QSqlQuery query;
    query.prepare("INSERT OR REPLACE INTO info VALUES (:id, :name, :type, '', :startDate, :endDate, '', :weeklyScheduleCount, 0, :controlPointValueCount, :cronTableCount, :status)");
    query.bindValue(":id", schedule->getId());
    query.bindValue(":name", schedule->getId());
    //query.bindValue(":type", POINT_TYPE_SC);
    query.bindValue(":type", "");
    query.bindValue(":startDate", startDate);
    query.bindValue(":endDate", endDate);
    query.bindValue(":weeklyScheduleCount", schedule->getWeeklySchedules().count());
    query.bindValue(":controlPointValueCount", schedule->getControlPointValues().count());
    query.bindValue(":cronTableCount", schedule->getCrontabCommands().count());
    query.bindValue(":status", 1);

    if(query.exec())
    {
        foreach (const QString &weeklySchedule, schedule->getWeeklySchedules())
        {
            query.prepare("INSERT INTO weekly VALUES(:id, :weeklySchedule)");
            query.bindValue(":id", schedule->getId());
            query.bindValue(":weeklySchedule", weeklySchedule);

            if(query.exec() == false)
             {
                result = false;
                qDebug() << "Error: schedule weeklyschedule add query exec failed.";
            }
        }

        foreach (const QString &crontabCommand, schedule->getCrontabCommands())
        {
            query.prepare("INSERT INTO crontab VALUES(:id, :crontable)");
            query.bindValue(":id", schedule->getId());
            query.bindValue(":crontable", crontabCommand);

            if(query.exec() == false)
            {
                result = false;
                qDebug() << "Error: schedule crontab add query exec failed.";
            }
        }

        foreach (ControlPointValue *controlPointValue, schedule->getControlPointValues())
        {
            query.prepare("INSERT INTO control_value VALUES(:id, :pointId, :setValue)");
            query.bindValue(":id", schedule->getId());
            query.bindValue(":pointId", controlPointValue->getId());
            query.bindValue(":setValue", controlPointValue->getPresentValue());

            if(query.exec() == false)
            {
                result = false;
                qDebug() << "Error: schedule control point value add query exec failed.";
            }
        }
    }
    else
    {
       qDebug() << "Error: schedule add query exec failed.";
       result = false;
    }

    db.close();
    qDebug() << "Info: AddScheduleImpl() db Closed.";

    //if(result == true)
        //result = this->ApplySchedule();


    if(result == true) {
        WriteControlPointValue *pointValue = new WriteControlPointValue();
        pointValue->setId(schedule->getId());
        pointValue->setPriority(9);
        pointValue->setSetValue((schedule->getIsUse() == true) ? "1" : "0");

        result = this->WritePointValue(pointValue);
    }

    qDebug() << "Info: AddScheduleImpl() schedule point controlled.";
    return result;
}

QList<Schedule*> DdcClient::GetSchedules()
{
    QList<Schedule*> schedules;
    QHash<QString, Schedule*> scheduleHash;

    QSqlDatabase db = QSqlDatabase::database();
    db.setDatabaseName(SCHEDULE_DB_PATH);

    if(db.open())
    {
        qDebug() << "GetSchedules() Database: connection ok.";
    }
    else
    {
       qDebug() << "Error: GetSchedules() connection with database failed.";
       return schedules;
    }

    QSqlQuery query;
    query.prepare("SELECT * FROM info");
    if(query.exec())
    {
        while(query.next())
        {
            Schedule *pSchedule = new Schedule;
            pSchedule->setId(query.value(0).toString());
            pSchedule->setName(query.value(1).toString());
            //pSchedule->type = query.value(2).toString();
            //pSchedule->desc = query.value(3).toString();
            //pSchedule->startDate = query.value(4).toString();
            //pSchedule->endDate = query.value(5).toString();
            //pSchedule->calendar = query.value(6).toString();
            //pSchedule->status = query.value(11).toInt();

            QString startDate = query.value(4).toString();
            if(startDate.compare(DEFAULT_START_DATE) == 0)
                pSchedule->setIsSpecial(false);
            else
                pSchedule->setIsSpecial(true);

            schedules.append(pSchedule);
            scheduleHash.insert(pSchedule->getId(), pSchedule);
        }
    }
    else
    {
       qDebug() << "Error: select schedule info query exec failed.";
    }

    query.prepare("SELECT * FROM weekly");
    if(query.exec())
    {
        while(query.next())
        {
            QString id = query.value(0).toString();
            if(scheduleHash.contains(id) == true)
                scheduleHash.value(id)->AppendWeeklySchedule(query.value(1).toString());
        }
    }
    else
    {
       qDebug() << "Error: select schedule weekly schedules info query exec failed.";
    }

    /*query.prepare("SELECT * FROM crontab");
    if(query.exec())
    {
        while(query.next())
        {
            QString id = query.value(0).toString();
            QString crontabCommand = query.value(1).toString();

            if(scheduleHash.contains(id) == true)
                scheduleHash.value(id)->crontabCommands.append(crontabCommand);
        }
    }
    else
    {
       qDebug() << "Error: select schedule crontabs query exec failed.";
    }*/

    query.prepare("SELECT * FROM control_value");
    if(query.exec())
    {
        while(query.next())
        {
            ControlPointValue *pPointValue = new ControlPointValue();
            QString id = query.value(0).toString();
            pPointValue->setId(query.value(1).toString());
            pPointValue->setPresentValue(query.value(2).toString());

            if(scheduleHash.contains(id) == true)
                scheduleHash.value(id)->AppendControlPointValue(pPointValue);
        }
    }
    else
    {
       qDebug() << "Error: select schedule controlValues query exec failed.";
    }

    db.close();
    qDebug() << "Info: getSchedules() db Closed.";

    if(schedules.count() > 0){
        foreach (Schedule* pSchedule, schedules) {
            pSchedule->SeperateWeeklySchedules();
        }
    }

    QList<ControlPointValue*> pControlPointValues = this->ReadPointValues(scheduleHash.keys());
    if(pControlPointValues.count() > 0){
        foreach (ControlPointValue *pPointValue, pControlPointValues) {
            QString pointId = pPointValue->getId();
            if(scheduleHash.contains(pointId) == true) {
                scheduleHash.value(pointId)->setIsUse((pPointValue->getPresentValue() == "1"));
            }

            delete pPointValue;
        }
    }

    return schedules;
}

bool DdcClient::DeleteScheduleImpl(QString scheduleIdText)
{
    qDebug()<< "deleteSchedule:" << scheduleIdText;

    bool result = true;    
    QSqlDatabase db = QSqlDatabase::database();
    db.setDatabaseName(SCHEDULE_DB_PATH);

    if(db.open())
    {
        qDebug() << "DeleteScheduleImpl() Database: connection ok.";

    }
    else
    {
        qDebug() << "Error: DeleteScheduleImpl() connection with database failed.";
        return false;
    }

    QSqlQuery query;
    query.prepare("DELETE FROM info WHERE point_identifier=(:id)");
    query.bindValue(":id", scheduleIdText);
    if(query.exec())
    {
        query.prepare("DELETE FROM weekly WHERE point_identifier=(:id)");
        query.bindValue(":id", scheduleIdText);
        if(query.exec() == false)
        {
            result = false;
            qDebug() << "Error: schedule weekly schedules delete query exec failed.";
        }
        query.prepare("DELETE FROM crontab WHERE point_identifier=(:id)");
        query.bindValue(":id", scheduleIdText);
        if(query.exec() == false)
        {
            result = false;
            qDebug() << "Error: schedule crontabs delete query exec failed.";
        }
        query.prepare("DELETE FROM control_value WHERE point_identifier=(:id)");
        query.bindValue(":id", scheduleIdText);
        if(query.exec() == false)
        {
            result = false;
            qDebug() << "Error: schedule control point values delete query exec failed.";
        }
    }
    else
    {
        //qDebug() << query.lastError().text();
       qDebug() << "Error: schedule delete query exec failed.";
       result = false;
    }

    db.close();

    return result;
}

bool DdcClient::AddSchedule(Schedule *schedule)
{
    bool result = false;

#ifdef MOCK_TEST

    qDebug() << __FUNCTION__ <<"isUse : " << schedule->getIsUse();
    qDebug() << __FUNCTION__ <<"isSpecial : " << schedule->getIsSpecial();
    qDebug() << __FUNCTION__ <<"id : " << schedule->getId();
    qDebug() << __FUNCTION__ <<"timeText : " << schedule->getTimeText();

    for(const QString &day : schedule->getDays())
        qDebug()<<__FUNCTION__ <<" days " <<day;

    for(const QString &weekly : schedule->getWeeklySchedules())
        qDebug()<<__FUNCTION__ <<" weekly " <<weekly;

    QList<ControlPointValue*> pointValues = schedule->getControlPointValues();

    foreach (ControlPointValue *pPointValue, pointValues) {
        qDebug() << "Point ID : " << pPointValue->getId();
        qDebug() << "Point value : " << pPointValue->getPresentValue().toShort();  //getSetValue().toStdString().c_str();

    }
#endif
    schedule->MakeScheduleDBData();
    QString startDate = DEFAULT_START_DATE;
    QString endDate = DEFAULT_END_DATE;

    if(schedule->getDays().count() == 0) {
        QDateTime nowDateTime = QDateTime::currentDateTime();
        startDate = nowDateTime.toString("yyyyMMdd");
        endDate = nowDateTime.addDays(1).toString("yyyyMMdd");
    }

    qDebug() << "startDate: " << startDate << " endDate: " << endDate ;

    result = this->AddScheduleImpl(schedule, startDate, endDate);

    if(result == true)
        result = this->ApplySchedule();

    return result;
}

bool DdcClient::SetSchedule(Schedule *schedule)
{
    bool result = this->DeleteScheduleImpl(schedule->getId());
    if(result == true)
        result = this->AddSchedule(schedule);

    return result;
}

bool DdcClient::DeleteSchedule(QString scheduleIdText)
{
    bool result = this->DeleteScheduleImpl(scheduleIdText);
    if(result == true)
        result = this->ApplySchedule();

    return result;
}

