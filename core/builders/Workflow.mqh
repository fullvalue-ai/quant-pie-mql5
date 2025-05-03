//+------------------------------------------------------------------+
//| File:    Workflow.mqh                                           |
//| Purpose: Manage lifecycle and components in a unified workflow  |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>
#include <QuantPie/core/builders/DIContainer.mqh>

class Workflow
{
private:
    DIContainer &m_container; // Referência ao DIContainer
    IComponent* m_components[];
    IStrategy* m_strategies[];
    int m_componentCount;
    int m_strategyCount;

public:
    Workflow(DIContainer &container)
        : m_container(container)
    {
        ArrayResize(m_components, 0);
        ArrayResize(m_strategies, 0);
        m_componentCount = 0;
        m_strategyCount = 0;
    }

    // Adicionar um componente ao workflow
    void AddComponent(IComponent &component)
    {
        ArrayResize(m_components, m_componentCount + 1);
        m_components[m_componentCount++] = &component;
    }

    // Adicionar uma estratégia ao workflow
    void AddStrategy(IStrategy &strategy)
    {
        ArrayResize(m_strategies, m_strategyCount + 1);
        m_strategies[m_strategyCount++] = &strategy;
    }

    // Métodos de ciclo de vida
    void OnInit()
    {
        for (int i = 0; i < m_componentCount; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnInit();
        }
        for (int i = 0; i < m_strategyCount; i++)
        {
            if (m_strategies[i] != NULL)
                m_strategies[i]->OnInit();
        }
    }

    void OnTick()
    {
        for (int i = 0; i < m_componentCount; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnTick();
        }
        for (int i = 0; i < m_strategyCount; i++)
        {
            if (m_strategies[i] != NULL)
                m_strategies[i]->OnTick();
        }
    }

    void OnTrade()
    {
        for (int i = 0; i < m_componentCount; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnTrade();
        }
        for (int i = 0; i < m_strategyCount; i++)
        {
            if (m_strategies[i] != NULL)
                m_strategies[i]->OnTrade();
        }
    }

    void OnDeinit()
    {
        for (int i = 0; i < m_componentCount; i++)
        {
            if (m_components[i] != NULL)
                m_components[i]->OnDeinit();
        }
        for (int i = 0; i < m_strategyCount; i++)
        {
            if (m_strategies[i] != NULL)
                m_strategies[i]->OnDeinit();
        }
    }
};