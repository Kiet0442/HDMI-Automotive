#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>
#include <QSerialPort>
#include "espdata.h"

class SerialManager : public QObject
{
    Q_OBJECT
public:
    explicit SerialManager(QObject *parent = nullptr);

    Q_INVOKABLE void sendData(const QString &data);
    Q_INVOKABLE void sendSongNumber(int num);
    Q_INVOKABLE void sendCommand(const QString &cmd);
    Q_INVOKABLE void requestSettings();

    ESPData* espData() { return &m_data; }


signals:
    void receivedData(const QString &data);
    void espDataUpdated();
    void themeReceived(const QString &theme);
    void languageReceived(const QString &lang);

private slots:
    void readData();

private:
    ESPData m_data;
    void openPort(const QString &portName, int baudRate);

    QSerialPort serial;
};

#endif // SERIALMANAGER_H
