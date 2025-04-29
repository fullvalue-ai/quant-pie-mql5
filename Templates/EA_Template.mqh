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

// External strategy instance (to be defined in the EA .mq5)
extern StrategyBase* strategy;

// Array of core components for lifecycle management
IComponent* components[];
int         componentsTotal = 0;

// Core component pointers
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

    // Initialize all components
    for(int i = 0; i < componentsTotal; i++)
        components[i]->OnInit();

    // Initialize strategy if provided
    if(strategy != NULL)
        strategy->OnInit();
    else
        Print("Warning: No strategy instance created.");

    loggerComponent->Log("EA Template Initialized Successfully.", LOG_INFO);
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    if(strategy != NULL)
        strategy->OnTick();

    for(int i = 0; i < componentsTotal; i++)
        components[i]->OnTick();
}

//+------------------------------------------------------------------+
//| Expert trade event function                                      |
//+------------------------------------------------------------------+
void OnTrade()
{
    if(strategy != NULL)
        strategy->OnTrade();

    for(int i = 0; i < componentsTotal; i++)
        components[i]->OnTrade();
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Cleanup components
    for(int i = 0; i < componentsTotal; i++)
        delete components[i];

    // Cleanup strategy if allocated
    if(strategy != NULL)
        delete strategy;
}
