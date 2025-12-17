#include "VehicleData.h"

// Khởi tạo Singleton
static VehicleData *s_instance = nullptr;

VehicleData *VehicleData::instance()
{
    if (!s_instance)
        s_instance = new VehicleData();
    return s_instance;
}

VehicleData::VehicleData(QObject *parent)
    : QObject(parent)
{
    // Giá trị khởi tạo mặc định
    m_speed = 0;
    m_battery = 85;
    m_gear = "P";
    m_leftSignal = false;
    m_rightSignal = false;
    m_tireFL = 32.0;
    m_tireFR = 32.0;
    m_tireRL = 32.0;
    m_tireRR = 32.0;
    // --- [MỚI] GIÁ TRỊ MẶC ĐỊNH CLIMATE ---
    m_isAC = true;
    m_isAuto = true;
    m_isSync = false;
    m_recircMode = 1; // Auto
    m_fanSpeed = 3;
    m_tempLeft = 20.0;
    m_tempRight = 22.0;
    m_heatLeft = true;
    m_coolLeft = false;
    m_heatRight = true;
    m_coolRight = false;
}

// --- IMPLEMENT GETTER/SETTER ---
// (Các hàm này chỉ đơn giản là gán giá trị và emit signal)

int VehicleData::speed() const
{
    return m_speed;
}
void VehicleData::setSpeed(int newSpeed)
{
    if (m_speed == newSpeed)
        return;
    m_speed = newSpeed;
    emit speedChanged();
}

int VehicleData::battery() const
{
    return m_battery;
}
void VehicleData::setBattery(int newBattery)
{
    if (m_battery == newBattery)
        return;
    m_battery = newBattery;
    emit batteryChanged();
}

QString VehicleData::gear() const
{
    return m_gear;
}
void VehicleData::setGear(const QString &newGear)
{
    if (m_gear == newGear)
        return;
    m_gear = newGear;
    emit gearChanged();
}

bool VehicleData::leftSignal() const
{
    return m_leftSignal;
}
void VehicleData::setLeftSignal(bool newLeftSignal)
{
    if (m_leftSignal == newLeftSignal)
        return;
    m_leftSignal = newLeftSignal;
    emit leftSignalChanged();
}

bool VehicleData::rightSignal() const
{
    return m_rightSignal;
}
void VehicleData::setRightSignal(bool newRightSignal)
{
    if (m_rightSignal == newRightSignal)
        return;
    m_rightSignal = newRightSignal;
    emit rightSignalChanged();
}

double VehicleData::tireFL() const
{
    return m_tireFL;
}
void VehicleData::setTireFL(double v)
{
    if (m_tireFL != v) {
        m_tireFL = v;
        emit tireFLChanged();
    }
}

double VehicleData::tireFR() const
{
    return m_tireFR;
}
void VehicleData::setTireFR(double v)
{
    if (m_tireFR != v) {
        m_tireFR = v;
        emit tireFRChanged();
    }
}

double VehicleData::tireRL() const
{
    return m_tireRL;
}
void VehicleData::setTireRL(double v)
{
    if (m_tireRL != v) {
        m_tireRL = v;
        emit tireRLChanged();
    }
}

double VehicleData::tireRR() const
{
    return m_tireRR;
}
void VehicleData::setTireRR(double v)
{
    if (m_tireRR != v) {
        m_tireRR = v;
        emit tireRRChanged();
    }
}
// --- [MỚI] IMPLEMENT CLIMATE SETTERS ---
bool VehicleData::isAC() const
{
    return m_isAC;
}
void VehicleData::setIsAC(bool v)
{
    if (m_isAC != v) {
        m_isAC = v;
        emit isACChanged();
    }
}

bool VehicleData::isAuto() const
{
    return m_isAuto;
}
void VehicleData::setIsAuto(bool v)
{
    if (m_isAuto != v) {
        m_isAuto = v;
        emit isAutoChanged();
    }
}

bool VehicleData::isSync() const
{
    return m_isSync;
}
void VehicleData::setIsSync(bool v)
{
    if (m_isSync != v) {
        m_isSync = v;
        emit isSyncChanged();
    }
}

int VehicleData::recircMode() const
{
    return m_recircMode;
}
void VehicleData::setRecircMode(int v)
{
    if (m_recircMode != v) {
        m_recircMode = v;
        emit recircModeChanged();
    }
}

int VehicleData::fanSpeed() const
{
    return m_fanSpeed;
}
void VehicleData::setFanSpeed(int v)
{
    if (m_fanSpeed != v) {
        m_fanSpeed = v;
        emit fanSpeedChanged();
    }
}

double VehicleData::tempLeft() const
{
    return m_tempLeft;
}
void VehicleData::setTempLeft(double v)
{
    if (m_tempLeft != v) {
        m_tempLeft = v;
        emit tempLeftChanged();
    }
}

double VehicleData::tempRight() const
{
    return m_tempRight;
}
void VehicleData::setTempRight(double v)
{
    if (m_tempRight != v) {
        m_tempRight = v;
        emit tempRightChanged();
    }
}

bool VehicleData::heatLeft() const
{
    return m_heatLeft;
}
void VehicleData::setHeatLeft(bool v)
{
    if (m_heatLeft != v) {
        m_heatLeft = v;
        emit heatLeftChanged();
    }
}

bool VehicleData::coolLeft() const
{
    return m_coolLeft;
}
void VehicleData::setCoolLeft(bool v)
{
    if (m_coolLeft != v) {
        m_coolLeft = v;
        emit coolLeftChanged();
    }
}

bool VehicleData::heatRight() const
{
    return m_heatRight;
}
void VehicleData::setHeatRight(bool v)
{
    if (m_heatRight != v) {
        m_heatRight = v;
        emit heatRightChanged();
    }
}

bool VehicleData::coolRight() const
{
    return m_coolRight;
}
void VehicleData::setCoolRight(bool v)
{
    if (m_coolRight != v) {
        m_coolRight = v;
        emit coolRightChanged();
    }
}
