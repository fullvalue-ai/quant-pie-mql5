// File: strategies/EA_SampleStrategy.mqh
// Purpose: Strategy that uses a simple moving average crossover signal
#property strict

#include <QuantPie/core/systems/StrategyBase.mqh>
#include <QuantPie/core/config/SignalConfig.mqh>
#include <QuantPie/core/components/SignalComponent.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>

class EA_SampleStrategy : public StrategyBase
{
public:
    // Construct with a flexible signal configuration
    EA_SampleStrategy(const SignalConfig &cfg)
    {
        // retrieve parameters from flexible bag
        int fast = (int)cfg.Get("fastMA", 5);
        int slow = (int)cfg.Get("slowMA", 20);
        ENUM_MA_METHOD method = (ENUM_MA_METHOD)(int)cfg.Get("maMethod", MODE_SMA);

        // add a single moving average crossover component
        AddSignalComponent(new SignalComponent(fast, slow, method));
    }

    // Optionally override GetSignal() for custom logic
    // but base StrategyBase::GetSignal() returns the first non-NONE
};