#include "controlpointmanager.h"
#include "controlpoint.h"
#include <QFile>
#include <QDebug>
#include <QXmlStreamReader>
#include <QXmlStreamAttributes>



ControlPointManager::ControlPointManager(QObject *parent) : QObject(parent)
{

}

ControlPointManager::~ControlPointManager()
{
    if(this->controlPointsMap.count() > 0)
    {
        foreach (QList<ControlPoint*> *pControlPoints, this->controlPointsMap.values()) {
            foreach(ControlPoint* pPoint, *pControlPoints) {
                if(pPoint != 0)
                {
                    delete pPoint;
                    pPoint = 0;
                }
            }
            pControlPoints->clear();
            delete pControlPoints;
        }
        this->controlPointsMap.clear();
    }
}

bool ControlPointManager::LoadControlPoints(const QString& fileName)
{
    QString filePath;
    if(fileName==0|| !QFile::exists(fileName))
        filePath = "/mnt/flash/control_point_map.xml";
    else
        filePath= fileName;

    QFile file(filePath);

    if (!file.open(QFile::ReadOnly | QFile::Text))
    {
        qWarning() << "ControlPointManager::loadControlPoints"
                   << " failed to open file:" << fileName;
        return false;
    }

    qDeleteAll(this->controlPointsMap);
    this->controlPointsMap.clear();

    QList<ControlPoint*> *pControlPoints = 0;
    QXmlStreamReader reader;
    reader.setDevice(&file);
    reader.readNext();
    while (!reader.atEnd())
    {
        if (reader.isStartElement())
        {
            QXmlStreamAttributes atts = reader.attributes();
            if (reader.name() == "controlPoint")
            {
                QString category = atts.value("category").toString();
                if(this->controlPointsMap.contains(category) == false) {
                    pControlPoints = new QList<ControlPoint*>();
                    this->controlPointsMap.insert(category, pControlPoints);
                } else {
                    pControlPoints = this->controlPointsMap.value(category);
                }

                QString idText = atts.value("id").toString();
                QString type = atts.value("type").toString();
                QString name = atts.value("name").toString();
                QString desc = atts.value("desc").toString();
                QString min = atts.value("min").toString();
                QString max = atts.value("max").toString();
                QString enumText = atts.value("enumText").toString();
                QString minMaxRanges = atts.value("minMaxRanges").toString();
                QString unitText = atts.value("unitText").toString();

                ControlPoint* pControlPoint = new ControlPoint();
                pControlPoint->setId(idText);
                pControlPoint->setType(type);
                pControlPoint->setName(name);
                if(min.isEmpty() == false)
                    pControlPoint->setMin(min.toFloat());
                else
                    pControlPoint->setMin(-9999.9);
                if(max.isEmpty() == false)
                    pControlPoint->setMax(max.toFloat());
                else
                    pControlPoint->setMax(-9999.9);

                pControlPoint->ParseEnumText(enumText);
                pControlPoint->ParseMinMaxRangesText(minMaxRanges);
                pControlPoint->setUnitText(unitText);
                pControlPoint->setDesc(desc);

                //pControlPoints== null??
                pControlPoints->append(pControlPoint);
            }
        }
        else if (reader.isEndElement())
        {

        }

        reader.readNext();
    }

    return true;
}

QList<ControlPoint*>* ControlPointManager::GetControlPoints(const QString& category)
{
    QList<ControlPoint*> *pControlPoints = 0;
    if(this->controlPointsMap.contains(category) == true)
    {
        pControlPoints = this->controlPointsMap.value(category);
    }

    return pControlPoints;
}

QList<QString> ControlPointManager::GetControlPointIds(const QString& category)
{
    QList<QString> controlPointIds;
    QList<ControlPoint*> *pControlPoints = 0;
    if(this->controlPointsMap.contains(category) == true)
    {
        pControlPoints = this->controlPointsMap.value(category);
        foreach (ControlPoint* pControlPoint, *pControlPoints) {
            controlPointIds.append(pControlPoint->getId());
        }
    }

    return controlPointIds;
}
