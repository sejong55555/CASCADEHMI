#ifndef CONTROLPOINT_H
#define CONTROLPOINT_H

#include <QObject>
#include <QString>
#include <QMap>

class MinMax
{
public:
    MinMax();
    MinMax(float min, float max);

private:
    float min;
    float max;

public:
    float getMin() const {
        return min;
    }
    float getMax() const {
        return max;
    }
};

class ControlPoint:public QObject
{
     Q_OBJECT

public:
    enum Type{
            DI,
            DO,
            DV,
            AI,
            AO,
            AV,
            MI,
            MO,
            MV
        };

        enum OutOfService {
            OUT_NORMAL = 0,
            OUT_OF_SERVICE = 1
        };

        Q_ENUMS(Type)
        Q_ENUMS(OutOfService)
public:
    explicit ControlPoint(QObject *parent = 0);
    ~ControlPoint();

private:
    float min;
    float max;
    QString name;
    QString id;
    QString type;
    QString unitText;
    QString desc;
    QMap<QString, QString> enumValueMap;
    QMap<QString, MinMax*> minMaxMap;

public:
    float getMin() const {
        return min;
    }
    void setMin(float min);

    float getMax() const {
        return max;
    }
    void setMax(float max);

    QString getName() const {
        return name;
    }
    void setName(QString name);

    QString getId() const {
        return id;
    }
    void setId(QString id);

    QString getType() const {
        return type;
    }
    void setType(QString type);

    QString getUnitText() const {
        return unitText;
    }
    void setUnitText(QString unitText);

    QString getDesc() const {
        return desc;
    }
    void setDesc(QString desc);


public:
    void ParseEnumText(QString &enumText);
    QString GetEnumValue(QString &key);
    void ParseMinMaxRangesText(QString &enumText);
    MinMax* GetMinMax(QString &model);
    float GetMin(QString &model);
    float GetMax(QString &model);
};

#endif // CONTROLPOINT_H
