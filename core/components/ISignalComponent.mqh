//+------------------------------------------------------------------+
//| File: ISignalComponent.mqh                                       |
//| Purpose: Interface for components that generate trading signals  |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>

// Interface for signal-generating components
class ISignalComponent : public IComponent
{
public:
    virtual ~ISignalComponent() {}

    // Evaluate conditions and return a trading signal
    virtual SignalType EvaluateSignal() = 0;

    // Optional: reset internal state after signal generation
    virtual void Reset() { }
};
