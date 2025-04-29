//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    SignalComponent.mqh                                     |
//| Purpose: Manage simple signal generation as a component          |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/ISignalComponent.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>

class SignalComponent : public ISignalComponent
{
private:
    int            m_fastPeriod;
    int            m_slowPeriod;
    ENUM_MA_METHOD m_maMethod;
    string         m_symbol;
    ENUM_TIMEFRAMES m_timeframe;

public:
    // Constructor
    SignalComponent(int fastPeriod = 10,
                    int slowPeriod = 50,
                    ENUM_MA_METHOD maMethod = MODE_SMA,
                    string symbol = "",
                    ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
    {
        m_fastPeriod = fastPeriod;
        m_slowPeriod = slowPeriod;
        m_maMethod    = maMethod;
        m_symbol      = (symbol == "") ? _Symbol : symbol;
        m_timeframe   = timeframe;
    }

    // Destructor
    ~SignalComponent() override { }

    // Component lifecycle methods
    void OnInit()   { /* optional initialization */ }
    void OnTick()   { /* optional tick update */ }
    void OnTrade()  { /* optional post-trade update */ }
    void OnDeinit(){ /* optional cleanup */ }

    // Evaluate and return the trading signal
    SignalType EvaluateSignal() override
    {
        int fastHandle = iMA(m_symbol, m_timeframe, m_fastPeriod, 0, m_maMethod, PRICE_CLOSE);
        int slowHandle = iMA(m_symbol, m_timeframe, m_slowPeriod, 0, m_maMethod, PRICE_CLOSE);

        double fastMA[], slowMA[];
        if (CopyBuffer(fastHandle, 0, 0, 2, fastMA) <= 0) return SIGNAL_NONE;
        if (CopyBuffer(slowHandle, 0, 0, 2, slowMA) <= 0) return SIGNAL_NONE;

        // Bullish crossover
        if (fastMA[1] < slowMA[1] && fastMA[0] > slowMA[0])
            return SIGNAL_BUY;

        // Bearish crossover
        if (fastMA[1] > slowMA[1] && fastMA[0] < slowMA[0])
            return SIGNAL_SELL;

        return SIGNAL_NONE;
    }

    // Optional: reset internal state after signal consumption
    void Reset() override
    {
        // e.g. clear last signal flag, counters, etc.
    }
};
