#include "schedule.h"
#include <QDateTime>

Schedule::Schedule(QObject *parent) : QObject(parent)
{

}

Schedule::~Schedule()
{
    this->days.clear();
    this->weeklySchedules.clear();
    this->crontabCommands.clear();

    if(this->controlPointValues.count() > 0)
    {
        foreach(ControlPointValue* pPointValue, this->controlPointValues)
        {
            if(pPointValue != 0)
            {
                delete  pPointValue;
                pPointValue = 0;
            }
        }
    }
    this->controlPointValues.clear();
}

void Schedule::setIsUse(bool isUse)
{
    this->isUse = isUse;
}

void Schedule::setIsSpecial(bool isSpecial)
{
    this->isSpecial = isSpecial;
}

void Schedule::setTime(int time)
{
    this->time = time;
}

void Schedule::setId(QString id)
{
    this->id = id;
}

void Schedule::setName(QString name)
{
    this->name = name;
}

void Schedule::setTimeText(QString timeText)
{
    this->timeText = timeText;
}

void Schedule::SeperateWeeklySchedules()
{
    this->days.clear();

    if(this->isSpecial == true) {
        if(this->weeklySchedules.count() > 0) {
            foreach (QString weeklySchedule, this->weeklySchedules) {
                this->time = weeklySchedule.mid(3).toInt(); // "MON0510"
            }
        }
    }
    else {
        if(this->weeklySchedules.count() > 0) {
            foreach (QString weeklySchedule, this->weeklySchedules) {
                this->time = weeklySchedule.mid(3).toInt(); // "MON0510"
                this->days.append(weeklySchedule.left(3));
            }
        }
    }
}

void Schedule::MakeScheduleDBData()
{
    QString days;
    this->weeklySchedules.clear();
    if(this->days.count() > 0){
        foreach (QString day, this->days) {
            QString timeText;
            timeText.sprintf("%04d", this->time);
            this->weeklySchedules.append(day + timeText);
            if(day.compare("SUN") == 0)
                days.append("0,");
            else if(day.compare("MON") == 0)
                days.append("1,");
            else if(day.compare("TUE") == 0)
                days.append("2,");
            else if(day.compare("WED") == 0)
                days.append("3,");
            else if(day.compare("THU") == 0)
                days.append("4,");
            else if(day.compare("FRI") == 0)
                days.append("5,");
            else if(day.compare("SAT") == 0)
                days.append("6,");
        }
        days.chop(1);
    }
    else {
        // find special day
        QDateTime nowDateTime = QDateTime::currentDateTime();
        int now = nowDateTime.toString("hhmm").toInt();

        QString timeText;
        timeText.sprintf("%04d", this->time);

        if(this->time < now) {
            nowDateTime = nowDateTime.addDays(1);  // tomorrow
        }

        this->weeklySchedules.append(QDate::shortDayName(nowDateTime.date().dayOfWeek()).toUpper() + timeText);
        days.sprintf("%d", nowDateTime.date().dayOfWeek());
    }

    this->crontabCommands.clear();
    QString crontab;
    crontab.sprintf("%d %d * * ", this->time%100, this->time/100);
    crontab.append(days);
    crontab.append(" ");
    this->crontabCommands.append(crontab);
}

void Schedule::AppendDay(QString day)
{
    this->days.append(day);
}

void Schedule::AppendWeeklySchedule(QString weeklySchedule)
{
    this->weeklySchedules.append(weeklySchedule);
}


void Schedule::AppendControlPointValue(ControlPointValue *pointValue)
{
    this->controlPointValues.append(pointValue);
}

void Schedule::AppendCrontabCommands(QString crontabCommand)
{
    this->crontabCommands.append(crontabCommand);
}
