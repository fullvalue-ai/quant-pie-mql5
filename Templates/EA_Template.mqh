//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_Template.mq5                                         |
//| Purpose: Base EA Template using full Component architecture     |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/IComponent.mqh>
#include <QuantPie/core/StrategyBase.mqh>
#include <QuantPie/core/RiskManager.mqh>
#include <QuantPie/core/LoggerManager.mqh>
#include <QuantPie/core/LotManager.mqh>
#include <QuantPie/core/OrderManager.mqh>
#include <QuantPie/core/SessionManager.mqh>
#include <QuantPie/core/SignalManager.mqh>

// Global pointers
extern StrategyBase* strategy;
IComponent* components[];
int componentsTotal = 0;

// Manager instances
RiskManager* riskManager;
LoggerManager* loggerManager;
LotManager* lotManager;
OrderManager* orderManager;
SessionManager* sessionManager;
SignalManager* signalManager;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    riskManager = new RiskManager(0.01, 5, 5.0, 10.0, 20.0, 3);
    loggerManager = new LoggerManager();
    lotManager = new LotManager(0.01);
    orderManager = new OrderManager(123456, 5);
    sessionManager = new SessionManager(0, 0, 23, 59);
    signalManager = new SignalManager(10, 50, MODE_SMA);

    ArrayResize(components, 5);
    components[0] = riskManager;
    components[1] = loggerManager;
    components[2] = lotManager;
    components[3] = orderManager;
    components[4] = sessionManager;
    componentsTotal = ArraySize(components);

    for (int i = 0; i < componentsTotal; i++)
        components[i].OnInit();

    if (strategy != NULL)
        strategy.OnInit();
    else
        LoggerManager::Log("Warning: No strategy instance created.", LOG_WARNING);

    LoggerManager::Log("EA Template Initialized Successfully.", LOG_INFO);
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    if (strategy != NULL)
        strategy.OnTick();

    for (int i = 0; i < componentsTotal; i++)
        components[i].OnTick();
}

//+------------------------------------------------------------------+
//| Expert trade event function                                      |
//+------------------------------------------------------------------+
void OnTrade()
{
    if (strategy != NULL)
        strategy.OnTrade();

    for (int i = 0; i < componentsTotal; i++)
        components[i].OnTrade();
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    delete riskManager;
    delete loggerManager;
    delete lotManager;
    delete orderManager;
    delete sessionManager;
    delete signalManager;

    if (strategy != NULL)
        delete strategy;
}
