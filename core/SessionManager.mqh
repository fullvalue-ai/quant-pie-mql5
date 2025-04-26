//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    SessionManager.mqh                                      |
//| Purpose: Manage trading sessions (allowed trading hours)        |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class SessionManager
{
    private:
        int m_sessionStartHour;
        int m_sessionStartMinute;
        int m_sessionEndHour;
        int m_sessionEndMinute;

    public:
        SessionManager(int startHour = 0, int startMinute = 0, int endHour = 23, int endMinute = 59)
        {
            m_sessionStartHour   = startHour;
            m_sessionStartMinute = startMinute;
            m_sessionEndHour     = endHour;
            m_sessionEndMinute   = endMinute;
        }

    bool IsWithinSession();

    void SetSession(int startHour, int startMinute, int endHour, int endMinute)
        {
        m_sessionStartHour   = startHour;
        m_sessionStartMinute = startMinute;
        m_sessionEndHour     = endHour;
        m_sessionEndMinute   = endMinute;
        }

    int GetSessionStartHour() const { return m_sessionStartHour; }
    int GetSessionStartMinute() const { return m_sessionStartMinute; }
    int GetSessionEndHour() const { return m_sessionEndHour; }
    int GetSessionEndMinute() const { return m_sessionEndMinute; }
};
