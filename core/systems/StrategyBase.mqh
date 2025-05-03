//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    StrategyBase.mqh                                        |
//| Purpose: Base class to orchestrate signal components             |
//|                                                                  |
//| (c) 2024 FullValue.AI – All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>
#include <QuantPie/core/components/ISignalComponent.mqh>
#include <QuantPie/core/components/SignalTypes.mqh>

// Maximum number of signal components per strategy
#define MAX_SIGNAL_COMPONENTS 10

class StrategyBase : public IComponent
{
    protected:
        ISignalComponent* m_signals[MAX_SIGNAL_COMPONENTS]; // Alterado para ponteiros
        int              m_signalCount;

    public:
        // Construtor: inicializar armazenamento
        StrategyBase()
        {
            m_signalCount = 0;
            for (int i = 0; i < MAX_SIGNAL_COMPONENTS; i++)
                m_signals[i] = NULL; // Inicializar ponteiros como NULL
        }

        // Registrar um componente de sinal
        bool AddSignalComponent(ISignalComponent& component)
        {
            if (m_signalCount >= MAX_SIGNAL_COMPONENTS)
                return false;
            m_signals[m_signalCount++] = &component;
            return true;
        }

        // Ciclo de vida principal: propagar para todos os sinais registrados
        virtual void OnInit() override
        {
            for (int i = 0; i < m_signalCount; i++)
                if (m_signals[i] != NULL)
                    m_signals[i]->OnInit();
        }

        virtual void OnTick() override
        {
            for (int i = 0; i < m_signalCount; i++)
                if (m_signals[i] != NULL)
                    m_signals[i]->OnTick();
        }

        virtual void OnTrade() override
        {
            for (int i = 0; i < m_signalCount; i++)
                if (m_signals[i] != NULL)
                    m_signals[i]->OnTrade();
        }

        virtual void OnDeinit() override
        {
            for (int i = 0; i < m_signalCount; i++)
                if (m_signals[i] != NULL)
                    m_signals[i]->OnDeinit();
        }

    protected:
        // Avaliar todos os sinais e retornar o primeiro diferente de NONE
        SignalType EvaluateSignals()
        {
            for (int i = 0; i < m_signalCount; i++)
            {
                if (m_signals[i] != NULL)
                {
                    SignalType sig = m_signals[i]->EvaluateSignal();
                    if (sig != SIGNAL_NONE)
                        return sig;
                }
            }
            return SIGNAL_NONE;
        }

    public:
        // Implementação padrão para GetSignal
        virtual SignalType GetSignal()
        {
            return EvaluateSignals();
        }

        // Extended lifecycle stubs (override when needed)
        virtual void OnBar()           {}
        virtual void OnTimer()         {}
        virtual void OnOrderPlaced(const ulong ticket)     {}
        virtual void OnOrderFilled(const ulong ticket,
                                const double price,
                                const double volume) {}

};

