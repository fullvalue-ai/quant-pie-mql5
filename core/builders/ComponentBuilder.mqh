//+------------------------------------------------------------------+
//| File:    ComponentBuilder.mqh                                   |
//| Purpose: Fluent builder for automatic DIContainer configuration | 
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/config/SignalConfig.mqh>
#include <QuantPie/core/builders/EAConfig.mqh>
#include <QuantPie/core/builders/DIContainer.mqh>

// Fluent builder encapsulating EAConfig, SignalConfig and DIContainer
class ComponentBuilder
{
private:
    EAConfig     m_execConfig;
    SignalConfig m_signalConfig;
    DIContainer  m_container;

public:
    // Configure execution settings (risk, order, session)
    ComponentBuilder& ConfigureExecution(const EAConfig &cfg)
    {
        m_execConfig = cfg;
        return *this;
    }

    // Configure signal settings (moving average, RSI, etc.)
    ComponentBuilder& ConfigureSignal(const SignalConfig &sigCfg)
    {
        m_signalConfig = sigCfg;
        return *this;
    }

    // Add core execution components: logger, risk, lot, order, session
    ComponentBuilder& AddCoreComponents()
    {
        m_container
            .AddLogger()
            .AddRisk(m_execConfig.riskPercent)
            .AddLot(m_execConfig.riskPercent)
            .AddOrder(m_execConfig.magicNumber)
            .AddSession(m_execConfig.sessStartH, m_execConfig.sessStartM,
                        m_execConfig.sessEndH,   m_execConfig.sessEndM);
        if(m_execConfig.useBreakEven)
            m_container.AddComponent(new BreakEvenComponent(m_execConfig.breakEvenPips));
        if(m_execConfig.useTrailingStop)
            m_container.AddComponent(new TrailingStopComponent(m_execConfig.trailingStopPips));
        return *this;
    }

    // Add signal component based on configured signal settings
    ComponentBuilder& AddSignalComponent()
    {
        m_container.AddSignal(
            (int)m_signalConfig.Get("fastMA", 10),
            (int)m_signalConfig.Get("slowMA", 50),
            (ENUM_MA_METHOD)(int)m_signalConfig.Get("maMethod", MODE_SMA)
        );
        return *this;
    }

    // Register user strategy
    ComponentBuilder& AddStrategy(StrategyBase *strategy)
    {
        m_container.AddStrategy(strategy);
        return *this;
    }

    // Finalize and retrieve the configured container
    DIContainer& Build()
    {
        return m_container;
    }
};
