//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_BTCUSD_TrendMicroSwing.mq5                           |
//| Purpose: EA wrapper using ComponentBuilder & DIContainer         |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/config/SignalConfig.mqh>
#include <QuantPie/core/builders/EAConfig.mqh>
#include <QuantPie/core/builders/ComponentBuilder.mqh>
#include <QuantPie/strategies/BTC_USD_TrendMicroSwing.mqh>

// ─ Inputs ─────────────────────────────────────────────────────────
input double       RiskPct       = 0.02;
input bool         UseBreakEven  = true;
input int          BreakEvenPips = 50;
input bool         UseTrailing   = true;
input int          TrailingPips  = 100;
input int          MagicNumber   = 2025;
input int          SessStartH    = 8;
input int          SessStartM    = 30;
input int          SessEndH      = 17;
input int          SessEndM      = 0;

input int          FastMA        = 9;
input int          SlowMA        = 21;
input ENUM_MA_METHOD MAType      = MODE_SMA;
input double       AtrMinimum    = 100.0;

// ─ Build configs ──────────────────────────────────────────────────
SignalConfig sigCfg;
EAConfig      execCfg;

void BuildConfigs()
{
    sigCfg.Clear();
    sigCfg.Set("fastMA",    FastMA);
    sigCfg.Set("slowMA",    SlowMA);
    sigCfg.Set("maMethod",  (double)MAType);
    sigCfg.Set("atrMin",    AtrMinimum);

    execCfg.riskPercent   = RiskPct;
    execCfg.magicNumber   = MagicNumber;
    execCfg.useBreakEven  = UseBreakEven;
    execCfg.breakEvenPips = BreakEvenPips;
    execCfg.useTrailing   = UseTrailing;
    execCfg.trailingPips  = TrailingPips;
    execCfg.sessStartH    = SessStartH;
    execCfg.sessStartM    = SessStartM;
    execCfg.sessEndH      = SessEndH;
    execCfg.sessEndM      = SessEndM;
}

// ─ Instantiate builder & container ───────────────────────────────
ComponentBuilder builder;
DIContainer &container = builder
    .ConfigureExecution(execCfg)           // systems: risk, lot, order, session
    .ConfigureSignal(sigCfg)               // parameters for SignalComponent
    .AddCoreComponents()                   // logger, risk, lot, order, session
    .AddSignalComponent()                  // adds SignalComponent using sigCfg
    .AddStrategy(new BTC_USD_TrendMicroSwing(sigCfg))
    .Build();

// ─ EA Entry Points ───────────────────────────────────────────────
int OnInit()
{
    BuildConfigs();
    container.OnInit();
    return(INIT_SUCCEEDED);
}

void OnTick()   { container.OnTick(); }
void OnTrade()  { container.OnTrade(); }
void OnDeinit(const int reason) { container.OnDeinit(); }
