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
    // Storage for registered signal components
    ISignalComponent* m_signals[MAX_SIGNAL_COMPONENTS];
    int               m_signalCount;

public:
    // Constructor: initialize storage
    StrategyBase()
    {
        m_signalCount = 0;
        ArrayInitialize(m_signals, NULL);
    }

    // Destructor: call OnDeinit and free each component
    virtual ~StrategyBase()
    {
        for(int i = 0; i < m_signalCount; i++)
        {
            if(m_signals[i] != NULL)
            {
                m_signals[i]->OnDeinit();
                delete m_signals[i];
            }
        }
    }

    // Register a signal component (takes ownership)
    bool AddSignalComponent(ISignalComponent* component)
    {
        if(component == NULL || m_signalCount >= MAX_SIGNAL_COMPONENTS)
            return false;
        m_signals[m_signalCount++] = component;
        return true;
    }

    // IComponent lifecycle: propagate to all children
    void OnInit()
    {
        for(int i = 0; i < m_signalCount; i++)
            m_signals[i]->OnInit();
    }

    void OnTick()
    {
        for(int i = 0; i < m_signalCount; i++)
            m_signals[i]->OnTick();
    }

    void OnTrade()
    {
        for(int i = 0; i < m_signalCount; i++)
            m_signals[i]->OnTrade();
    }

    void OnDeinit()
    {
        for(int i = 0; i < m_signalCount; i++)
            m_signals[i]->OnDeinit();
    }

protected:
    // Evaluate all registered signals and return the first non-NONE
    SignalType EvaluateSignals()
    {
        for(int i = 0; i < m_signalCount; i++)
        {
            SignalType sig = m_signals[i]->EvaluateSignal();
            if(sig != SIGNAL_NONE)
                return sig;
        }
        return SIGNAL_NONE;
    }

public:
    // Default implementation returns the aggregated signal
    virtual SignalType GetSignal()
    {
        return EvaluateSignals();
    }
};
