#ifndef SCHEDULE_H
#define SCHEDULE_H

#include <QObject>
#include <QList>
#include "controlpointvalue.h"

class Schedule: public QObject
{
    Q_OBJECT

public:
    explicit Schedule(QObject *parent = 0);
    ~Schedule();

private:
    bool isUse;
    bool isSpecial;
    int time; //0712, 1515....
    QString id;
    QString name;
    QString timeText;
    QList<QString> days; // Max 7 {SUN, MON, TUE,WEN, THU, FRI, SAT}
    QList<QString> weeklySchedules;
    QList<ControlPointValue*> controlPointValues;
    QList<QString> crontabCommands;  // 1000

public:
    bool getIsUse() const {
        return isUse;
    }

    void setIsUse(bool isUse);

    bool getIsSpecial() const {
        return isSpecial;
    }

    void setIsSpecial(bool isSpecial);

    int getTime() const {
        return time;
    }
    void setTime(int time);

    QString getId() const {
        return id;
    }
    void setId(QString id);

    QString getName() const {
        return name;
    }
    void setName(QString name);

    QString getTimeText() const {
        return timeText;
    }
    void setTimeText(QString timeText);

    QList<QString> getDays() const {
        return days;
    }
    QList<QString> getWeeklySchedules() const {
        return weeklySchedules;
    }

    QList<ControlPointValue*> getControlPointValues() const {
        return controlPointValues;
    }
    QList<QString> getCrontabCommands() const {
        return crontabCommands;
    }

public:
    void SeperateWeeklySchedules();
    void MakeScheduleDBData();
    void AppendDay(QString day);
    void AppendWeeklySchedule(QString weeklySchedule);
    void AppendControlPointValue(ControlPointValue *pointValue);
    void AppendCrontabCommands(QString crontabCommand);

};

#endif // SCHEDULE_H
