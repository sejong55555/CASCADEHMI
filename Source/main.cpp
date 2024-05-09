#include <QGuiApplication>
//temp jikim
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include <QIcon>

#include "AppEngine.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    //    QGuiApplication app(argc, argv);
    //temp jikim
    QApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "CascadeHMI_" + QLocale(locale).name() + ".qm";
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
    engine.addImportPath(":/styles");
    qputenv("QT_VIRTUALKEYBOARD_STYLE", QByteArray("test"));
    engine.rootContext()->setContextProperty("applicationdirpath", QGuiApplication::applicationDirPath());
    AppEngine appEngine(&engine, &app);

    //Set titlebar icon
    QIcon::setThemeName(QStringLiteral("CasecadeHMI"));

#if 0  //Not use.
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
#endif
    return app.exec();
}
