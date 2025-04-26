//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    SignalManager.mqh                                       |
//| Purpose: Manage simple signal generation as a Component         |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "IComponent.mqh"
#include "StrategyBase.mqh"

class SignalManager : public IComponent
{
private:
    int m_fastPeriod;
    int m_slowPeriod;
    ENUM_MA_METHOD m_maMethod;
    string m_symbol;
    ENUM_TIMEFRAMES m_timeframe;

public:
    SignalManager(int fastPeriod = 10, int slowPeriod = 50, ENUM_MA_METHOD maMethod = MODE_SMA, string symbol = "", ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
    {
        m_fastPeriod = fastPeriod;
        m_slowPeriod = slowPeriod;
        m_maMethod = maMethod;
        m_symbol = (symbol == "") ? _Symbol : symbol;
        m_timeframe = timeframe;
    }

    void OnInit() override {}
    void OnTick() override {}
    void OnTrade() override {}

    SignalType GetSignal()
    {
        int fast_ma_handle = iMA(m_symbol, m_timeframe, m_fastPeriod, 0, m_maMethod, PRICE_CLOSE);
        int slow_ma_handle = iMA(m_symbol, m_timeframe, m_slowPeriod, 0, m_maMethod, PRICE_CLOSE);

        double fast_ma[], slow_ma[];
        if (CopyBuffer(fast_ma_handle, 0, 0, 2, fast_ma) <= 0)
            return SIGNAL_NONE;
        if (CopyBuffer(slow_ma_handle, 0, 0, 2, slow_ma) <= 0)
            return SIGNAL_NONE;

        if (fast_ma[1] < slow_ma[1] && fast_ma[0] > slow_ma[0])
            return SIGNAL_BUY;

        if (fast_ma[1] > slow_ma[1] && fast_ma[0] < slow_ma[0])
            return SIGNAL_SELL;

        return SIGNAL_NONE;
    }

};
