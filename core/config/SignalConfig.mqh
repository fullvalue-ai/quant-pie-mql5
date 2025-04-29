//+------------------------------------------------------------------+
//| File:    SignalConfig.mqh                                       |
//| Purpose: Flexible key-value configuration for trading signals    |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

class SignalConfig
{
private:
    string m_keys[];
    double m_values[];

public:
    // Set or update a named parameter
    void Set(const string name, const double value)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
        {
            if(m_keys[i] == name)
            {
                m_values[i] = value;
                return;
            }
        }
        // New key
        ArrayResize(m_keys, ArraySize(m_keys) + 1);
        ArrayResize(m_values, ArraySize(m_values) + 1);
        m_keys[ArraySize(m_keys) - 1] = name;
        m_values[ArraySize(m_values) - 1] = value;
    }

    // Retrieve a parameter with a fallback default
    double Get(const string name, const double defaultValue = 0.0)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
        {
            if(m_keys[i] == name)
                return m_values[i];
        }
        return defaultValue;
    }

    // Check if a parameter exists
    bool Has(const string name)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
        {
            if(m_keys[i] == name)
                return true;
        }
        return false;
    }
};
