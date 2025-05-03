//+------------------------------------------------------------------+
//| File:    EA_Sample.mq5                                           |
//| Purpose: EA wrapper for sample strategy using generic Config     |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/config/Config.mqh>
#include <QuantPie/core/builders/ComponentBuilder.mqh>
#include <QuantPie/strategies/EA_SampleStrategy.mqh>

//=== User inputs for execution configuration ===
input int          MagicNumber    = 2025;

input group "Session Manager";
input ENUM_TIMEFRAME Timeframe    = TIMEFRAME_0900;
input ENUM_TIMEFRAME TimeframeStart = TIMEFRAME_0900;
input ENUM_TIMEFRAME TimeframeEnd   = TIMEFRAME_1700;

input group "Risk Manager";
input double       RiskPct        = 0.01;
input bool         UseBreakEven   = false;
input int          BreakEvenPips  = 10;
input bool         UseTrailing    = false;
input int          TrailingPips   = 20;

input group "Session Manager";
input int          SessStartH     = 0;
input int          SessStartM     = 0;
input int          SessEndH       = 23;
input int          SessEndM       = 59;

input group "Strategy Parameters";
input int          FastMA         = 5;
input int          SlowMA         = 20;
input ENUM_MA_METHOD MAType       = MODE_SMA;


// Global container pointer
DIContainer* container = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Criar Config e passar para o ComponentBuilder
    Config cfg;
    cfg.Set("riskPercent", RiskPct);
    cfg.Set("magicNumber", MagicNumber);
    cfg.Set("useBreakEven", UseBreakEven);
    cfg.Set("breakEvenPips", BreakEvenPips);
    cfg.Set("useTrailingStop", UseTrailing);
    cfg.Set("trailingStopPips", TrailingPips);
    cfg.Set("sessStartH", SessStartH);
    cfg.Set("sessStartM", SessStartM);
    cfg.Set("sessEndH", SessEndH);
    cfg.Set("sessEndM", SessEndM);
    cfg.Set("fastMA", FastMA);
    cfg.Set("slowMA", SlowMA);
    cfg.Set("maMethod", (int)MAType);
    cfg.Set("timeframe", (int)Timeframe);
    cfg.Set("timeframeStart", (int)TimeframeStart);
    cfg.Set("timeframeEnd", (int)TimeframeEnd);

    ComponentBuilder builder(cfg);
    container = builder
        .AddStrategy(new EA_SampleStrategy(cfg))
        .Build();

    // Initialize all components and strategy
    container.OnInit();
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    container.OnTick();

    // Retrieve the strategy from the DI container
    EA_SampleStrategy *strategy = container->GetComponent<EA_SampleStrategy>();
    if (strategy != NULL)
    {
        // Example: retrieve and act on signal
        SignalType sig = strategy->GetSignal();
        if (sig == SIGNAL_BUY)
            Print("EA_SampleStrategy signaled BUY");
        else if (sig == SIGNAL_SELL)
            Print("EA_SampleStrategy signaled SELL");
    }
    else
    {
        Print("Error: EA_SampleStrategy not found in DI container.");
    }
}

//+------------------------------------------------------------------+
//| Trade event handler                                              |
//+------------------------------------------------------------------+
void OnTrade()
{
    container.OnTrade();
}

//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    container.OnDeinit();
    delete container;
}