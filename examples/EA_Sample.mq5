//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_Sample.mq5                                           |
//| Purpose: Example EA using Quant-Pie Core                         |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "..\\core\\OrderManager.mqh"
#include "..\\core\\RiskManager.mqh"
#include "..\\core\\PositionManager.mqh"
#include "..\\core\\SessionManager.mqh"

// Create instances
OrderManager    orderManager(123456);
RiskManager     riskManager(1.0, 5, 10.0);
PositionManager positionManager(100, 200, 100, 50);
SessionManager  sessionManager(9, 0, 17, 0); // 09:00 às 17:00

int OnInit()
{
    Print("EA Sample Started!");
    return INIT_SUCCEEDED;
}

void OnTick()
{
    // Check if within allowed session
    if(!sessionManager.IsWithinSession())
        return;

    // Check if allowed to open new trade
    if(!riskManager.CanOpenNewTrade())
        return;

    // Open simple Buy
    orderManager.OpenBuy(0.1);

    // Apply BreakEven and TrailingStop to existing positions
    ulong ticket = 0; // In real case, you would loop over open positions and get ticket
    positionManager.ApplyBreakEven(ticket);
    positionManager.ApplyTrailingStop(ticket);
}
