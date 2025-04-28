//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    BTC_USD_TrendMicroSwing.mqh                             |
//| Purpose: Trend Following Micro Swing Strategy for BTC/USD        |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/StrategyBase.mqh>
#include <QuantPie/core/LoggerManager.mqh>
#include <QuantPie/core/RiskManager.mqh>
#include <QuantPie/core/LotManager.mqh>
#include <QuantPie/core/OrderManager.mqh>

class BTC_USD_TrendMicroSwing : public StrategyBase
{
private:
    LoggerManager logger;
    RiskManager* m_riskManager;
    LotManager* m_lotManager;
    OrderManager* m_orderManager;

    double atr_minimum;
    int fast_ma_period;
    int slow_ma_period;
    ENUM_MA_METHOD ma_method;
    ENUM_TIMEFRAMES timeframe;

public:
    BTC_USD_TrendMicroSwing()
    {
        atr_minimum = 100.0;
        fast_ma_period = 9;
        slow_ma_period = 21;
        ma_method = MODE_SMA;
        timeframe = PERIOD_H1;

        m_riskManager = NULL;
        m_lotManager = NULL;
        m_orderManager = NULL;
    }

    void OnInit() override
    {
        m_riskManager = new RiskManager();
        m_lotManager = new LotManager();
        m_orderManager = new OrderManager(123456); // Magic Number

        // Configure Risk Manager features
        m_riskManager->ConfigureATRStop(true, 2.0);
        m_riskManager->ConfigureBreakEven(true, 50);
        m_riskManager->ConfigureTrailingStop(true, 100, 50);

        logger.Log("BTC_USD_TrendMicroSwing Strategy Initialized.", LOG_INFO);
    }

    void OnTick() override
    {
        if (!m_riskManager->CanOpenNewTrade())
        {
            logger.Log("RiskManager blocked new trade.", LOG_WARNING);
            return;
        }

        double atr = iATR(NULL, timeframe, 14);
        if (atr < atr_minimum)
        {
            logger.Log("ATR below minimum. No trading.", LOG_INFO);
            return;
        }

        double fast_ma_current = iMA(NULL, timeframe, fast_ma_period, 0, ma_method, PRICE_CLOSE);
        double slow_ma_current = iMA(NULL, timeframe, slow_ma_period, 0, ma_method, PRICE_CLOSE);
        double fast_ma_previous = iMA(NULL, timeframe, fast_ma_period, 0, ma_method, PRICE_CLOSE);
        double slow_ma_previous = iMA(NULL, timeframe, slow_ma_period, 0, ma_method, PRICE_CLOSE);

        bool bullish_cross = (fast_ma_previous < slow_ma_previous) && (fast_ma_current > slow_ma_current);
        bool bearish_cross = (fast_ma_previous > slow_ma_previous) && (fast_ma_current < slow_ma_current);

        if (!bullish_cross && !bearish_cross)
        {
            logger.Log("No crossover detected.", LOG_INFO);
            return;
        }

        double lot = m_lotManager->CalculateLot();
        double stopLossDistance = 50;

        if (!m_riskManager->CheckRiskParameters(lot, stopLossDistance))
        {
            logger.Log("Risk parameters not acceptable.", LOG_WARNING);
            return;
        }

        double price = 0;
        double sl = 0;
        double tp = 0;
        double sl_distance = atr;
        double tp_distance = atr * 1.5;

        if (bullish_cross)
        {
            price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            sl = price - sl_distance;
            tp = price + tp_distance;
            if (m_orderManager->OpenBuy(lot, 0.0, sl, tp))
                logger.Log("Buy order placed.", LOG_INFO);
        }
        else if (bearish_cross)
        {
            price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            sl = price + sl_distance;
            tp = price - tp_distance;
            if (m_orderManager->OpenSell(lot, 0.0, sl, tp))
                logger.Log("Sell order placed.", LOG_INFO);
        }

        // Apply Risk Manager advanced features
        m_riskManager->ApplyBreakEven();
        m_riskManager->ApplyTrailingStop();
    }

    void OnTrade() override
    {
        m_riskManager->OnTrade();
    }

    void OnDeinit(const int reason) override
    {
        if (m_riskManager != NULL)
            delete m_riskManager;
        if (m_lotManager != NULL)
            delete m_lotManager;
        if (m_orderManager != NULL)
            delete m_orderManager;
    }

    SignalType GetSignal() override
    {
        return SIGNAL_NONE;
    }
};
