//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    PositionManager.mqh                                     |
//| Purpose: Manage open positions (BreakEven, Trailing Stop, Close) |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class PositionManager
{
    private:
        double m_breakEvenDistance;    // Distance to trigger break even
        double m_trailingStart;        // Start trailing when profit reaches this
        double m_trailingDistance;     // Distance for trailing stop
        double m_stepSize;             // Step size for step stop

    public:
    PositionManager(double breakEvenDistance = 0.0, double trailingStart = 0.0, double trailingDistance = 0.0, double stepSize = 0.0)
        {
        m_breakEvenDistance = breakEvenDistance;
        m_trailingStart     = trailingStart;
        m_trailingDistance  = trailingDistance;
        m_stepSize          = stepSize;
        }

    // Management Methods
    bool ApplyBreakEven(ulong ticket);
    bool ApplyTrailingStop(ulong ticket);
    bool ApplyStepStop(ulong ticket);
    bool ClosePosition(ulong ticket);

    // Setters/Getters
    void SetBreakEvenDistance(double distance) { m_breakEvenDistance = distance; }
    double GetBreakEvenDistance() const { return m_breakEvenDistance; }

    void SetTrailingStart(double start) { m_trailingStart = start; }
    double GetTrailingStart() const { return m_trailingStart; }

    void SetTrailingDistance(double distance) { m_trailingDistance = distance; }
    double GetTrailingDistance() const { return m_trailingDistance; }

    void SetStepSize(double step) { m_stepSize = step; }
    double GetStepSize() const { return m_stepSize; }
};
//+------------------------------------------------------------------+