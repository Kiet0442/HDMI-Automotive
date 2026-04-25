// espdata.h
#ifndef ESPDATA_H
#define ESPDATA_H

#include <QObject>
#include <QVector>

class ESPData : public QObject {
    Q_OBJECT
    Q_PROPERTY(float temp READ getTemp WRITE setTemp NOTIFY tempChanged)
    Q_PROPERTY(float humid READ getHumid WRITE setHumid NOTIFY humidChanged)
    Q_PROPERTY(float pot32 READ getPot32 WRITE setPot32 NOTIFY pot32Changed)
    Q_PROPERTY(float pot33 READ getPot33 WRITE setPot33 NOTIFY pot33Changed)
    Q_PROPERTY(float pot34 READ getPot34 WRITE setPot34 NOTIFY pot34Changed)
    Q_PROPERTY(QVector<int> buttons READ getButtons WRITE setButtons NOTIFY buttonsChanged)

public:
    explicit ESPData(QObject *parent = nullptr) : QObject(parent) {}

    float getTemp() const { return temp; }
    void setTemp(float value) {
        if (temp != value) {
            temp = value; emit tempChanged();
        }
    }

    float getHumid() const { return humid; }
    void setHumid(float value) {
        if (humid != value) {
            humid = value; emit humidChanged();
        }
    }

    float getPot32() const { return pot32; }
    void setPot32(float value) {
        if (pot32 != value) {
            pot32 = value; emit pot32Changed();
        }
    }

    float getPot33() const { return pot33; }
    void setPot33(float value) {
        if (pot33 != value) {
            pot33 = value; emit pot33Changed();
        }
    }

    float getPot34() const { return pot34; }
    void setPot34(float value) {
        if (pot34 != value) {
            pot34 = value; emit pot34Changed();
        }
    }

    QVector<int> getButtons() const { return buttons; }
    void setButtons(const QVector<int> &value) {
        if (buttons != value) {
            buttons = value; emit buttonsChanged();
        }
    }

signals:
    void tempChanged();
    void humidChanged();
    void pot32Changed();
    void pot33Changed();
    void pot34Changed();
    void buttonsChanged();

private:
    float temp = 0;
    float humid = 0;
    float pot32 = 0;
    float pot33 = 0;
    float pot34 = 0;
    QVector<int> buttons;
};

#endif // ESPDATA_H

