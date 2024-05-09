#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QGuiApplication>

#include "AppEngine.h"
#include "AppModel.h"
#include "Enums.h"
#include "HMIGlobal.h"


class AppEngine::AppEngineImpl
{
public:
    QQmlApplicationEngine *m_pView;

    int m_nPlatform;
};

AppEngine::AppEngine(QQmlApplicationEngine *view, QObject *parent)
    : QObject(parent),
      m_pImpl(QSharedPointer<AppEngineImpl>(new AppEngineImpl))
{
    qDebug() << __FUNCTION__;
    qmlRegisterUncreatableType<ENUMS>("EnumHMI", 1, 0, "EnumHMI", "");

    m_pImpl->m_pView = view;

    initEngine();

    m_pImpl->m_pView->rootContext()->setContextProperty("appModel", AppModel::instance());
    m_pImpl->m_pView->rootContext()->setContextProperty("idGlobal", (QObject*)AppModel::instance()->getGlobalDefine());
    m_pImpl->m_pView->rootContext()->setContextProperty("idString", (QObject*)AppModel::instance()->getStringDefine());
//    m_pImpl->m_pView->rootContext()->setContextProperty("idViewMode", AppModel::instance()->viewMode());
//    m_pImpl->m_pView->rootContext()->setContextProperty("idLogMode", AppModel::instance()->logMode());
//    m_pImpl->m_pView->rootContext()->setContextProperty("serial", m_pImpl->serialMgr_);
//    m_pImpl->m_pView->rootContext()->setContextProperty("APP_RESOURCE_IMAGE_DIR", QString("%1%2").arg(APP_RESOURCE_PREFIX).arg(APP_RESOURCE_IMAGE_DIR));
//    m_pImpl->m_pView->rootContext()->setContextProperty("APP_FREQUENCE", APP_FREQUENCE);
//    m_pImpl->m_pView->rootContext()->setContextProperty("appConfig", AppConfig::instance());
    m_pImpl->m_pView->rootContext()->setContextProperty("APP_PLATFORM", m_pImpl->m_nPlatform);
//    m_pImpl->m_pView->rootContext()->setContextProperty("bluetooth", m_pImpl->bleinterface_);

    if(m_pImpl->m_nPlatform == ENUMS::E_OS_LINUX) {
//        if(!AppConfig::instance()->loadConfig())
//            AppConfig::instance()->makeConfig();

//        connect(AppModel::instance(), &AppModel::viewModeChanged, this, &AppEngine::onViewModeChanged);

//        if(((QGuiApplication*)parent)->arguments().length() > 1) {
//            DEBUG(((QGuiApplication*)parent)->arguments().at(1));
//            if(((QGuiApplication*)parent)->arguments().at(1) == "-conf") {
//                AppModel::instance()->setViewMode(ENUMS::E_VIEW_CONF);
//            } else if(((QGuiApplication*)parent)->arguments().at(1) == "-pfd"){
//                AppModel::instance()->setViewMode(ENUMS::E_VIEW_PFD);
//            } else if(((QGuiApplication*)parent)->arguments().at(1) == "-hsi"){
//                AppModel::instance()->setViewMode(ENUMS::E_VIEW_HSI);
//            }
//        } else {
//            DEBUG(QStringLiteral("config dispPage : %1").arg(AppConfig::instance()->dispPage()));
//            if(AppConfig::instance()->dispPage() == 0)
//                AppModel::instance()->setViewMode(ENUMS::E_VIEW_PFD);
//            else
//                AppModel::instance()->setViewMode(ENUMS::E_VIEW_HSI);b
//        }

        DEBUG(QStringLiteral("%1%2").arg(APP_DIR).arg(APP_MAIN_QML));
        m_pImpl->m_pView->load(QUrl(QStringLiteral("qrc:/Qml/main.qml")));
    } else {
//        AppModel::instance()->setViewMode(ENUMS::E_VIEW_IPAD);

        DEBUG(QStringLiteral("%1%2").arg(APP_RESOURCE_PREFIX).arg(APP_MAIN_QML));
        m_pImpl->m_pView->load(QUrl(QStringLiteral("qrc:/Qml/main.qml")));
    }

}

AppEngine::~AppEngine()
{

}

void AppEngine::initEngine()
{
#ifdef Q_OS_MACOS
    m_pImpl->m_nPlatform = ENUMS::E_OS_MAC;
    m_pImpl->serialMgr_ = new SerialManager();
    m_pImpl->bleinterface_ = new BLEInterface(m_pImpl->serialMgr_->getDataPFD(), m_pImpl->serialMgr_->getDataConfig(), this);
    connect(m_pImpl->bleinterface_, &BLEInterface::dataReceived, this, &AppEngine::onReceivedData);

#elif Q_OS_IOS
    m_pImpl->m_nPlatform = ENUMS::E_OS_IPHONE;
    m_pImpl->serialMgr_ = new SerialManager();
    m_pImpl->bleinterface_ = new BLEInterface(m_pImpl->serialMgr_->getDataPFD(), m_pImpl->serialMgr_->getDataConfig(), this);
    connect(m_pImpl->bleinterface_, &BLEInterface::dataReceived, this, &AppEngine::onReceivedData);
#else
// org_code
    m_pImpl->m_nPlatform = ENUMS::E_OS_LINUX;

//// test_code---------------------------
//    m_pImpl->serialMgr_ = new SerialManager();
//    m_pImpl->m_nPlatform = ENUMS::E_OS_MAC;  //<<<<<<----------test code for ipad
//    m_pImpl->bleinterface_ = new BLEInterface(m_pImpl->serialMgr_->getDataPFD(), m_pImpl->serialMgr_->getDataConfig(), this);

#endif
    DEBUG(QStringLiteral("Platform : %1").arg(m_pImpl->m_nPlatform));
//    qDebug() << "Platform : " << m_pImpl->m_nPlatform;
}


