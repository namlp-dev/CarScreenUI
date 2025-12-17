#ifndef VEHICLEDATA_H
#define VEHICLEDATA_H

#include <QObject>

class VehicleData : public QObject
{
    Q_OBJECT
    // Khai báo Property để QML có thể đọc/ghi
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int battery READ battery WRITE setBattery NOTIFY batteryChanged)
    Q_PROPERTY(QString gear READ gear WRITE setGear NOTIFY gearChanged)
    Q_PROPERTY(bool leftSignal READ leftSignal WRITE setLeftSignal NOTIFY leftSignalChanged)
    Q_PROPERTY(bool rightSignal READ rightSignal WRITE setRightSignal NOTIFY rightSignalChanged)

    // Áp suất lốp
    Q_PROPERTY(double tireFL READ tireFL WRITE setTireFL NOTIFY tireFLChanged)
    Q_PROPERTY(double tireFR READ tireFR WRITE setTireFR NOTIFY tireFRChanged)
    Q_PROPERTY(double tireRL READ tireRL WRITE setTireRL NOTIFY tireRLChanged)
    Q_PROPERTY(double tireRR READ tireRR WRITE setTireRR NOTIFY tireRRChanged)

    // --- [MỚI] CLIMATE PROPERTIES (LƯU TRẠNG THÁI ĐIỀU HÒA) ---
    Q_PROPERTY(bool isAC READ isAC WRITE setIsAC NOTIFY isACChanged)
    Q_PROPERTY(bool isAuto READ isAuto WRITE setIsAuto NOTIFY isAutoChanged)
    Q_PROPERTY(bool isSync READ isSync WRITE setIsSync NOTIFY isSyncChanged)
    Q_PROPERTY(int recircMode READ recircMode WRITE setRecircMode NOTIFY recircModeChanged)
    Q_PROPERTY(int fanSpeed READ fanSpeed WRITE setFanSpeed NOTIFY fanSpeedChanged)

    Q_PROPERTY(double tempLeft READ tempLeft WRITE setTempLeft NOTIFY tempLeftChanged)
    Q_PROPERTY(double tempRight READ tempRight WRITE setTempRight NOTIFY tempRightChanged)

    // Ghế (Heat/Cool)
    Q_PROPERTY(bool heatLeft READ heatLeft WRITE setHeatLeft NOTIFY heatLeftChanged)
    Q_PROPERTY(bool coolLeft READ coolLeft WRITE setCoolLeft NOTIFY coolLeftChanged)
    Q_PROPERTY(bool heatRight READ heatRight WRITE setHeatRight NOTIFY heatRightChanged)
    Q_PROPERTY(bool coolRight READ coolRight WRITE setCoolRight NOTIFY coolRightChanged)

public:
    explicit VehicleData(QObject *parent = nullptr);
    static VehicleData *instance(); // Singleton Instance

    int speed() const;
    void setSpeed(int newSpeed);

    int battery() const;
    void setBattery(int newBattery);

    QString gear() const;
    void setGear(const QString &newGear);

    bool leftSignal() const;
    void setLeftSignal(bool newLeftSignal);

    bool rightSignal() const;
    void setRightSignal(bool newRightSignal);

    // Getter/Setter cho lốp
    double tireFL() const;
    void setTireFL(double v);
    double tireFR() const;
    void setTireFR(double v);
    double tireRL() const;
    void setTireRL(double v);
    double tireRR() const;
    void setTireRR(double v);

    // --- [MỚI] Getter/Setter Climate ---
    bool isAC() const;
    void setIsAC(bool v);
    bool isAuto() const;
    void setIsAuto(bool v);
    bool isSync() const;
    void setIsSync(bool v);
    int recircMode() const;
    void setRecircMode(int v);
    int fanSpeed() const;
    void setFanSpeed(int v);

    double tempLeft() const;
    void setTempLeft(double v);
    double tempRight() const;
    void setTempRight(double v);

    bool heatLeft() const;
    void setHeatLeft(bool v);
    bool coolLeft() const;
    void setCoolLeft(bool v);
    bool heatRight() const;
    void setHeatRight(bool v);
    bool coolRight() const;
    void setCoolRight(bool v);

signals:
    void speedChanged();
    void batteryChanged();
    void gearChanged();
    void leftSignalChanged();
    void rightSignalChanged();
    void tireFLChanged();
    void tireFRChanged();
    void tireRLChanged();
    void tireRRChanged();

    // --- [MỚI] Signal Climate ---
    void isACChanged();
    void isAutoChanged();
    void isSyncChanged();
    void recircModeChanged();
    void fanSpeedChanged();
    void tempLeftChanged();
    void tempRightChanged();
    void heatLeftChanged();
    void coolLeftChanged();
    void heatRightChanged();
    void coolRightChanged();

private:
    int m_speed;
    int m_battery;
    QString m_gear;
    bool m_leftSignal;
    bool m_rightSignal;
    double m_tireFL;
    double m_tireFR;
    double m_tireRL;
    double m_tireRR;

    // --- [MỚI] Biến thành viên Climate ---
    bool m_isAC;
    bool m_isAuto;
    bool m_isSync;
    int m_recircMode;
    int m_fanSpeed;
    double m_tempLeft;
    double m_tempRight;
    bool m_heatLeft;
    bool m_coolLeft;
    bool m_heatRight;
    bool m_coolRight;
};

#endif // VEHICLEDATA_H
