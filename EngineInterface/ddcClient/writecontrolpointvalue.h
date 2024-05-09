#ifndef WRITECONTROLPOINTVALUE_H
#define WRITECONTROLPOINTVALUE_H

#include <QObject>
#include <QString>

class WriteControlPointValue: public QObject
{
    Q_OBJECT

public:
    explicit WriteControlPointValue(QObject *parent = 0);
    ~WriteControlPointValue();

private:
    int priority;
    QString id;
    QString setValue;

public:
    int getPriority() const {
        return priority;
    }
    void setPriority(int priority);
    QString getId() const {
        return id;
    }
    void setId(QString id);
    QString getSetValue() const {
        return setValue;
    }
    void setSetValue(QString setValue);
};

#endif // WRITECONTROLPOINTVALUE_H
