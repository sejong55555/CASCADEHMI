#ifndef SAMPLE_H
#define SAMPLE_H

#include "HMIGlobal.h"

class Sample : public QObject
{
    Q_OBJECT
public:
    explicit Sample(QObject *parent = nullptr);
    virtual ~Sample();

    OCUBE_PROPERTY_WITHOUT_RETURNARG(int,    temperature,        Temperature)

signals:
    void temperatureChanged();

private slots:
    void onTempValChanged(int nTemp);

};

#endif // SAMPLE_H
