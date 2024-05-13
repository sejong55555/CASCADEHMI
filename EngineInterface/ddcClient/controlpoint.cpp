#include <QStringList>
#include "controlpoint.h"

MinMax::MinMax()
{

}

MinMax::MinMax(float min, float max)
{
    this->min = min;
    this->max = max;
}

ControlPoint::ControlPoint(QObject *parent) : QObject(parent)
{

}


ControlPoint::~ControlPoint()
{
    this->enumValueMap.clear();
    if(this->minMaxMap.count() > 0)
    {
        foreach (MinMax* pMinMax, this->minMaxMap.values()) {
            if(pMinMax != 0)
                delete pMinMax;
        }
    }
    this->minMaxMap.clear();
}

void ControlPoint::setMin(float min)
{
    this->min = min;
}

void ControlPoint::setMax(float max)
{
    this->max = max;
}

void ControlPoint::setName(QString name)
{
    this->name = name;
}

void ControlPoint::setId(QString id)
{
    this->id = id;
}

void ControlPoint::setType(QString type)
{
    this->type = type;
}

void ControlPoint::setUnitText(QString unitText)
{
    this->unitText = unitText;
}

void ControlPoint::setDesc(QString desc)
{
    this->desc = desc;
}

void ControlPoint::ParseEnumText(QString& enumText)
{
    if(enumText.isEmpty() == false){
        QStringList enumValues = enumText.split(",");
        if(enumValues.size() >= 2){
            foreach(QString str, enumValues){
                QStringList enumValue = str.split(":");
                if(enumValue.size() >= 2)
                {
                    this->enumValueMap.insert(enumValue[0], enumValue[1]);
                }
            }
        }
    }
}

QString ControlPoint::GetEnumValue(QString &key)
{
    QString value = "";
    if(this->enumValueMap.contains(key) == true)
        value = this->enumValueMap.value(key);

    return value;
}

void ControlPoint::ParseMinMaxRangesText(QString &minMaxRangesText)
{
    if(minMaxRangesText.isEmpty() == false) {
        QStringList minMaxRanges = minMaxRangesText.split(",");
        if(minMaxRanges.size() >= 2){
            foreach(QString str, minMaxRanges) {
                QStringList minMaxInfos = str.split(":");
                if(minMaxInfos.size() >= 2){
                    QStringList minMax = minMaxInfos[1].split("~");
                    if(minMax.size() >= 2) {
                        float min = minMax[0].toFloat();
                        float max = minMax[1].toFloat();
                        this->minMaxMap.insert(minMaxInfos[0], new MinMax(min, max));
                    }
                }
            }
        }
    }
}

MinMax* ControlPoint::GetMinMax(QString &model)
{
    MinMax *pMinMax = 0;
    if(this->minMaxMap.contains(model) == true) {
        pMinMax = this->minMaxMap.value(model);
    }

    return pMinMax;
}

float ControlPoint::GetMin(QString &model)
{
    float min = -9999.9;
    if(this->min != -9999.9)
        min = this->min;
    else
    {
        MinMax *pMinMax = this->GetMinMax(model);
        if(pMinMax != 0)
            min = pMinMax->getMin();
    }

    return min;
}

float ControlPoint::GetMax(QString &model)
{
    float max = -9999.9;
    if(this->max != -9999.9)
        max = this->max;
    else
    {
        MinMax *pMinMax = this->GetMinMax(model);
        if(pMinMax != 0)
            max = pMinMax->getMax();
    }

    return max;
}
