#ifndef APPENGINE_H
#define APPENGINE_H

#include <QObject>
#include <QSharedPointer>

class QQmlApplicationEngine;
class AppProperties;

class AppEngine : public QObject
{
    Q_OBJECT
public:
    explicit AppEngine(QQmlApplicationEngine* view, QObject *parent = nullptr);
    virtual ~AppEngine();

private:
    class AppEngineImpl;
    QSharedPointer<AppEngineImpl> m_pImpl;

    void initEngine();

signals:

};

#endif // APPENGINE_H
