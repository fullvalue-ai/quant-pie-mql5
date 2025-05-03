# Quant-Pie MQL5 - Modular EA Framework

An open-source modular framework for building Expert Advisors (EAs) on MetaTrader 5.

**Modern architecture** based on Core SDK modules, enabling fast, flexible, and professional EA development.

---

# Project Context

This project is an open-source framework designed to simplify the creation of Expert Advisors (EAs) for MetaTrader 5 (MT5). The primary goal is to enable modular and component-based development of trading robots, inspired by game engines like Unity. The framework emphasizes the use of components and lifecycles, extending beyond what MQL5 natively offers.

## Key Features

- **Componentization**: EAs are built using reusable components for common functionalities such as ticker management, timeframes, lot sizing, risk management, stop loss, take profit, breakeven, and step stop.
- **Lifecycle Management**: Components follow a structured lifecycle, allowing for clean initialization, updates, and deinitialization.
- **Visual Workflow**: The framework aims to support visual interface development, similar to workflow tools like n8n, enabling users to design EAs graphically.
- **Flexible Strategy Integration**: EAs act as the minimal "game object" and must implement a set of strategies connected by logical AND/OR conditions to generate trading signals.

## Design Philosophy

- **Open Source Principles**: The project adheres to open-source best practices, encouraging collaboration and transparency.
- **Architecture and Design Patterns**: The framework is built with a focus on maintainable and scalable architecture, leveraging design patterns where applicable.
- **English-Only Codebase**: All variables, comments, and documentation are written in English to ensure accessibility to a global audience.

---

This context serves as a guiding principle for the development and evolution of the Quant-Pie MQL5 framework.

---

## 🚀 Features

- **OrderComponent**: Safely opens, closes, and modifies trading orders.
- **RiskComponent**: Manages exposure, maximum number of open positions, and financial risk limits.
- **PositionComponent**: Automatically handles BreakEven, Trailing Stop, Step Stop, and position closing.
- **SessionComponent**: Defines valid trading session windows (e.g., from 09:00 to 17:00 server time).

---

## 🛠️ Installation

1. Clone this repository:

```bash
git clone https://github.com/fullvalue-ai/quant-pie-mql5.git
```

2. Create a symbolic link from the `quant-pie-mql5` folder to your MetaTrader 5 `MQL5/Include` folder.

Example (PowerShell):

```powershell
New-Item -ItemType SymbolicLink -Path "C:\Users\<your_username>\AppData\Roaming\MetaQuotes\Terminal\<your_mt5_hash>\MQL5\Include\quant-pie-mql5" -Target "C:\Path\To\Your\quant-pie-mql5"
```

3. Open MetaEditor and compile the sample EA:

- Navigate to `examples/EA_Sample.mq5`
- Click **Compile**

---

## 📈 Usage - Running EA_Sample

- Install the compiled EA on a trading chart (e.g., EURUSD).
- Adjust parameters if needed.
- The EA will open a **Buy** trade once:
  - It is within the allowed trading session.
  - No risk limits are violated.
- The **PositionComponent** will automatically manage BreakEven and Trailing Stop.

---

## 📚 Folder Structure

```plaintext
quant-pie-mql5/
├── core/            # Core modules (OrderComponent, RiskComponent, etc.)
├── strategies/      # Specific strategies
├── examples/        # Sample EAs
├── scripts/         # Helper scripts
├── docs/            # Additional documentation
├── .vscode/         # VSCode workspace settings
```

---

## 🤝 Contributing

Contributions are welcome!

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the [Apache 2.0 License](LICENSE).
