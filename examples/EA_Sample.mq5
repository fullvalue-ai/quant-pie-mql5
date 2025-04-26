//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_Sample.mq5                                           |
//| Purpose: Sample EA based on EA_Template and Component System    |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/Templates/EA_Template.mqh>
#include <QuantPie/core/StrategyBase.mqh>
#include <QuantPie/core/SignalManager.mqh>
#include <QuantPie/core/LoggerManager.mqh>
#include <QuantPie/core/LotManager.mqh>

// Declare strategy instance
StrategyBase* strategy = NULL;

// Define a simple strategy
class SampleStrategy : public StrategyBase
{
private:
    SignalManager* m_signalManager;

public:
    SampleStrategy()
    {
        m_signalManager = new SignalManager(10, 50, MODE_SMA);
    }

    ~SampleStrategy()
    {
        if (m_signalManager != NULL)
            delete m_signalManager;
    }

    void OnInit() override
    {
        LoggerManager::Log("Sample Strategy Initialized.", LOG_INFO);
    }

    void OnTick() override
    {
        SignalType signal = m_signalManager.GetSignal();

        if (signal == SIGNAL_BUY)
        {
            LoggerManager::Log("SignalManager generated BUY signal.", LOG_INFO);
        }
        else if (signal == SIGNAL_SELL)
        {
            LoggerManager::Log("SignalManager generated SELL signal.", LOG_INFO);
        }
    }

    void OnTrade() override {}

    SignalType GetSignal() override
    {
        return m_signalManager.GetSignal();
    }
};
