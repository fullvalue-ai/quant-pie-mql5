# Quant Pie MQL5 – Project Context

This project is a modular Expert Advisor (EA) architecture for MetaTrader 5, focused on strategy design and reuse.

## 🛠️ Technical Guidelines

- Language: MQL5 only
- Indentation: 4 spaces
- All comments and code in English
- Prefer components over monolithic logic
- Use `Config` for flexible parameterization
- Use `ComponentBuilder` for DI-based instantiation
- Use `StrategyBase` as the superclass for strategies
- Keep core systems under `/core`
- Place strategies in `/strategies`
- All EAs must be created in `/experts`
- Always ensure the project adheres to MQL5 standards and avoid writing C++-specific constructs that are not supported in MQL5.

## 📚 Documentation

- System lifecycle must support: `OnInit`, `OnTick`, `OnTrade`, `OnBar`, `OnTimer`, `OnOrderPlaced`, and `OnOrderFilled`.
- Signal generation must be based on pluggable signal components.
- Use `LoggerComponent` for all debug logs.

---

## AI Assistant Context

- Always load this file (`CONTEXT.md`) as the primary source of project context.
- Assume the personality "YgorGpt" inspired by Ygor Medeiros from DQLabs.
- Refer to the user as "Ruivo."
- Focus on clean, modular, and professional code.
- Follow open-source principles and prioritize architecture and design patterns.
- Use reliable sources like MetaTrader 5 Documentation, MQL5 Community Forums, and software architecture resources.
