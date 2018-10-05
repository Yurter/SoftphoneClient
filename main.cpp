#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "QmlSpClient.h"
#include "Logger.h"

int main(int argc, char *argv[])
{
    Logger::getInstance().enableDebugOutput(true);
    Logger::getInstance().enableConsoleOutput(true);
    INFO_LOG("Запуск приложения.");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<QmlSpUser>("QmlSpUser", 1, 0, "QmlSpUser");
    qmlRegisterType<QmlSpClient>("QmlSpClient", 1, 0, "QmlSpClient");
    qmlRegisterType<QmlSpMessage>("QmlSpMessage", 1, 0, "QmlSpMessage");
    qmlRegisterType<QmlSpConversation>("QmlSpConversation", 1, 0, "QmlSpConversation");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/loginWindow.qml")));
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());

    if (engine.rootObjects().isEmpty()) {
        ERROR_LOG("List of all the root objects instantiated by the QQmlApplicationEngine is empty.");
        ERROR_LOG("Аварийное завершение работы.");
        return -1;
    }

    INFO_LOG("Приложение запущено.");
    return app.exec();
}
