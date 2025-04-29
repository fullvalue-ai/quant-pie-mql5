//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    LotComponent.mqh                                          |
//| Purpose: Manager for position sizing using risk-based method     |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/helpers/PositionSizeCalculatorHelper.mqh>
#include <QuantPie/core/components/IComponent.mqh>

class LotComponent : public IComponent
{
private:
    PositionSizeCalculatorHelper* m_calculator;

public:
    // Constructor
    LotComponent(double riskPercent = 0.01)
    {
        m_calculator = new PositionSizeCalculatorHelper(riskPercent);
    }

    // Destructor
    ~LotComponent()
    {
        if (m_calculator != NULL)
            delete m_calculator;
    }

    // Component lifecycle
    void OnInit() {}

    void OnTick() {}

    void OnTrade() {}

    void OnDeinit() { }

    // Calculate lot size
    double CalculateLot(double stopLossDistancePips = 50)
    {
        if (m_calculator == NULL)
            return 0.0;

        return m_calculator.CalculateLot(stopLossDistancePips);
    }

    // Adjust risk if needed
    void SetRiskPercent(double riskPercent)
    {
        if (m_calculator != NULL)
            m_calculator.SetRiskPercent(riskPercent);
    }
};
