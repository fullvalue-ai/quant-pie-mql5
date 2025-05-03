//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    SessionComponent.mqh                                    |
//| Purpose: Manage allowed trading sessions as a Component         |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>
#include <QuantPie/core/types/TimeframeType.mqh>
#include <QuantPie/core/builders/DIContainer.mqh>

class SessionComponent : public IComponent
{
private:
    DIContainer &m_container; // Referência ao DIContainer
    ENUM_TIMEFRAME m_startTime;
    ENUM_TIMEFRAME m_endTime;

public:
    SessionComponent(DIContainer &container)
        : m_container(container) // Injetar DIContainer
    {
        m_startTime = container.GetDefaultTimeframe();
        m_endTime = container.GetDefaultTimeframe();
    }

    void OnInit() override
    {
        Print("Session starts at: ", EnumToString(m_startTime));
        Print("Session ends at: ", EnumToString(m_endTime));
    }

    void OnTick() {}

    void OnTrade() {}

    void OnDeinit() {}

    bool IsWithinSession()
    {
        MqlDateTime timeStruct;
        TimeToStruct(TimeCurrent(), timeStruct);

        int currentMinutes = timeStruct.hour * 60 + timeStruct.min;
        int startMinutes = TimeframeToMinutes(m_startTime);
        int endMinutes = TimeframeToMinutes(m_endTime);

        return (currentMinutes >= startMinutes && currentMinutes <= endMinutes);
    }
};
