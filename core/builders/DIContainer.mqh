//+------------------------------------------------------------------+
//| File:    DIContainer.mqh                                         |
//| Purpose: Manages lifecycle of components and strategy            |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>
#include <QuantPie/core/components/LoggerComponent.mqh>
#include <QuantPie/core/components/RiskComponent.mqh>
#include <QuantPie/core/components/LotComponent.mqh>
#include <QuantPie/core/components/OrderComponent.mqh>
#include <QuantPie/core/components/SessionComponent.mqh>
#include <QuantPie/core/components/SignalComponent.mqh>
#include <QuantPie/core/systems/StrategyBase.mqh>

#define MAX_DI_COMPONENTS 32

class DIContainer : public IComponent
{
private:
    IComponent* m_components[MAX_DI_COMPONENTS];
    int         m_count;

public:
    // Constructor
    DIContainer()
    {
        m_count = 0;
        ArrayInitialize(m_components, NULL);
    }

    // Destructor
    ~DIContainer() {}

    // Add any IComponent-derived instance
    DIContainer& AddComponent(IComponent* comp)
    {
        if(comp != NULL && m_count < MAX_DI_COMPONENTS)
            m_components[m_count++] = comp;
        return *this;
    }

    // Fluent helpers for core components
    DIContainer& AddLogger()
    {
        return AddComponent(new LoggerComponent());
    }

    DIContainer& AddRisk(double riskPercent)
    {
        return AddComponent(new RiskComponent(riskPercent));
    }

    DIContainer& AddLot(double riskPercent)
    {
        return AddComponent(new LotComponent(riskPercent));
    }

    DIContainer& AddOrder(int magicNumber)
    {
        return AddComponent(new OrderComponent(magicNumber));
    }

    DIContainer& AddSession(int startHour, int startMin, int endHour, int endMin)
    {
        return AddComponent(new SessionComponent(startHour, startMin, endHour, endMin));
    }

    DIContainer& AddSignal(int fastPeriod, int slowPeriod, ENUM_MA_METHOD maMethod)
    {
        return AddComponent(new SignalComponent(fastPeriod, slowPeriod, maMethod));
    }

    // Register your trading strategy (must derive from StrategyBase)
    DIContainer& AddStrategy(StrategyBase* strat)
    {
        return AddComponent(strat);
    }

    // IComponent lifecycle: propagate to all components
    void OnInit()
    {
        for(int i = 0; i < m_count; i++)
            m_components[i]->OnInit();
    }

    void OnTick()
    {
        for(int i = 0; i < m_count; i++)
            m_components[i]->OnTick();
    }

    void OnTrade()
    {
        for(int i = 0; i < m_count; i++)
            m_components[i]->OnTrade();
    }

    void OnDeinit()
    {
        for(int i = 0; i < m_count; i++)
        {
            m_components[i]->OnDeinit();
            delete m_components[i];
        }
    }
};
