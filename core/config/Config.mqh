//+------------------------------------------------------------------+
//| File:    Config.mqh                                            |
//| Purpose: Execution configuration for EA systems (risk, order, session) |
//|                                                                  |
//| (c) 2024 FullValue.AI - All rights reserved                      |
//+------------------------------------------------------------------+
#property strict

// Generic key-value configuration for EA and signals
enum ConfigType { CONF_DOUBLE, CONF_INT, CONF_BOOL };

class Config
{
private:
    string   m_keys[];
    double   m_values[];
    ConfigType m_types[];

public:
    // Set a double value
    void Set(const string name, const double value)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
        {
            if(m_keys[i] == name)
            {
                m_values[i] = value;
                m_types[i] = CONF_DOUBLE;
                return;
            }
        }
        // New entry
        ArrayResize(m_keys,   ArraySize(m_keys) + 1);
        ArrayResize(m_values, ArraySize(m_values) + 1);
        ArrayResize(m_types,  ArraySize(m_types) + 1);
        int idx = ArraySize(m_keys) - 1;
        m_keys[idx]   = name;
        m_values[idx] = value;
        m_types[idx]  = CONF_DOUBLE;
    }

    // Set an int value
    void Set(const string name, const int value)
    {
        Set(name, (double)value);
        for(int i = 0; i < ArraySize(m_keys); i++)
            if(m_keys[i] == name) m_types[i] = CONF_INT;
    }

    // Set a bool value
    void Set(const string name, const bool value)
    {
        Set(name, value ? 1.0 : 0.0);
        for(int i = 0; i < ArraySize(m_keys); i++)
            if(m_keys[i] == name) m_types[i] = CONF_BOOL;
    }

    // Get a double
    double GetDouble(const string name, const double defaultValue = 0.0)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
            if(m_keys[i] == name && m_types[i] == CONF_DOUBLE)
                return m_values[i];
        return defaultValue;
    }

    // Get an int
    int GetInt(const string name, const int defaultValue = 0)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
            if(m_keys[i] == name && m_types[i] == CONF_INT)
                return (int)m_values[i];
        return defaultValue;
    }

    // Get a bool
    bool GetBool(const string name, const bool defaultValue = false)
    {
        for(int i = 0; i < ArraySize(m_keys); i++)
            if(m_keys[i] == name && m_types[i] == CONF_BOOL)
                return (m_values[i] != 0.0);
        return defaultValue;
    }
};
