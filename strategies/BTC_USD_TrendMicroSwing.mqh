//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    BTC_USD_TrendMicroSwing.mqh                             |
//| Purpose: Pure signal‐processing strategy for BTC/USD             |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/systems/StrategyBase.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>
#include <QuantPie/core/components/SignalComponent.mqh>
#include <QuantPie/core/config/SignalConfig.mqh>

class BTC_USD_TrendMicroSwing : public StrategyBase
{
private:
    int              m_fastMA;
    int              m_slowMA;
    ENUM_MA_METHOD   m_maMethod;
    ENUM_TIMEFRAMES  m_timeframe;
    double           m_atrThreshold;

public:
    // ctor takes only SignalConfig
    BTC_USD_TrendMicroSwing(const SignalConfig &cfg)
    {
        m_fastMA      = (int)cfg.Get("fastMA", 9);
        m_slowMA      = (int)cfg.Get("slowMA", 21);
        m_maMethod    = (ENUM_MA_METHOD)(int)cfg.Get("maMethod", MODE_SMA);
        m_timeframe   = (ENUM_TIMEFRAMES)(int)cfg.Get("timeframe", PERIOD_H1);
        m_atrThreshold= cfg.Get("atrMin", 100.0);

        // register the crossover MA signal as a child component
        AddSignalComponent(
            new SignalComponent(
                m_fastMA,
                m_slowMA,
                m_maMethod,
                /* symbol */ "",
                m_timeframe
            )
        );
    }

    // Only need to override GetSignal: ATR filter + MA crossover
    virtual SignalType GetSignal() override
    {
        // 1) ATR filter
        double atr = iATR(NULL, m_timeframe, m_fastMA);
        if(atr < m_atrThreshold)
            return SIGNAL_NONE;

        // 2) delegate to StrategyBase: runs all child SignalComponent(s)
        return StrategyBase::GetSignal();
    }
};
