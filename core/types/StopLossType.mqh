//+------------------------------------------------------------------+
//| File:    StopLossType.mqh                                       |
//| Purpose: Enum for stop loss types                               |
//+------------------------------------------------------------------+
#property strict

enum ENUM_STOP_LOSS_TYPE {
   STOP_LOSS_POINTS,  // Points/Pips
   STOP_LOSS_ATR,     // ATR-based
   STOP_LOSS_NONE     // None
};