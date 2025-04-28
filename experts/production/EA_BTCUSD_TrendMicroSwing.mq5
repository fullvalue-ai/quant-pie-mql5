//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_BTCUSD_TrendMicroSwing.mq5                           |
//| Purpose: EA connecting MetaTrader to BTC_USD_TrendMicroSwing     |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/templates/EA_Template.mqh>
#include <QuantPie/strategies/BTC_USD_TrendMicroSwing.mqh>

BTC_USD_TrendMicroSwing strategy;

int OnInit()
{
    return strategy.OnInit();
}

void OnTick()
{
    strategy.OnTick();
}

void OnTrade()
{
    strategy.OnTrade();
}

void OnDeinit(const int reason)
{
    strategy.OnDeinit(reason);
}
