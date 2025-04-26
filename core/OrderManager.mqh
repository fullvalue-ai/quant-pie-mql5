//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    OrderManager.mqh                                        |
//| Purpose: Manage order operations as a Component                 |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "IComponent.mqh"

class OrderManager : public IComponent
{
private:
    int m_magicNumber;
    double m_slippage;

public:
    OrderManager(int magicNumber = 0, double slippage = 5)
    {
        m_magicNumber = magicNumber;
        m_slippage = slippage;
    }

    // Component Methods
    void OnInit() override
    {
        // Nothing needed at initialization
    }

    void OnTick() override
    {
        // Nothing needed per tick
    }

    void OnTrade() override
    {
        // Nothing needed per trade
    }

    bool OpenBuy(double lot, double price = 0.0, double sl = 0.0, double tp = 0.0)
    {
        double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        if (price <= 0.0)
            price = ask;

        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action = TRADE_ACTION_DEAL;
        request.symbol = _Symbol;
        request.volume = lot;
        request.type = ORDER_TYPE_BUY;
        request.price = price;
        request.sl = sl;
        request.tp = tp;
        request.deviation = (int)m_slippage;
        request.type_filling = ORDER_FILLING_FOK;
        request.magic = m_magicNumber;

        if (!OrderSend(request, result))
        {
            LoggerManager::Log("Failed to open BUY order.", LOG_ERROR);
            return false;
        }

        return (result.retcode == TRADE_RETCODE_DONE);
    }

    bool OpenSell(double lot, double price = 0.0, double sl = 0.0, double tp = 0.0)
    {
        double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        if (price <= 0.0)
            price = bid;

        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action = TRADE_ACTION_DEAL;
        request.symbol = _Symbol;
        request.volume = lot;
        request.type = ORDER_TYPE_SELL;
        request.price = price;
        request.sl = sl;
        request.tp = tp;
        request.deviation = (int)m_slippage;
        request.type_filling = ORDER_FILLING_FOK;
        request.magic = m_magicNumber;

        if (!OrderSend(request, result))
        {
            LoggerManager::Log("Failed to open SELL order.", LOG_ERROR);
            return false;
        }

        return (result.retcode == TRADE_RETCODE_DONE);
    }

    bool CloseOrder(ulong ticket)
    {
        if (ticket == 0)
            return false;

        double volume = PositionGetDouble(POSITION_VOLUME);
        ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double price = (type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);

        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action = TRADE_ACTION_DEAL;
        request.position = ticket;
        request.symbol = _Symbol;
        request.volume = volume;
        request.type = (type == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
        request.price = price;
        request.deviation = (int)m_slippage;
        request.type_filling = ORDER_FILLING_FOK;
        request.magic = m_magicNumber;

        if (!OrderSend(request, result))
        {
            LoggerManager::Log("Failed to close order.", LOG_ERROR);
            return false;
        }

        return (result.retcode == TRADE_RETCODE_DONE);
    }

    bool ModifyOrder(ulong ticket, double new_sl, double new_tp)
    {
        if (ticket == 0)
            return false;

        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action = TRADE_ACTION_SLTP;
        request.position = ticket;
        request.symbol = _Symbol;
        request.sl = new_sl;
        request.tp = new_tp;
        request.magic = m_magicNumber;

        if (!OrderSend(request, result))
        {
            LoggerManager::Log("Failed to modify order.", LOG_ERROR);
            return false;
        }

        return (result.retcode == TRADE_RETCODE_DONE);
    }

    void SetMagicNumber(int magicNumber) { m_magicNumber = magicNumber; }
    int GetMagicNumber() const { return m_magicNumber; }

    void SetSlippage(double slippage) { m_slippage = slippage; }
    double GetSlippage() const { return m_slippage; }
};
