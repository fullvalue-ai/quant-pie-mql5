//+------------------------------------------------------------------+
//| File:    EA_Sample.mq5                                           |
//| Purpose: EA wrapper for EA_SampleStrategy                        |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/config/SignalConfig.mqh>
#include <QuantPie/core/builders/EAConfig.mqh>
#include <QuantPie/core/builders/ComponentBuilder.mqh>
#include <QuantPie/strategies/EA_SampleStrategy.mqh>

//=== User inputs for signal configuration ===
input int          FastMA       = 5;
input int          SlowMA       = 20;
input ENUM_MA_METHOD MAType      = MODE_SMA;

//=== User inputs for execution configuration ===
input double       RiskPct        = 0.01;
input int          MagicNumber    = 2025;
input bool         UseBreakEven   = false;
input int          BreakEvenPips  = 10;
input bool         UseTrailing    = false;
input int          TrailingPips   = 20;
input int          SessStartH     = 0;
input int          SessStartM     = 0;
input int          SessEndH       = 23;
input int          SessEndM       = 59;

//=== Build configuration objects ===
SignalConfig sigCfg;
EAConfig     execCfg;
// fill signal config
void BuildConfigs()
{
    sigCfg.Set("fastMA",   FastMA);
    sigCfg.Set("slowMA",   SlowMA);
    sigCfg.Set("maMethod", (double)MAType);

    execCfg.riskPercent     = RiskPct;
    execCfg.magicNumber     = MagicNumber;
    execCfg.useBreakEven    = UseBreakEven;
    execCfg.breakEvenPips   = BreakEvenPips;
    execCfg.useTrailingStop = UseTrailing;
    execCfg.trailingStopPips= TrailingPips;
    execCfg.sessStartH      = SessStartH;
    execCfg.sessStartM      = SessStartM;
    execCfg.sessEndH        = SessEndH;
    execCfg.sessEndM        = SessEndM;
}

//=== Build DI container ===
DIContainer &container = *(DIContainer*)NULL;

int OnInit()
{
    BuildConfigs();
    ComponentBuilder builder;
    container = builder
        .ConfigureExecution(execCfg)
        .ConfigureSignal(sigCfg)
        .AddCoreComponents()
        .AddSignalComponent()
        .AddStrategy(new EA_SampleStrategy(sigCfg))
        .Build();

    container.OnInit();
    return(INIT_SUCCEEDED);
}

void OnTick()
{
    container.OnTick();
    // after tick, you can retrieve signal and act:
    SignalType sig = ((EA_SampleStrategy*)container).GetSignal();
    if(sig == SIGNAL_BUY)
        Print("SampleStrategy signaled BUY");
    else if(sig == SIGNAL_SELL)
        Print("SampleStrategy signaled SELL");
}

void OnTrade()
{
    container.OnTrade();
}

void OnDeinit(const int reason)
{
    container.OnDeinit();
}