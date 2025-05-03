#ifndef DI_CONTAINER_MQH
#define DI_CONTAINER_MQH

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
#include <QuantPie/core/components/PositionComponent.mqh>
#include <QuantPie/core/systems/StrategyBase.mqh>
#include <QuantPie/core/types/OrderType.mqh>
#include <QuantPie/core/types/StopLossType.mqh>
#include <QuantPie/core/types/TimeframeType.mqh>

#define MAX_DI_COMPONENTS 32

class DIContainer : public IComponent
{
private:
    IComponent* m_components[MAX_DI_COMPONENTS]; // Alterado para ponteiros
    int         m_count;

    LoggerComponent* m_logger;
    OrderComponent* m_order;
    RiskComponent* m_risk;
    SessionComponent* m_session;
    SignalComponent* m_signal;
    LotComponent* m_lot;
    PositionComponent* m_position;

public:
    // Construtor
    DIContainer()
    {
        m_count = 0;
        for (int i = 0; i < MAX_DI_COMPONENTS; i++)
            m_components[i] = NULL; // Inicializar ponteiros como NULL

        m_logger = NULL;
        m_order = NULL;
        m_risk = NULL;
        m_session = NULL;
        m_signal = NULL;
        m_lot = NULL;
        m_position = NULL;
    }

    // Adicionar qualquer instância derivada de IComponent
    void AddComponent(IComponent& comp)
    {
        if (m_count < MAX_DI_COMPONENTS)
        {
            m_components[m_count++] = &comp;
        }
    }

    // Métodos auxiliares para componentes principais
    void AddLogger()
    {
        LoggerComponent* logger = new LoggerComponent();
        AddComponent(*logger);
    }

    void AddRisk(double riskPercent)
    {
        RiskComponent* risk = new RiskComponent(riskPercent);
        AddComponent(*risk);
    }

    void AddLot(double riskPercent)
    {
        LotComponent* lot = new LotComponent(riskPercent);
        AddComponent(*lot);
    }

    void AddOrder(int magicNumber)
    {
        OrderComponent* order = new OrderComponent(magicNumber);
        AddComponent(*order);
    }

    void AddSession(int startHour, int startMin, int endHour, int endMin)
    {
        SessionComponent* session = new SessionComponent(startHour, startMin, endHour, endMin);
        AddComponent(*session);
    }

    void AddSignal(int fastPeriod, int slowPeriod, ENUM_MA_METHOD maMethod)
    {
        SignalComponent* signal = new SignalComponent(fastPeriod, slowPeriod, maMethod);
        AddComponent(*signal);
    }

    void AddStrategy(StrategyBase& strat)
    {
        AddComponent(strat);
    }

    // Métodos de ciclo de vida
    void OnInit()
    {
        for (int i = 0; i < m_count; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnInit();
        }
    }

    void OnTick()
    {
        for (int i = 0; i < m_count; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnTick();
        }
    }

    void OnTrade()
    {
        for (int i = 0; i < m_count; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnTrade();
        }
    }

    void OnDeinit()
    {
        for (int i = 0; i < m_count; i++)
        {
            if (m_components[i] != NULL)
            {
                m_components[i]->OnDeinit();
                delete m_components[i]; // Liberar memória
            }
        }
    }

    LoggerComponent& GetLogger()
    {
        if (m_logger == NULL)
            m_logger = new LoggerComponent(*this);
        return *m_logger;
    }

    OrderComponent& GetOrder()
    {
        if (m_order == NULL)
            m_order = new OrderComponent(*this);
        return *m_order;
    }

    RiskComponent& GetRisk()
    {
        if (m_risk == NULL)
            m_risk = new RiskComponent(*this);
        return *m_risk;
    }

    SessionComponent& GetSession()
    {
        if (m_session == NULL)
            m_session = new SessionComponent(*this);
        return *m_session;
    }

    SignalComponent& GetSignal()
    {
        if (m_signal == NULL)
            m_signal = new SignalComponent(*this);
        return *m_signal;
    }

    LotComponent& GetLot()
    {
        if (m_lot == NULL)
            m_lot = new LotComponent(*this);
        return *m_lot;
    }

    PositionComponent& GetPosition()
    {
        if (m_position == NULL)
            m_position = new PositionComponent(*this);
        return *m_position;
    }

    ~DIContainer()
    {
        delete m_logger;
        delete m_order;
        delete m_risk;
        delete m_session;
        delete m_signal;
        delete m_lot;
        delete m_position;
    }

    // Example: Provide access to enums or shared types
    ENUM_ORDER_TYPE GetOrderType() const { return ORDER_MARKET; } // Placeholder
    ENUM_STOP_LOSS_TYPE GetStopLossType() const { return STOP_LOSS_POINTS; } // Placeholder
    ENUM_TIMEFRAME GetDefaultTimeframe() const { return TIMEFRAME_0900; } // Placeholder
};

#endif // DI_CONTAINER_MQH