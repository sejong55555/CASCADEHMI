#ifndef DEFSTRINGS_H
#define DEFSTRINGS_H

#include "HMIGlobal.h"

class DefStrings : public QObject
{
    Q_OBJECT

    OCUBE_STRING_PROPERTY(SAMPLE_TITLE, tr("Sample", "SAMPLE_TITLE"))
    OCUBE_STRING_PROPERTY(SAMPLE_TEMPERATURE, tr("Temperature", "SAMPLE_TEMPERATURE"))

signals:
    void languageChanged();
};

#endif // DEFSTRINGS_H
