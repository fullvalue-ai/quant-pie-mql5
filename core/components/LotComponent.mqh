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
#include <QuantPie/core/DIContainer.mqh>

class LotComponent : public IComponent
{
private:
    DIContainer &m_container; // Referência ao DIContainer
    PositionSizeCalculatorHelper m_calculator;

public:
    // Construtor
    LotComponent(DIContainer &container, double riskPercent = 0.01)
        : m_container(container), m_calculator(riskPercent) {}

    // Ciclo de vida do componente
    void OnInit() {}

    void OnTick() {}

    void OnTrade() {}

    void OnDeinit() {}

    // Calcular tamanho do lote
    double CalculateLot(double stopLossDistancePips = 50)
    {
        return m_calculator.CalculateLot(stopLossDistancePips);
    }

    // Ajustar risco, se necessário
    void SetRiskPercent(double riskPercent)
    {
        m_calculator.SetRiskPercent(riskPercent);
    }
};
