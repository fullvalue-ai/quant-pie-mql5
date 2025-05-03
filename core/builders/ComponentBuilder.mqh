//+------------------------------------------------------------------+
//| File:    ComponentBuilder.mqh                                   |
//| Purpose: Fluent builder for automatic DIContainer configuration | 
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/config/Config.mqh>
#include <QuantPie/core/builders/DIContainer.mqh>
#include <QuantPie/core/types/OrderType.mqh>
#include <QuantPie/core/types/StopLossType.mqh>
#include <QuantPie/core/systems/IStrategy.mqh>
#include <QuantPie/core/builders/Workflow.mqh>

// Fluent builder: configura DIContainer usando Config genérico
class ComponentBuilder
{
private:
    Workflow* m_workflow;

public:
    // Construtor
    ComponentBuilder(DIContainer &container)
    {
        m_workflow = new Workflow(container);
    }

    ComponentBuilder& AddLogger()
    {
        m_workflow->OnInit();
        return *this;
    }

    ComponentBuilder& AddOrder()
    {
        m_workflow->OnInit();
        return *this;
    }

    ComponentBuilder& AddRisk()
    {
        m_workflow->OnInit();
        return *this;
    }

    ComponentBuilder& AddSession()
    {
        m_workflow->OnInit();
        return *this;
    }

    ComponentBuilder& AddSignal()
    {
        m_workflow->OnInit();
        return *this;
    }

    ComponentBuilder& AddLot()
    {
        m_workflow->OnInit();
        return *this;
    }

    ComponentBuilder& AddPosition()
    {
        m_workflow->OnInit();
        return *this;
    }

    // Retornar o workflow configurado
    Workflow* Build()
    {
        return m_workflow;
    }
};