//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    RiskComponent.mqh                                       |
//| Purpose: Full Risk Management (Limits + ATR + BreakEven + Trail) |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>
#include <Trade/Trade.mqh>
#include <QuantPie/core/DIContainer.mqh>

class RiskComponent : public IComponent
{
private:
    DIContainer &m_container; // Referência ao DIContainer

    // Core Limits
    double m_riskPerTrade;
    int    m_maxOpenPositions;
    double m_maxDailyLossPercent;
    double m_maxWeeklyLossPercent;
    double m_maxMonthlyLossPercent;
    int    m_maxConsecutiveLosses;

    // Balance control
    double m_startingDayBalance;
    double m_startingWeekBalance;
    double m_startingMonthBalance;
    int    m_lastTradingDay;
    int    m_lastTradingWeek;
    int    m_lastTradingMonth;
    int    m_currentConsecutiveLosses;

    // Advanced Features
    bool   m_useATRStop;
    bool   m_useBreakEven;
    bool   m_useTrailingStop;

    double m_atrMultiplier;
    double m_breakEvenDistance;
    double m_trailingStartDistance;
    double m_trailingDistance;

public:
    RiskComponent(DIContainer &container, double riskPerTrade = 0.01, int maxOpenPositions = 5, 
                double maxDailyLossPercent = 5.0, double maxWeeklyLossPercent = 10.0, double maxMonthlyLossPercent = 20.0,
                int maxConsecutiveLosses = 3)
        : m_container(container)
    {
        // Limits
        m_riskPerTrade = riskPerTrade;
        m_maxOpenPositions = maxOpenPositions;
        m_maxDailyLossPercent = maxDailyLossPercent;
        m_maxWeeklyLossPercent = maxWeeklyLossPercent;
        m_maxMonthlyLossPercent = maxMonthlyLossPercent;
        m_maxConsecutiveLosses = maxConsecutiveLosses;
        m_currentConsecutiveLosses = 0;

        // Advanced controls disabled by default
        m_useATRStop = false;
        m_useBreakEven = false;
        m_useTrailingStop = false;

        m_atrMultiplier = 2.0;
        m_breakEvenDistance = 50;
        m_trailingStartDistance = 100;
        m_trailingDistance = 50;
    }

    // Component methods
    void OnInit()
    {
        MqlDateTime timeStruct;
        TimeToStruct(TimeCurrent(), timeStruct);

        m_lastTradingDay = timeStruct.day;
        m_lastTradingWeek = timeStruct.day_of_year / 7;
        m_lastTradingMonth = timeStruct.mon;

        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        m_startingDayBalance = balance;
        m_startingWeekBalance = balance;
        m_startingMonthBalance = balance;
    }

    void OnTick() {}

    void OnTrade() 
    {
        HistorySelect(TimeCurrent() - 3600, TimeCurrent());
        uint deals = HistoryDealsTotal();

        for (uint i = 0; i < deals; i++)
        {
            ulong ticket = HistoryDealGetTicket(i);
            if (ticket > 0)
            {
                double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
                ENUM_DEAL_ENTRY entryType = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY);

                if (entryType == DEAL_ENTRY_OUT) // Only exits
                    RegisterTradeResult(profit);
            }
        }
    }

    void OnDeinit() {}

    // Public Risk Checks
    bool CanOpenNewTrade()
    {
        if (PositionsTotal() >= m_maxOpenPositions)
            return false;

        if (IsDailyLossExceeded() || IsWeeklyLossExceeded() || IsMonthlyLossExceeded() || IsConsecutiveLossLimitExceeded())
            return false;

        if (!CheckATRStop())
            return false;

        return true;
    }

    bool CheckRiskParameters(double lot, double stopLossDistancePips)
    {
        if (lot <= 0.0 || stopLossDistancePips <= 0.0)
            return false;

        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        double riskAmountAllowed = accountBalance * m_riskPerTrade;

        double pointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        if (pointValue <= 0.0)
            pointValue = 0.0001;

        double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
        if (contractSize <= 0.0)
            contractSize = 1.0;

        double estimatedLoss = lot * contractSize * stopLossDistancePips * pointValue;

        return (estimatedLoss <= riskAmountAllowed);
    }

    void ConfigureATRStop(bool useATRStop, double atrMultiplier)
    {
        m_useATRStop = useATRStop;
        m_atrMultiplier = atrMultiplier;
    }

    void ConfigureBreakEven(bool useBreakEven, double breakEvenDistance)
    {
        m_useBreakEven = useBreakEven;
        m_breakEvenDistance = breakEvenDistance;
    }

    void ConfigureTrailingStop(bool useTrailingStop, double trailingStartDistance, double trailingDistance)
    {
        m_useTrailingStop = useTrailingStop;
        m_trailingStartDistance = trailingStartDistance;
        m_trailingDistance = trailingDistance;
    }

    bool ApplyBreakEven()
    {
        if (!m_useBreakEven)
            return false;
        // Placeholder for real logic
        return true;
    }

    bool ApplyTrailingStop()
    {
        if (!m_useTrailingStop)
            return false;
        // Placeholder for real logic
        return true;
    }

private:
    // Internals
    void RefreshBalances()
    {
        MqlDateTime timeStruct;
        TimeToStruct(TimeCurrent(), timeStruct);

        if (timeStruct.day != m_lastTradingDay)
        {
            m_lastTradingDay = timeStruct.day;
            m_startingDayBalance = AccountInfoDouble(ACCOUNT_BALANCE);
            m_currentConsecutiveLosses = 0;
        }

        if ((timeStruct.day_of_year / 7) != m_lastTradingWeek)
        {
            m_lastTradingWeek = timeStruct.day_of_year / 7;
            m_startingWeekBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        }

        if (timeStruct.mon != m_lastTradingMonth)
        {
            m_lastTradingMonth = timeStruct.mon;
            m_startingMonthBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        }
    }

    bool IsDailyLossExceeded()
    {
        RefreshBalances();
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double lossPercent = ((m_startingDayBalance - balance) / m_startingDayBalance) * 100.0;
        return (lossPercent >= m_maxDailyLossPercent);
    }

    bool IsWeeklyLossExceeded()
    {
        RefreshBalances();
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double lossPercent = ((m_startingWeekBalance - balance) / m_startingWeekBalance) * 100.0;
        return (lossPercent >= m_maxWeeklyLossPercent);
    }

    bool IsMonthlyLossExceeded()
    {
        RefreshBalances();
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double lossPercent = ((m_startingMonthBalance - balance) / m_startingMonthBalance) * 100.0;
        return (lossPercent >= m_maxMonthlyLossPercent);
    }

    bool IsConsecutiveLossLimitExceeded()
    {
        return (m_currentConsecutiveLosses >= m_maxConsecutiveLosses);
    }

    bool CheckATRStop()
    {
        if (!m_useATRStop)
            return true;

        double atr = iATR(NULL, PERIOD_H1, 14);
        if (atr > 0 && atr * m_atrMultiplier > 1000)
            return false;

        return true;
    }

    void RegisterTradeResult(double profit)
    {
        if (profit < 0)
            m_currentConsecutiveLosses++;
        else
            m_currentConsecutiveLosses = 0;
    }
};
