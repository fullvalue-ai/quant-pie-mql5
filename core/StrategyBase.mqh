//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    StrategyBase.mqh                                        |
//| Purpose: Base class for all strategies as a Component            |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "IComponent.mqh"

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
    void OnInit() override
    {
        // Base initialization logic if needed
    }

    void OnTick() override
    {
        // Base tick logic if needed
    }

    void OnTrade() override
    {
        // Base trade event logic if needed
    }

    // Mandatory function for all strategies
    virtual SignalType GetSignal() = 0;
};
