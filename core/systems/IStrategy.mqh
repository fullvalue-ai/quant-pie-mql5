//+------------------------------------------------------------------+
//| File:    IStrategy.mqh                                          |
//| Purpose: Interface for all strategies                          |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>

class IStrategy : public IComponent
{
public:
    virtual ~IStrategy() {}

    // Evaluate and return the current trading signal
    virtual SignalType GetSignal() = 0;
};