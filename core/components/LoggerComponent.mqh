//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    LoggerComponent.mqh                                       |
//| Purpose: Manage logging functionalities as a Component          |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include <QuantPie/core/components/IComponent.mqh>

// Log levels
enum LogLevel
{
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR
};

class LoggerComponent : public IComponent
{
private:
    DIContainer &m_container; // Referência ao DIContainer

public:
    // Construtor
    LoggerComponent(DIContainer &container)
        : m_container(container) {}

    // Métodos do componente
    void OnInit() {}

    void OnTick() {}

    void OnTrade() {}

    void OnDeinit() {}

    // Método principal do LoggerComponent
    static void Log(const string &message, LogLevel level = LOG_INFO)
    {
        string prefix;
        switch (level)
        {
            case LOG_INFO:
                prefix = "[INFO] ";
                break;
            case LOG_WARNING:
                prefix = "[WARNING] ";
                break;
            case LOG_ERROR:
                prefix = "[ERROR] ";
                break;
            default:
                prefix = "[LOG] ";
                break;
        }

        Print(prefix + message);
    }
};
