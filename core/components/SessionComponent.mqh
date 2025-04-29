//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    SessionComponent.mqh                                      |
//| Purpose: Manage allowed trading sessions as a Component         |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>

class SessionComponent : public IComponent
{
private:
    int m_startHour;
    int m_startMinute;
    int m_endHour;
    int m_endMinute;

public:
    SessionComponent(int startHour = 0, int startMinute = 0, int endHour = 23, int endMinute = 59)
    {
        m_startHour = startHour;
        m_startMinute = startMinute;
        m_endHour = endHour;
        m_endMinute = endMinute;
    }

    // Component Methods
    void OnInit() {}

    void OnTick() {}

    void OnTrade() {}

    void OnDeinit() {}

    bool IsWithinSession()
    {
        MqlDateTime timeStruct;
        TimeToStruct(TimeCurrent(), timeStruct);

        int currentMinutes = timeStruct.hour * 60 + timeStruct.min;
        int startMinutes = m_startHour * 60 + m_startMinute;
        int endMinutes = m_endHour * 60 + m_endMinute;

        return (currentMinutes >= startMinutes && currentMinutes <= endMinutes);
    }
};
