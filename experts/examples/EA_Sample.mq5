#include <QuantPie/core/managers/LoggerManager.mqh>
#include <QuantPie/core/managers/RiskManager.mqh>
#include <QuantPie/core/managers/LotManager.mqh>
#include <QuantPie/core/managers/OrderManager.mqh>
#include <QuantPie/core/managers/SessionManager.mqh>

LoggerManager logger;
RiskManager riskManager;
LotManager lotManager;
OrderManager orderManager(123456);
SessionManager sessionManager(0, 0, 23, 59); // Full 24h for now

int OnInit()
{
    logger.Log("EA Sample Started", LOG_INFO);

    // Example: configure features if desired
    riskManager.ConfigureATRStop(true, 2.0);
    riskManager.ConfigureBreakEven(true, 50);
    riskManager.ConfigureTrailingStop(true, 100, 50);

    riskManager.OnInit();
    return INIT_SUCCEEDED;
}

void OnTick()
{
    if (!sessionManager.IsWithinSession())
        return;

    if (!riskManager.CanOpenNewTrade())
        return;

    double lot = lotManager.CalculateLot();

    double stopLossDistance = 50; // Fixed stop for demo

    if (!riskManager.CheckRiskParameters(lot, stopLossDistance))
        return;

    if (orderManager.OpenBuy(lot))
        logger.Log("Buy Order Placed", LOG_INFO);

    // Manage active trades if needed
    riskManager.ApplyBreakEven();
    riskManager.ApplyTrailingStop();
}

void OnTrade()
{
    riskManager.OnTrade();
}

void OnDeinit(const int reason)
{
    riskManager.OnDeinit(reason);
}
