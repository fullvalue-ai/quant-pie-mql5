//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    IComponent.mqh                                          |
//| Purpose: Interface for all EA Components (Plug and Play system) |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

// Interface for all components with extended lifecycle events
class IComponent
{
public:
    virtual ~IComponent() {}

    // Core lifecycle methods
    virtual void OnInit() = 0;                   // EA initialization
    virtual void OnTick() = 0;                   // Every market tick
    virtual void OnTrade() = 0;                  // OnTrade callback
    virtual void OnDeinit() = 0;                 // EA deinitialization

    // Extended lifecycle methods (default no-op)
    virtual void OnBar() {}                             // Candle close
    virtual void OnTimer() {}                           // Timer interval
    virtual void OnOrderPlaced(const ulong ticket) {}   // After OrderSend
    virtual void OnOrderFilled(const ulong ticket,
                                const double price,
                                const double volume) {} // OnDeal execution
};

