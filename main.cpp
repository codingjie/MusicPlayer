#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QTextCodec>

#include "music/lyricmodel.h"
#include "music/playlistmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QDir::setCurrent(QCoreApplication::applicationDirPath());
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

    qmlRegisterType<lyricModel>("dataModel", 1, 0, "LyricModel");
    qmlRegisterType<playListModel>("dataModel", 1, 0, "PlayListModel");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
