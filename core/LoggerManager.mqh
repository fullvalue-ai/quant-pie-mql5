//+------------------------------------------------------------------+
//| Project: Quant-Pie MQL5                                          |
//| File:    LoggerManager.mqh                                       |
//| Purpose: Manage logging functionalities as a Component          |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

#include "IComponent.mqh"

// Log levels
enum LogLevel
{
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR
};

class LoggerManager : public IComponent
{
public:
    // Component Methods
    void OnInit() override
    {
        // Nothing to initialize for logging (yet)
    }

    void OnTick() override
    {
        // Nothing to do every tick
    }

    void OnTrade() override
    {
        // Nothing to do every trade by default
    }

    // Main Logger Method
    static void Log(string message, LogLevel level = LOG_INFO)
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
