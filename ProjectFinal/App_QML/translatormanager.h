#ifndef TRANSLATORMANAGER_H
#define TRANSLATORMANAGER_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QWindow>
#include <QDebug>

class TranslatorManager : public QObject
{
    Q_OBJECT

public:
    explicit TranslatorManager(QGuiApplication *app, QObject *parent = nullptr)
        : QObject(parent), m_app(app)
    {
        m_translator = new QTranslator(this);
    }

    Q_INVOKABLE void switchLanguage(const QString& language)
    {
        // Remove old translator
        m_app->removeTranslator(m_translator);

        // Load new translation file
        QString translationFile = QString(":app_%1.qm").arg(language);

        qDebug() << "Loading translation:" << translationFile;

        if (m_translator->load(translationFile)) {
            m_app->installTranslator(m_translator);
            qDebug() << "Successfully switched to:" << language;

            // QUAN TRỌNG: Force retranslate tất cả QML engines
            retranslateAllQmlEngines();

            emit languageChanged();
        } else {
            qDebug() << "Failed to load translation:" << translationFile;
        }
    }

signals:
    void languageChanged();

private:
    void retranslateAllQmlEngines()
    {
        for (QWindow* window : m_app->allWindows()) {
            if (QQmlEngine* engine = qmlEngine(window)) {
                engine->retranslate();
                qDebug() << "Retranslated engine for window:" << window;
            }
        }
        qDebug() << "All QML engines retranslated";
    }

    QTranslator *m_translator;
    QGuiApplication *m_app;
};

#endif // TRANSLATORMANAGER_H
