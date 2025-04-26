//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    OrderManager.mqh                                        |
//| Purpose: Manage trading orders (open, close, modify)             |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class OrderManager {
private:
    int m_magicNumber;
    double m_slippage;

public:
    OrderManager(int magicNumber = 0, double slippage = 5) {
        m_magicNumber = magicNumber;
        m_slippage = slippage;
    }

    bool OpenBuy(double lot, double price = 0.0, double sl = 0.0,
                double tp = 0.0);
    bool OpenSell(double lot, double price = 0.0, double sl = 0.0,
                double tp = 0.0);
    bool CloseOrder(ulong ticket);
    bool ModifyOrder(ulong ticket, double new_sl, double new_tp);

    void SetMagicNumber(int magicNumber) { m_magicNumber = magicNumber; }
    int GetMagicNumber() const { return m_magicNumber; }

    void SetSlippage(double slippage) { m_slippage = slippage; }
    double GetSlippage() const { return m_slippage; }
};
