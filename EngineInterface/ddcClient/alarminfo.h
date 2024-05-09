#ifndef ALARMINFO_H
#define ALARMINFO_H

#include <QObject>

class AlarmInfo:public QObject
{
    Q_OBJECT

public:
    explicit AlarmInfo(QObject *parent = 0);
    ~AlarmInfo();

public:
    QString occurDate;
    QString occurTime;
    QString recoverDate;
    QString recoverTime;
    QString alarmCode;
    bool isRecovered;

public:
    bool getIsRecovered() const {
        return isRecovered;
    }
    void setIsRecovered(bool isRecovered);
    QString getAlarmCode() const {
        return alarmCode;
    }
    void setAlarmCode(QString &alarmCode);
    QString getOccurDate() const {
        return occurDate;
    }
    void setOccurDate(QString &occurDate);
    QString getOccurTime() const {
        return occurTime;
    }
    void setOccurTime(QString &occurTime);
    QString getRecoverDate() const {
        return recoverDate;
    }
    void setRecoverate(QString &recoverDate);
    QString getRecoverTime() const {
        return recoverTime;
    }
    void setRecoverTime(QString &recoverTime);



public:
    void SetAlarmValue(QString alarmValue);
    void SetOccurDateTime(QString dateTime);
    void SetRecoverDateTime(QString dateTime);
};

#endif // ALARMINFO_H
