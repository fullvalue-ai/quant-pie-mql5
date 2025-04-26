//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    RiskManager.mqh                                         |
//| Purpose: Handle risk management (limits, validations)           |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class RiskManager
{
    private:
    double m_maxRiskPerTrade;    // Risk % per trade
    int    m_maxOpenPositions;   // Maximum allowed open positions
    double m_maxDailyLoss;       // Maximum daily loss allowed

    public:
    RiskManager(double maxRiskPerTrade = 1.0, int maxOpenPositions = 5, double maxDailyLoss = 10.0)
        {
        m_maxRiskPerTrade  = maxRiskPerTrade;
        m_maxOpenPositions = maxOpenPositions;
        m_maxDailyLoss     = maxDailyLoss;
        }

    // Validations
    bool CanOpenNewTrade();
    bool CheckRiskParameters(double lots, double stopLossDistance);
    bool IsDailyLossExceeded();

    // Setters/Getters
    void SetMaxRiskPerTrade(double risk) { m_maxRiskPerTrade = risk; }
    double GetMaxRiskPerTrade() const { return m_maxRiskPerTrade; }

    void SetMaxOpenPositions(int positions) { m_maxOpenPositions = positions; }
    int GetMaxOpenPositions() const { return m_maxOpenPositions; }

    void SetMaxDailyLoss(double loss) { m_maxDailyLoss = loss; }
    double GetMaxDailyLoss() const { return m_maxDailyLoss; }
};
