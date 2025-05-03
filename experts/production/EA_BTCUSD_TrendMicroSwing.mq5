//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    EA_BTCUSD_TrendMicroSwing.mq5                           |
//| Purpose: EA wrapper using ComponentBuilder & DIContainer         |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/config/Config.mqh>
#include <QuantPie/core/builders/EAConfig.mqh>
#include <QuantPie/core/builders/ComponentBuilder.mqh>
#include <QuantPie/strategies/BTC_USD_TrendMicroSwing.mqh>

// ─ Inputs ─────────────────────────────────────────────────────────
input int          MagicNumber   = 2025;

input double       RiskPct       = 0.02;
input bool         UseBreakEven  = true;
input int          BreakEvenPips = 50;
input bool         UseTrailing   = true;
input int          TrailingPips  = 100;

input int          SessStartH    = 8;
input int          SessStartM    = 30;
input int          SessEndH      = 17;
input int          SessEndM      = 0;

input int          FastMA        = 9;
input int          SlowMA        = 21;
input ENUM_MA_METHOD MAType      = MODE_SMA;
input double       AtrMinimum    = 100.0;

// ─ Instantiate builder & container ───────────────────────────────
Config execCfg;
execCfg.Set("fastMA", FastMA);
execCfg.Set("slowMA", SlowMA);
execCfg.Set("maMethod", (double)MAType);
execCfg.Set("atrMin", AtrMinimum);
execCfg.Set("riskPercent", RiskPct);
execCfg.Set("magicNumber", MagicNumber);
execCfg.Set("useBreakEven", UseBreakEven);
execCfg.Set("breakEvenPips", BreakEvenPips);
execCfg.Set("useTrailing", UseTrailing);
execCfg.Set("trailingPips", TrailingPips);
execCfg.Set("sessStartH", SessStartH);
execCfg.Set("sessStartM", SessStartM);
execCfg.Set("sessEndH", SessEndH);
execCfg.Set("sessEndM", SessEndM);

ComponentBuilder builder(execCfg);
DIContainer &container = builder
    .AddStrategy(new BTC_USD_TrendMicroSwing(execCfg))
    .Build();

// ─ EA Entry Points ───────────────────────────────────────────────
int OnInit()
{
    container.OnInit();
    return(INIT_SUCCEEDED);
}

void OnTick()   { container.OnTick(); }
void OnTrade()  { container.OnTrade(); }
void OnDeinit(const int reason) { container.OnDeinit(); }
