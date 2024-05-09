#include "Sample.h"


Sample::Sample(QObject *parent)
    : QObject{parent}
{
    temperature_ = 10;
}

Sample::~Sample()
{

}

void Sample::onTempValChanged(int nTemp)
{
    setTemperature(nTemp);
}

