#include "controlpointvalue.h"

ControlPointValue::ControlPointValue(QObject *parent) : QObject(parent)
{

}

ControlPointValue::~ControlPointValue()
{

}

void ControlPointValue::setAlarmStatus(int alarmStatus)
{
    this->alarmStatus = alarmStatus;
}

void ControlPointValue::setOutOfService(int outOfService)
{
    this->outOfService = outOfService;
}

void ControlPointValue::setCorrectionValue(double correctionValue)
{
    this->correctionValue = correctionValue;
}

void ControlPointValue::setId(QString id)
{
    this->id = id;
}

void ControlPointValue::setPresentValue(QString presentValue)
{
    this->presentValue = presentValue;
}


