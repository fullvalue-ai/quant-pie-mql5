//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    LotManager.mqh                                          |
//| Purpose: Manager for position sizing using risk-based method     |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/PositionSizeCalculator.mqh>
#include <QuantPie/core/components/IComponent.mqh>

class LotManager : public IComponent
{
private:
    PositionSizeCalculator* m_calculator;

public:
    // Constructor
    LotManager(double riskPercent = 0.01)
    {
        m_calculator = new PositionSizeCalculator(riskPercent);
    }

    // Destructor
    ~LotManager()
    {
        if (m_calculator != NULL)
            delete m_calculator;
    }

    // Component lifecycle
    void OnInit() override {}

    void OnTick() override {}

    void OnTrade() override {}

    void OnDeinit(const int reason) override {}

    // Calculate lot size
    double CalculateLot(double stopLossDistancePips = 50)
    {
        if (m_calculator == NULL)
            return 0.0;

        return m_calculator->CalculateLot(stopLossDistancePips);
    }

    // Adjust risk if needed
    void SetRiskPercent(double riskPercent)
    {
        if (m_calculator != NULL)
            m_calculator->SetRiskPercent(riskPercent);
    }
};
