#include "writecontrolpointvalue.h"

//WriteControlPointValue::WriteControlPointValue() {}
WriteControlPointValue::WriteControlPointValue(QObject *parent) : QObject(parent)
{

}

WriteControlPointValue::~WriteControlPointValue()
{

}

void WriteControlPointValue::setPriority(int priority)
{
    this->priority = priority;
}


void WriteControlPointValue::setId(QString id)
{
    this->id = id;
}

void WriteControlPointValue::setSetValue(QString setValue)
{
    this->setValue = setValue;
}
