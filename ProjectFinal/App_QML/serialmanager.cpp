#include "serialmanager.h"
#include <QDebug>

SerialManager::SerialManager(QObject *parent) : QObject(parent)
{
    connect(&serial, &QSerialPort::readyRead, this, &SerialManager::readData);

    QString portName = "/dev/ttyUSB0";
    int baudRate = 115200;
    openPort(portName, baudRate);

}

void SerialManager::openPort(const QString &portName, int baudRate)
{
    serial.setPortName(portName);
    serial.setBaudRate(baudRate);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    serial.setFlowControl(QSerialPort::NoFlowControl);

    if (serial.open(QIODevice::ReadWrite))
        qDebug() << "Opened port:" << portName;

    else
        qDebug() << "Failed to open port:" << serial.errorString();
}

void SerialManager::sendData(const QString &data)
{
    if (serial.isOpen())
        serial.write(data.toUtf8());
}

void SerialManager::readData()
{
    static QByteArray buffer;
    buffer += serial.readAll();

    int index;
    while ((index = buffer.indexOf('\n')) != -1) {
        QByteArray line = buffer.left(index).trimmed();
        buffer.remove(0, index + 1);

        QString strLine = QString::fromUtf8(line);
        emit receivedData(strLine);
        qDebug() << "Data:" << strLine;

        // ===== XỬ LÝ THEME VÀ LANGUAGE TỪ ESP32 =====
        if (strLine.startsWith("theme:")) {
            QString theme = strLine.mid(6).trimmed();
            qDebug() << "Theme received from ESP32:" << theme;
            emit themeReceived(theme);
            continue;
           }

        if (strLine.startsWith("lang:")) {
            QString lang = strLine.mid(5).trimmed();
            qDebug() << "Language received from ESP32:" << lang;
            emit languageReceived(lang);
            continue;
           }

        QStringList parts = strLine.split('|');
        if (parts.size() >= 13) { // 5 biến + 8 nút
//            ESPData* data = new ESPData();
            m_data.setTemp(parts[0].toFloat());
            m_data.setHumid(parts[1].toFloat());
            m_data.setPot32(parts[2].toFloat());
            m_data.setPot33(parts[3].toFloat());
            m_data.setPot34(parts[4].toFloat());

            QVector<int> btns;
            for (int i = 5; i < parts.size(); i++)
                btns.append(parts[i].toInt());
            m_data.setButtons(btns);

            emit espDataUpdated();
        }
    }
}
void SerialManager::sendSongNumber(int num)
{
    if (serial.isOpen()) {
        QString msg = QString::number(num) + "\n";
        serial.write(msg.toUtf8());
        qDebug() << "Send to ESP32:" << msg;
    }
}
void SerialManager::sendCommand(const QString &cmd) {
    serial.write(cmd.toUtf8() + "\n");
    qDebug() << "Send to ESP32:" << cmd.toUtf8() + "\n";
}

void SerialManager::requestSettings()
{
    qDebug() << "Requesting settings from ESP32...";
    sendCommand("get_settings");
}
