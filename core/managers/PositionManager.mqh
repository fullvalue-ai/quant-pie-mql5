//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    PositionManager.mqh                                     |
//| Purpose: Manage position protection (BreakEven, Trailing, Step)  |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class PositionManager
{
private:
    double m_breakEvenPips;
    bool   m_enableBreakEven;

    double m_trailingStopPips;
    bool   m_enableTrailingStop;

    double m_stepPips;
    bool   m_enableStepStop;

public:
    PositionManager(double breakEvenPips = 0, bool enableBreakEven = false,
                    double trailingStopPips = 0, bool enableTrailingStop = false,
                    double stepPips = 0, bool enableStepStop = false)
    {
        m_breakEvenPips = breakEvenPips;
        m_enableBreakEven = enableBreakEven;
        m_trailingStopPips = trailingStopPips;
        m_enableTrailingStop = enableTrailingStop;
        m_stepPips = stepPips;
        m_enableStepStop = enableStepStop;
    }

    void ApplyManagement()
    {
        if (PositionsTotal() <= 0)
            return;

        for (int i = PositionsTotal() - 1; i >= 0; i--)
        {
            ulong ticket = PositionGetTicket(i);
            if (ticket == 0)
                continue;

            ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentPrice = (type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double sl = PositionGetDouble(POSITION_SL);
            double tp = PositionGetDouble(POSITION_TP);

            double profitPips = (type == POSITION_TYPE_BUY) ?
                                (currentPrice - openPrice) / _Point :
                                (openPrice - currentPrice) / _Point;

            // BreakEven
            if (m_enableBreakEven && profitPips >= m_breakEvenPips)
            {
                double newSL = openPrice;
                ModifyPositionSL(ticket, newSL);
            }

            // Trailing Stop
            if (m_enableTrailingStop && profitPips > m_trailingStopPips)
            {
                double newSL;
                if (type == POSITION_TYPE_BUY)
                    newSL = currentPrice - m_trailingStopPips * _Point;
                else
                    newSL = currentPrice + m_trailingStopPips * _Point;

                ModifyPositionSL(ticket, newSL);
            }

            // Step Stop
            if (m_enableStepStop && m_stepPips > 0)
            {
                double stepsMoved = MathFloor(profitPips / m_stepPips);
                if (stepsMoved > 0)
                {
                    double newSL;
                    if (type == POSITION_TYPE_BUY)
                        newSL = openPrice + (stepsMoved * m_stepPips * _Point);
                    else
                        newSL = openPrice - (stepsMoved * m_stepPips * _Point);

                    ModifyPositionSL(ticket, newSL);
                }
            }
        }
    }

private:
    void ModifyPositionSL(ulong ticket, double newSL)
    {
        if (!PositionSelectByTicket(ticket))
            return;

        double currentSL = PositionGetDouble(POSITION_SL);
        ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

        if ((type == POSITION_TYPE_BUY && (currentSL == 0.0 || newSL > currentSL)) ||
            (type == POSITION_TYPE_SELL && (currentSL == 0.0 || newSL < currentSL)))
        {
            MqlTradeRequest request;
            MqlTradeResult  result;
            ZeroMemory(request);
            ZeroMemory(result);

            request.action = TRADE_ACTION_SLTP;
            request.symbol = _Symbol;
            request.position = ticket;
            request.sl = newSL;
            request.tp = PositionGetDouble(POSITION_TP);

            if (!OrderSend(request, result))
            {
                Print("ModifyPositionSL failed: ", GetLastError());
            }
        }
    }
};
