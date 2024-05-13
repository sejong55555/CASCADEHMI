#ifndef CONTROLPOINTMANAGER_H
#define CONTROLPOINTMANAGER_H

#include <QObject>
#include <QMap>


class ControlPoint;

class ControlPointManager : public QObject
{
    Q_OBJECT
public:
    explicit ControlPointManager(QObject *parent = 0);
    ~ControlPointManager();



signals:

public slots:


private:
   QMap<QString, QList<ControlPoint*>*> controlPointsMap;


public:
   Q_INVOKABLE bool LoadControlPoints(const QString& fileName = 0);
   Q_INVOKABLE QList<ControlPoint*>* GetControlPoints(const QString& category);
   Q_INVOKABLE QList<QString> GetControlPointIds(const QString& category);

};


#endif // CONTROLPOINTMANAGER_H
