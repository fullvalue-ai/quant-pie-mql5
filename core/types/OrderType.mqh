#ifndef ORDER_TYPE_MQH
#define ORDER_TYPE_MQH

//+------------------------------------------------------------------+
//| File:    OrderType.mqh                                          |
//| Purpose: Enum for order types                                   |
//+------------------------------------------------------------------+
#property strict

enum ENUM_ORDER_TYPE {
   ORDER_MARKET,  // Market order
   ORDER_PENDING  // Pending order
};

#endif // ORDER_TYPE_MQH