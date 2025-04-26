//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    LotManager.mqh                                          |
//| Purpose: Manage lot sizing based on risk as a Component          |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "IComponent.mqh"

class LotManager : public IComponent
{
private:
    double m_riskPerTrade;

public:
    LotManager(double riskPerTrade = 0.01)
    {
        m_riskPerTrade = riskPerTrade;
    }

    // Component Methods
    void OnInit() override
    {
        // Nothing to initialize for lot manager (yet)
    }

    void OnTick() override
    {
        // Nothing needed per tick
    }

    void OnTrade() override
    {
        // Nothing needed per trade
    }

    double CalculateLot(double stopLossDistancePips)
    {
        if (stopLossDistancePips <= 0.0)
            return 0.0;

        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        double riskAmount = accountBalance * m_riskPerTrade;

        double pointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        if (pointValue <= 0.0)
            pointValue = 0.0001; // fallback

        double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
        if (contractSize <= 0.0)
            contractSize = 1.0;

        double lot = riskAmount / (stopLossDistancePips * pointValue * contractSize);

        // Ajuste para múltiplo mínimo
        double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
        double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

        if (lot < minLot)
            lot = minLot;

        lot = MathFloor(lot / lotStep) * lotStep;
        lot = NormalizeDouble(lot, 2);

        return lot;
    }
};
