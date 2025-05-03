//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    BTC_USD_TrendMicroSwing.mqh                             |
//| Purpose: Pure signal‐processing strategy for BTC/USD             |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/systems/StrategyBase.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>
#include <QuantPie/core/components/SignalComponent.mqh>
#include <QuantPie/core/config/Config.mqh>

class BTC_USD_TrendMicroSwing : public StrategyBase
{
private:
    int              m_fastMA;
    int              m_slowMA;
    ENUM_MA_METHOD   m_maMethod;
    ENUM_TIMEFRAMES  m_timeframe;
    double           m_atrThreshold;

public:
    // Construtor aceita apenas Config
    BTC_USD_TrendMicroSwing(const Config &cfg)
    {
        m_fastMA      = (int)cfg.Get("fastMA", 9);
        m_slowMA      = (int)cfg.Get("slowMA", 21);
        m_maMethod    = (ENUM_MA_METHOD)(int)cfg.Get("maMethod", MODE_SMA);
        m_timeframe   = (ENUM_TIMEFRAMES)(int)cfg.Get("timeframe", PERIOD_H1);
        m_atrThreshold= cfg.Get("atrMin", 100.0);

        // Registrar o sinal de cruzamento de médias móveis como componente filho
        SignalComponent signal(
            m_fastMA,
            m_slowMA,
            m_maMethod,
            /* symbol */ "",
            m_timeframe
        );
        AddSignalComponent(signal);
    }

    // Sobrescrever GetSignal: filtro ATR + cruzamento de médias móveis
    virtual SignalType GetSignal() override
    {
        // 1) Filtro ATR
        double atr = iATR(NULL, m_timeframe, m_fastMA);
        if(atr < m_atrThreshold)
            return SIGNAL_NONE;

        // 2) Delegar para StrategyBase: executa todos os SignalComponent(s) filhos
        return StrategyBase::GetSignal();
    }
};
