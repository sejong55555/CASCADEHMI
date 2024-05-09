#ifndef DDCCLIENT_H
#define DDCCLIENT_H


#include <QObject>
#include <QDebug>

#include "writecontrolpointvalue.h"
#include "alarminfo.h"
#include "schedule.h"

//#define GET_ALARM_HISTORY_ALL_SQL   "SELECT * FROM info"
#define GET_ALARM_HISTORY_ALL_SQL   "SELECT * FROM info ORDER BY TIME_STAMP DESC LIMIT 150" // alarm history temp check by AIN
//#define GET_ALARM_HISTORY_MONTH_SQL   "SELECT * FROM info WHERE TIME_STAMP >= '%d-%d' AND TIME_STAMP <'%d-%d'"
#define GET_ALARM_HISTORY_MONTH_SQL   "SELECT * FROM info WHERE TIME_STAMP >= '%d-%02d' AND TIME_STAMP <'%d-%02d'"
#define GET_ALARM_HISTORY_PERIOD_SQL   "SELECT * FROM info WHERE TIME_STAMP >= '%1' AND TIME_STAMP <= '%2'"
//define DELETE_ALL_ALARM_HISTORY    "DELETE FROM info WHERE release_flag=1"
#define DELETE_ALL_ALARM_HISTORY    "DELETE FROM info"
#define MAIN_MODULE_ERROR_CODE_POINT_ID     "00000124"
#define COMM_ALARM_POINT_ID                 "19000004"

#ifndef MOCK_TEST
#define SCHEDULE_DB_PATH "/mnt/flash/schedule_setting.db"
#define ALARM_DB_PATH    "/mnt/flash/alarm.db"
#endif

class DdcClient : public QObject
{

public:
    explicit DdcClient(QObject *parent = 0);

private :
    bool SetDateTime(QString date, QString time);
    bool AddScheduleImpl(Schedule *schedule, QString startDate, QString endDate);
    bool DeleteScheduleImpl(QString scheduleIdText);
    bool ApplySchedule();
#ifdef MOCK_TEST
    QString SCHEDULE_DB_PATH;
    QString ALARM_DB_PATH;
#endif
public:
    bool SetDate(QString &date);
    bool SetTime(QString &time);
    QList<ControlPointValue*> ReadPointValues(QList<QString> pointIds);
    bool WritePointValue(WriteControlPointValue *writePointValue);
    bool WritePointValues(QList<WriteControlPointValue*> writePointValues);

    QList<AlarmInfo*> ReadAlarmHistoryAll();
    QList<AlarmInfo*> ReadAlarmHistoryMonth(int year, int month);
    QList<AlarmInfo*> ReadAlarmHistoryPeriod(QString startDate, QString endDate);
    bool ClearAlarmHistory();
    int GetActiveAlarms();

    QList<Schedule*> GetSchedules();
    bool AddSchedule(Schedule *schedule);
    bool SetSchedule(Schedule *schedule);
    bool DeleteSchedule(QString scheduleIdText);

};

#endif // DDCCLIENT_H
