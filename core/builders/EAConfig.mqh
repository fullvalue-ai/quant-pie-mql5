//+------------------------------------------------------------------+
//| File:    EAConfig.mqh                                            |
//| Purpose: Execution configuration for EA systems (risk, order, session) |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

// Holds all execution-related parameters for the EA
struct EAConfig
{
    double    riskPercent;     // Risk percentage per trade (e.g., 0.01 for 1%)
    int       magicNumber;     // Unique identifier for EA orders
    bool      useBreakEven;    // Toggle Break-Even feature
    int       breakEvenPips;   // Distance in pips to activate Break-Even
    bool      useTrailingStop; // Toggle Trailing Stop feature
    int       trailingStopPips;// Trailing Stop distance in pips
    int       sessStartH;      // Session start hour (0-23)
    int       sessStartM;      // Session start minute (0-59)
    int       sessEndH;        // Session end hour (0-23)
    int       sessEndM;        // Session end minute (0-59)
};
