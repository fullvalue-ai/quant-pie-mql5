//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    RiskManager.mqh                                         |
//| Purpose: Manage trading risk and plug as a Component             |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "IComponent.mqh"

class RiskManager : public IComponent
{
private:
    double m_riskPerTrade;
    int m_maxOpenPositions;
    double m_maxDailyLossPercent;
    double m_maxWeeklyLossPercent;
    double m_maxMonthlyLossPercent;
    int m_maxConsecutiveLosses;

    double m_startingDayBalance;
    double m_startingWeekBalance;
    double m_startingMonthBalance;

    int m_lastTradingDay;
    int m_lastTradingWeek;
    int m_lastTradingMonth;

    int m_currentConsecutiveLosses;

public:
    RiskManager(double riskPerTrade = 0.01, int maxOpenPositions = 5, 
                double maxDailyLossPercent = 5.0, double maxWeeklyLossPercent = 10.0, double maxMonthlyLossPercent = 20.0,
                int maxConsecutiveLosses = 3)
    {
        m_riskPerTrade = riskPerTrade;
        m_maxOpenPositions = maxOpenPositions;
        m_maxDailyLossPercent = maxDailyLossPercent;
        m_maxWeeklyLossPercent = maxWeeklyLossPercent;
        m_maxMonthlyLossPercent = maxMonthlyLossPercent;
        m_maxConsecutiveLosses = maxConsecutiveLosses;

        m_currentConsecutiveLosses = 0;
    }

    // Component Methods
    void OnInit() override
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

    void OnTick() override
    {
        // Nothing needed per tick for RiskManager now
    }

    void OnTrade() override
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
                {
                    RegisterTradeResult(profit);
                }
            }
        }
    }

    bool CanOpenNewTrade()
    {
        int totalPositions = PositionsTotal();
        if (totalPositions >= m_maxOpenPositions)
        {
            LoggerManager::Log("Cannot open new trade: max open positions limit reached.", LOG_WARNING);
            return false;
        }

        if (IsDailyLossExceeded() || IsWeeklyLossExceeded() || IsMonthlyLossExceeded() || IsConsecutiveLossLimitExceeded())
        {
            LoggerManager::Log("Cannot open new trade: loss limit exceeded (daily, weekly, monthly or sequence).", LOG_ERROR);
            return false;
        }

        return true;
    }

    bool CheckRiskParameters(double lot, double stopLossDistancePips)
    {
        if (lot <= 0.0 || stopLossDistancePips <= 0.0)
        {
            LoggerManager::Log("Risk Check Failed: lot or stop loss distance invalid.", LOG_ERROR);
            return false;
        }

        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        double riskAmountAllowed = accountBalance * m_riskPerTrade;

        double pointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        if (pointValue <= 0.0)
            pointValue = 0.0001; // fallback

        double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
        if (contractSize <= 0.0)
            contractSize = 1.0;

        double estimatedLoss = lot * contractSize * stopLossDistancePips * pointValue;

        if (estimatedLoss > riskAmountAllowed)
        {
            LoggerManager::Log("Risk Check Failed: estimated loss exceeds allowed per trade risk.", LOG_WARNING);
            return false;
        }

        return true;
    }

    void RegisterTradeResult(double profit)
    {
        if (profit < 0)
            m_currentConsecutiveLosses++;
        else
            m_currentConsecutiveLosses = 0;
    }

private:
    void RefreshBalances()
    {
        MqlDateTime timeStruct;
        TimeToStruct(TimeCurrent(), timeStruct);

        // New Day
        if (timeStruct.day != m_lastTradingDay)
        {
            m_lastTradingDay = timeStruct.day;
            m_startingDayBalance = AccountInfoDouble(ACCOUNT_BALANCE);
            m_currentConsecutiveLosses = 0;
        }

        // New Week
        if ((timeStruct.day_of_year / 7) != m_lastTradingWeek)
        {
            m_lastTradingWeek = timeStruct.day_of_year / 7;
            m_startingWeekBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        }

        // New Month
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
};
