#include "alarminfo.h"


AlarmInfo::AlarmInfo(QObject *parent) : QObject(parent)
{

}

AlarmInfo::~AlarmInfo()
{

}

void AlarmInfo::setIsRecovered(bool isRecovered)
{
    this->isRecovered = isRecovered;
}

void AlarmInfo::SetAlarmValue(QString alarmValue)
{
    if(alarmValue.isEmpty() == false)
    {
        double alarmV = alarmValue.toDouble();
        if (alarmV == 1)
            this->alarmCode = "COMM";
        else
            this->alarmCode = QString::number((int)alarmV);
    }
    else
        this->alarmCode = "";
}

void AlarmInfo::SetOccurDateTime(QString dateTime)
{
    this->occurDate = dateTime.left(10);
    this->occurTime = dateTime.mid(11, 8);
}

void AlarmInfo::SetRecoverDateTime(QString dateTime)
{
    this->isRecovered = false;
    if(dateTime.length() > 1 ){
        this->isRecovered = true;
        this->recoverDate = dateTime.left(10);
        this->recoverTime = dateTime.mid(11, 8);
    }
}

