//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    IComponent.mqh                                          |
//| Purpose: Interface for all EA Components (Plug and Play system) |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class IComponent
{
public:
    virtual void OnInit() = 0;
    virtual void OnTick() = 0;
    virtual void OnTrade() = 0;
    virtual void OnDeinit() = 0;
    // destrutor virtual por segurança
    virtual ~IComponent() {}
};

