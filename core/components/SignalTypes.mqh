//+------------------------------------------------------------------+
//| File: SignalTypes.mqh                                            |
//| Purpose: Reusable enum for signal types across the framework     |
//+------------------------------------------------------------------+
#property strict

enum SignalType
{
    SIGNAL_NONE,   // no signal
    SIGNAL_BUY,    // bullish signal
    SIGNAL_SELL    // bearish signal
};
