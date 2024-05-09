#ifndef CONTROLPOINTVALUE_H
#define CONTROLPOINTVALUE_H

#include <QObject>
#include <QString>

class ControlPointValue: public QObject
{
    Q_OBJECT

public:
    explicit ControlPointValue(QObject *parent = 0);
    ~ControlPointValue();

private:
    int alarmStatus;
    int outOfService;
    double correctionValue;
    QString id;
    QString presentValue;

public:
    int getAlarmStatus() const {
        return alarmStatus;
    }
    void setAlarmStatus(int alarmStatus);

    int getOutOfService() const {
        return outOfService;
    }
    void setOutOfService(int outOfService);

    double getCorrectionValue() const {
        return correctionValue;
    }
    void setCorrectionValue(double correctionValue);

    QString getId() const {
        return id;
    }

    void setId(QString id);

    QString getPresentValue() const {
        return presentValue;
    }
    void setPresentValue(QString presentValue);
};

#endif // CONTROLPOINTVALUE_H
