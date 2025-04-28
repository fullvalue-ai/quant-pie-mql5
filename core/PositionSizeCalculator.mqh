//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    PositionSizeCalculator.mqh                              |
//| Purpose: Professional Lot Size Calculator based on risk percent |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class PositionSizeCalculator
{
private:
    double m_riskPercent;

public:
    // Constructor
    PositionSizeCalculator(double riskPercent = 0.01)
    {
        m_riskPercent = riskPercent;
    }

    // Setters and Getters
    void SetRiskPercent(double riskPercent)
    {
        m_riskPercent = riskPercent;
    }

    double GetRiskPercent() const
    {
        return m_riskPercent;
    }

    // Core method to calculate lot size
    double CalculateLot(double stopLossDistancePips)
    {
        if (stopLossDistancePips <= 0.0)
            return 0.0;

        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        double riskAmount = accountBalance * m_riskPercent;

        double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
        double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
        double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);

        if (tickValue <= 0.0 || tickSize <= 0.0)
        {
            tickValue = 1.0;
            tickSize = 0.0001; // Fallbacks for some assets
        }

        double valuePerPip = tickValue / tickSize;
        if (valuePerPip <= 0.0)
            valuePerPip = 10.0; // Fallback for standard forex contracts

        double lotSize = riskAmount / (stopLossDistancePips * valuePerPip);

        double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
        double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
        double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

        // Clamp lot within broker limits
        lotSize = MathMax(minLot, MathMin(lotSize, maxLot));

        // Round to nearest lot step
        lotSize = NormalizeDouble(MathFloor(lotSize / lotStep) * lotStep, 2);

        return lotSize;
    }
};
