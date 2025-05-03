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
#include <QuantPie/core/builders/DIContainer.mqh>

class SignalComponent : public ISignalComponent
{
private:
    DIContainer &m_container; // Referência ao DIContainer
    ENUM_TIMEFRAMES m_timeframe;

public:
    SignalComponent(DIContainer &container)
        : m_container(container) // Injetar DIContainer
    {
        m_timeframe = (ENUM_TIMEFRAMES)container.GetDefaultTimeframe();
    }

    void OnInit() override
    {
        Print("Signal component initialized with timeframe: ", EnumToString(m_timeframe));
    }

    void OnTick() {}

    void OnTrade() {}

    void OnDeinit() {}

    // Avaliar e retornar o sinal de negociação
    SignalType EvaluateSignal()
    {
        int fastHandle = iMA(m_container.GetSymbol(), m_timeframe, m_container.GetFastPeriod(), 0, m_container.GetMAMethod(), PRICE_CLOSE);
        int slowHandle = iMA(m_container.GetSymbol(), m_timeframe, m_container.GetSlowPeriod(), 0, m_container.GetMAMethod(), PRICE_CLOSE);

        double fastMA[2], slowMA[2];
        if (CopyBuffer(fastHandle, 0, 0, 2, fastMA) <= 0) return SIGNAL_NONE;
        if (CopyBuffer(slowHandle, 0, 0, 2, slowMA) <= 0) return SIGNAL_NONE;

        // Cruzamento de alta
        if (fastMA[1] < slowMA[1] && fastMA[0] > slowMA[0])
            return SIGNAL_BUY;

        // Cruzamento de baixa
        if (fastMA[1] > slowMA[1] && fastMA[0] < slowMA[0])
            return SIGNAL_SELL;

        return SIGNAL_NONE;
    }

    // Opcional: redefinir estado interno após consumo do sinal
    void Reset() override
    {
        // Exemplo: limpar sinal anterior, contadores, etc.
    }
};
