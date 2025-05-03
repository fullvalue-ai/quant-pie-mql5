// File: strategies/EA_SampleStrategy.mqh
// Purpose: Strategy that uses a simple moving average crossover signal
#property strict

#include <QuantPie/core/systems/StrategyBase.mqh>
#include <QuantPie/core/components/SignalComponent.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>
#include <QuantPie/core/config/Config.mqh>

class EA_SampleStrategy : public StrategyBase
{
public:
    // Construtor com uma configuração flexível usando Config
    EA_SampleStrategy(Config &cfg)
    {
        int fast = cfg.GetInt("fastMA", 5);
        int slow = cfg.GetInt("slowMA", 20);
        ENUM_MA_METHOD method = (ENUM_MA_METHOD)cfg.GetInt("maMethod", MODE_SMA);

        SignalComponent signal(fast, slow, method);
        AddSignalComponent(signal);
    }
};