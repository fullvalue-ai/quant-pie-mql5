//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    StrategyBase.mqh                                        |
//| Purpose: Base class for all strategies as a Component            |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>

// Signal Types for strategies
enum SignalType
{
    SIGNAL_NONE,
    SIGNAL_BUY,
    SIGNAL_SELL
};

class StrategyBase : public IComponent
{
public:
    // Virtual destructor
    virtual ~StrategyBase() {}

    // Component Methods
    void OnInit() override {}

    void OnTick() override {}

    void OnTrade() override {}

    void OnDeinit() override {}

    // Mandatory function for all strategies
    virtual SignalType GetSignal() = 0;
};
