//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_Template.mqh                                         |
//| Purpose: Generic EA wrapper for any StrategyBase-derived class   |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/systems/StrategyBase.mqh>
#include <QuantPie/core/components/IComponent.mqh>
#include <QuantPie/core/components/LoggerComponent.mqh>
#include <QuantPie/core/components/RiskComponent.mqh>
#include <QuantPie/core/components/LotComponent.mqh>
#include <QuantPie/core/components/OrderComponent.mqh>
#include <QuantPie/core/components/SessionComponent.mqh>
#include <QuantPie/core/components/SignalComponent.mqh>
#include <QuantPie/core/config/Config.mqh>

// External strategy instance (to be defined in the EA .mq5)
extern StrategyBase* strategy;

// Component array and counter
iComponent* components[];
int           componentsTotal = 0;

// Core component pointers
datetime       lastBarTime = 0;  // Tracks last closed bar
LoggerComponent*   loggerComponent;
RiskComponent*     riskComponent;
LotComponent*      lotComponent;
OrderComponent*    orderComponent;
SessionComponent*  sessionComponent;
SignalComponent*   signalComponent;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Instantiate core components
    loggerComponent  = new LoggerComponent();
    riskComponent    = new RiskComponent(0.01);
    lotComponent     = new LotComponent(0.01);
    orderComponent   = new OrderComponent(123456);
    sessionComponent = new SessionComponent(0, 0, 23, 59);
    signalComponent  = new SignalComponent(10, 50, MODE_SMA);

    // Setup lifecycle array
    ArrayResize(components, 6);
    components[0] = loggerComponent;
    components[1] = riskComponent;
    components[2] = lotComponent;
    components[3] = orderComponent;
    components[4] = sessionComponent;
    components[5] = signalComponent;
    componentsTotal = ArraySize(components);

    // Initialize components and strategy
    for(int i = 0; i < componentsTotal; i++)
        components[i]->OnInit();
    if(strategy != NULL)
        strategy->OnInit();
    else
        Print("Warning: No strategy instance created.");

    // Initialize bar tracking and timer
    lastBarTime = iTime(_Symbol, _Period, 0);
    EventSetTimer(1);  // 1-second interval for OnTimer

    loggerComponent->Log("EA Template Initialized Successfully.", LOG_INFO);
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Propagate OnTick
    for(int i = 0; i < componentsTotal; i++)
        components[i]->OnTick();
    if(strategy != NULL)
        strategy->OnTick();

    // Detect bar close and call OnBar
    datetime current = iTime(_Symbol, _Period, 0);
    if(current != lastBarTime)
    {
        lastBarTime = current;
        for(int i = 0; i < componentsTotal; i++)
            components[i]->OnBar();
        if(strategy != NULL)
            strategy->OnBar();
    }
}

//+------------------------------------------------------------------+
//| Timer event handler                                              |
//+------------------------------------------------------------------+
void OnTimer()
{
    for(int i = 0; i < componentsTotal; i++)
        components[i]->OnTimer();
    if(strategy != NULL)
        strategy->OnTimer();
}

//+------------------------------------------------------------------+
//| Trade transaction handler for OnOrderPlaced and OnOrderFilled    |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest     &request,
                        const MqlTradeResult      &result)
{
    // Order placed
    if(trans.type == TRADE_TRANSACTION_ORDER_ADD)
    {
        for(int i = 0; i < componentsTotal; i++)
            components[i]->OnOrderPlaced(trans.order);
        if(strategy != NULL)
            strategy->OnOrderPlaced(trans.order);
    }

    // Order filled
    if(trans.type == TRADE_TRANSACTION_DEAL_ADD)
    {
        for(int i = 0; i < componentsTotal; i++)
            components[i]->OnOrderFilled(trans.order, trans.price, trans.volume);
        if(strategy != NULL)
            strategy->OnOrderFilled(trans.order, trans.price, trans.volume);
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    EventKillTimer();

    // Deinitialize and delete components
    for(int i = 0; i < componentsTotal; i++)
    {
        components[i]->OnDeinit();
        delete components[i];
    }

    // Deinitialize strategy
    if(strategy != NULL)
        strategy->OnDeinit();
}

//+------------------------------------------------------------------+
//| EA Template Configuration                                        |
//+------------------------------------------------------------------+
class EA_Template
{
    void Configure(Config &cfg)
    {
        cfg.Set("fastMA", 10);
        cfg.Set("slowMA", 50);
        cfg.Set("maMethod", MODE_SMA);
    }
};